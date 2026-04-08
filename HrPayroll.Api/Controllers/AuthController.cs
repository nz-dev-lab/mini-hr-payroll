using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using HrPayroll.Api.DTOs.Auth;
using HrPayroll.Api.Models;
using HrPayroll.Api.Services.Interfaces;

namespace HrPayroll.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly UserManager<AppUser> _userManager;
    private readonly RoleManager<IdentityRole> _roleManager;
    private readonly ITokenService _tokenService;

    public AuthController(
        UserManager<AppUser> userManager,
        RoleManager<IdentityRole> roleManager,
        ITokenService tokenService)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _tokenService = tokenService;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginDto dto)
    {
        var user = await _userManager.FindByEmailAsync(dto.Email);
        if (user is null || !await _userManager.CheckPasswordAsync(user, dto.Password))
            return Unauthorized(new { message = "Invalid email or password." });

        var token = await _tokenService.GenerateTokenAsync(user);
        var roles = await _userManager.GetRolesAsync(user);
        var expiry = DateTime.UtcNow.AddHours(8);

        return Ok(new AuthResponseDto
        {
            Token = token,
            ExpiresAt = expiry,
            User = new AuthUserDto
            {
                FullName = user.FullName,
                Email = user.Email!,
                Roles = roles
            }
        });
    }

    [Authorize(Roles = "Admin")]
    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterDto dto)
    {
        if (!await _roleManager.RoleExistsAsync(dto.Role))
            return BadRequest(new { message = $"Role '{dto.Role}' does not exist." });

        var user = new AppUser
        {
            FullName = dto.FullName,
            UserName = dto.Email,
            Email = dto.Email,
        };

        var result = await _userManager.CreateAsync(user, dto.Password);
        if (!result.Succeeded)
            return BadRequest(result.Errors);

        await _userManager.AddToRoleAsync(user, dto.Role);

        return Ok(new { message = $"User '{dto.Email}' created with role '{dto.Role}'." });
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<IActionResult> Me()
    {
        var user = await _userManager.FindByEmailAsync(User.Identity!.Name!);
        if (user is null) return Unauthorized();

        var roles = await _userManager.GetRolesAsync(user);
        return Ok(new AuthUserDto
        {
            FullName = user.FullName,
            Email = user.Email!,
            Roles = roles
        });
    }
}
