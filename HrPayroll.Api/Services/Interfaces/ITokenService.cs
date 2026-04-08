using HrPayroll.Api.Models;

namespace HrPayroll.Api.Services.Interfaces;

public interface ITokenService
{
    Task<string> GenerateTokenAsync(AppUser user);
}
