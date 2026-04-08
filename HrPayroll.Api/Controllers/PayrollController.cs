using Microsoft.AspNetCore.Mvc;
using HrPayroll.Api.DTOs.Payroll;
using HrPayroll.Api.Services.Interfaces;

namespace HrPayroll.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PayrollController : ControllerBase
{
    private readonly IPayrollService _service;

    public PayrollController(IPayrollService service) => _service = service;

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? employeeId) =>
        Ok(await _service.GetAllAsync(employeeId));

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreatePayrollDto dto)
    {
        var created = await _service.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPatch("{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, UpdatePayrollStatusDto dto)
    {
        var result = await _service.UpdateStatusAsync(id, dto.Status);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _service.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }
}
