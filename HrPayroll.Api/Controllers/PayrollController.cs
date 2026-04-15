using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HrPayroll.Api.DTOs.Payroll;
using HrPayroll.Api.Services.Interfaces;

namespace HrPayroll.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PayrollController : ControllerBase
{
    private readonly IPayrollService _service;
    public PayrollController(IPayrollService service) => _service = service;

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? month = null, [FromQuery] int? year = null) =>
        Ok(await _service.GetAllAsync(month, year));

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpGet("{id:int}/details")]
    public async Task<IActionResult> GetRunDetails(int id) =>
        Ok(await _service.GetRunDetailsAsync(id));

    [HttpGet("{id:int}/payslip/{employeeId:int}")]
    public async Task<IActionResult> GetPayslip(int id, int employeeId)
    {
        var result = await _service.GetPayslipAsync(id, employeeId);
        return result is null ? NotFound() : Ok(result);
    }

    [Authorize(Roles = "Admin,PayrollOfficer")]
    [HttpPost("process")]
    public async Task<IActionResult> Process(ProcessPayrollDto dto)
    {
        var result = await _service.ProcessAsync(dto);
        return Ok(result);
    }

    [Authorize(Roles = "Admin")]
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _service.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }
}
