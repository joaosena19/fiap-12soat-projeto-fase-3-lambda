using Amazon.Lambda.Core;
using Infrastructure.Authentication;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Shared.Enums;
using Shared.Exceptions;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace AuthLambda;

public class Function
{
    private readonly IAuthenticationService _authenticationService;
    private readonly IConfiguration _configuration;

    public Function()
    {
        // Construir configuração
        _configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
            .AddEnvironmentVariables()
            .Build();

        // Configurar injeção de dependência
        var serviceCollection = new ServiceCollection();
        ConfigureServices(serviceCollection);
        var serviceProvider = serviceCollection.BuildServiceProvider();

        _authenticationService = serviceProvider.GetRequiredService<IAuthenticationService>();
    }

    private void ConfigureServices(IServiceCollection services)
    {
        services.AddSingleton(_configuration);
        services.AddSingleton<ITokenService, TokenService>();
        services.AddSingleton<IAuthenticationService, AuthenticationService>();
    }

    public TokenResponseDto FunctionHandler(TokenRequestDto request, ILambdaContext context)
    {
        context.Logger.LogInformation($"Requisição de autenticação recebida para ClientId: {request?.ClientId}");

        try
        {
            if (request == null)
            {
                throw new DomainException("Request inválido", ErrorType.InvalidInput);
            }

            // Validar credenciais e gerar token
            var tokenResponse = _authenticationService.ValidateCredentialsAndGenerateToken(request);

            context.Logger.LogInformation("Token gerado com sucesso");
            return tokenResponse;
        }
        catch (DomainException ex)
        {
            context.Logger.LogError($"Domain exception: {ex.Message} - Tipo: {ex.ErrorType}");
            throw;
        }
        catch (Exception ex)
        {
            context.Logger.LogError($"Exception inesperada: {ex.Message}");
            throw new DomainException("Erro interno no servidor", ErrorType.UnexpectedError);
        }
    }
}
