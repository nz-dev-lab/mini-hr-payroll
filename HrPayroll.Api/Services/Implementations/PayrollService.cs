using HrPayroll.Api.Data;
using HrPayroll.Api.DTOs.Payroll;
using HrPayroll.Api.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace HrPayroll.Api.Services.Implementations;

public class PayrollService : IPayrollService
{
    private readonly AppDbContext _db;
    public PayrollService(AppDbContext db) => _db = db;

    // TODO: WOR-125 — implement using stored procedures
    public async Task<IEnumerable<PayrollDto>> GetAllAsync(int? month = null, int? year = null)

    {
        var results = await _db.Database.SqlQueryRaw<PayrollDto>(
            "EXEC GetPayrollRuns @Month, @Year",
            SP.Param("@Month", month),
            SP.Param("@Year", year)
        ).ToListAsync();
        return results;
    }
    public async Task<PayrollDto?> GetByIdAsync(int id)
    {
        var record = await _db.PayrollRuns.FindAsync(id);
        if (record is null) return null;    
        return new PayrollDto
        {
            Id = record.Id,
            Month = record.Month,
            Year = record.Year,
            ProcessedAt = record.ProcessedAt,
            IsLocked = record.IsLocked, 
            TotalGross = record.TotalGross,
            TotalNet = record.TotalNet,
        };
    }
    public async Task<IEnumerable<PayrollLineItemDto>> GetRunDetailsAsync(int payrollRunId)
    {
        return await _db.Database.SqlQueryRaw<PayrollLineItemDto>(
            "EXEC GetPayrollRunDetails @PayrollRunId",
            SP.Param("@PayrollRunId", payrollRunId)
        ).ToListAsync();
    }

    public async Task<PayslipDto?> GetPayslipAsync(int payrollRunId, int employeeId)
    {
        return await _db.Database.SqlQueryRaw<PayslipDto>(
            "EXEC GetPayslip @PayrollRunId, @EmployeeId",
            SP.Param("@PayrollRunId", payrollRunId),
            SP.Param("@EmployeeId", employeeId)
        ).FirstOrDefaultAsync();
    }

    public async Task<PayrollDto> ProcessAsync(ProcessPayrollDto dto)
    {
        var newParamId = SP.ParamOut("@NewPayrollRunId", System.Data.SqlDbType.Int);
        await _db.Database.ExecuteSqlRawAsync(
            "EXEC ProcessMonthlyPayroll @Month, @Year, @NewPayrollRunId OUTPUT",
            SP.Param("@Month", dto.Month),
            SP.Param("@Year", dto.Year),
            newParamId
        );

        var newId = SP.GetInt(newParamId);
        if (newId <= 0) throw new Exception("Failed to process payroll.");
        return await GetByIdAsync(newId) ?? throw new Exception("Failed to retrieve payroll run.");
    }
    public async Task<bool> DeleteAsync(int id)
    {
        return await _db.PayrollRuns.Where(p => p.Id == id).ExecuteDeleteAsync() > 0;
    }
}
