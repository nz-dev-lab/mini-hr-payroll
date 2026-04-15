using HrPayroll.Api.DTOs.Payroll;

namespace HrPayroll.Api.Services.Interfaces;

public interface IPayrollService
{
    Task<IEnumerable<PayrollDto>> GetAllAsync(int? month = null, int? year = null);
    Task<PayrollDto?> GetByIdAsync(int id);
    Task<IEnumerable<PayrollLineItemDto>> GetRunDetailsAsync(int payrollRunId);
    Task<PayslipDto?> GetPayslipAsync(int payrollRunId, int employeeId);
    Task<PayrollDto> ProcessAsync(ProcessPayrollDto dto);
    Task<bool> DeleteAsync(int id);
}
