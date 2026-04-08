using Microsoft.AspNetCore.Identity;

namespace HrPayroll.Api.Models;

public class AppUser : IdentityUser
{
    public string FullName { get; set; } = string.Empty;
}
