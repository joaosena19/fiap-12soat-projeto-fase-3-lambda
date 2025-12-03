namespace Infrastructure.Authentication
{
    public interface ITokenService
    {
        string GenerateToken(string userId, List<string> roles);
    }
}
