using Microsoft.EntityFrameworkCore;
using HrPayroll.Api.Data;
using HrPayroll.Api.DTOs.Payroll;
using HrPayroll.Api.Models;
using HrPayroll.Api.Services.Interfaces;

namespace HrPayroll.Api.Services.Implementations;

public class PayrollService : IPayrollService
{
    private readonly AppDbContext _db;

    public PayrollService(AppDbContext db) => _db = db;

    public async Task<IEnumerable<PayrollDto>> GetAllAsync(int? employeeId = null)
    {
        var query = _db.PayrollRuns.Include(p => p.Employee).AsQueryable();
        if (employeeId.HasValue) query = query.Where(p => p.EmployeeId == employeeId.Value);
        return await query.OrderByDescending(p => p.PeriodStart).Select(p => ToDto(p)).ToListAsync();
    }

    public async Task<PayrollDto?> GetByIdAsync(int id)
    {
        var p = await _db.PayrollRuns.Include(p => p.Employee).FirstOrDefaultAsync(p => p.Id == id);
        return p is null ? null : ToDto(p);
    }

    public async Task<PayrollDto> CreateAsync(CreatePayrollDto dto)
    {
        var run = new PayrollRun
        {
            EmployeeId = dto.EmployeeId,
            PeriodStart = dto.PeriodStart,
            PeriodEnd = dto.PeriodEnd,
            BasicSalary = dto.BasicSalary,
            Allowances = dto.Allowances,
            Deductions = dto.Deductions,
            Status = PayrollStatus.Draft
        };
        _db.PayrollRuns.Add(run);
        await _db.SaveChangesAsync();
        await _db.Entry(run).Reference(p => p.Employee).LoadAsync();
        return ToDto(run);
    }

    public async Task<PayrollDto?> UpdateStatusAsync(int id, PayrollStatus status)
    {
        var run = await _db.PayrollRuns.Include(p => p.Employee).FirstOrDefaultAsync(p => p.Id == id);
        if (run is null) return null;
        run.Status = status;
        await _db.SaveChangesAsync();
        return ToDto(run);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var run = await _db.PayrollRuns.FindAsync(id);
        if (run is null) return false;
        _db.PayrollRuns.Remove(run);
        await _db.SaveChangesAsync();
        return true;
    }

    private static PayrollDto ToDto(PayrollRun p) => new()
    {
        Id = p.Id,
        EmployeeId = p.EmployeeId,
        EmployeeName = p.Employee is null ? string.Empty : $"{p.Employee.FirstName} {p.Employee.LastName}",
        PeriodStart = p.PeriodStart,
        PeriodEnd = p.PeriodEnd,
        BasicSalary = p.BasicSalary,
        Allowances = p.Allowances,
        Deductions = p.Deductions,
        NetSalary = p.BasicSalary + p.Allowances - p.Deductions,
        Status = p.Status
    };
}
