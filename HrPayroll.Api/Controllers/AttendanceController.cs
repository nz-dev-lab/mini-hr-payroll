using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HrPayroll.Api.DTOs.Attendance;
using HrPayroll.Api.Services.Interfaces;

namespace HrPayroll.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AttendanceController : ControllerBase
{
    private readonly IAttendanceService _service;

    public AttendanceController(IAttendanceService service) => _service = service;

    [HttpGet]
    public async Task<IActionResult> GetAll(
        [FromQuery] int? employeeId,
        [FromQuery] DateOnly? from,
        [FromQuery] DateOnly? to) =>
        Ok(await _service.GetAllAsync(employeeId, from, to));

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);
        return result is null ? NotFound() : Ok(result);
    }

    [Authorize(Roles = "Admin,HRManager")]
    [HttpPost]
    public async Task<IActionResult> Create(CreateAttendanceDto dto)
    {
        var created = await _service.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [Authorize(Roles = "Admin,HRManager")]
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _service.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }
}
