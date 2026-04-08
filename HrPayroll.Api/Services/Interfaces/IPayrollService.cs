using HrPayroll.Api.DTOs.Payroll;
using HrPayroll.Api.Models;

namespace HrPayroll.Api.Services.Interfaces;

public interface IPayrollService
{
    Task<IEnumerable<PayrollDto>> GetAllAsync(int? employeeId = null);
    Task<PayrollDto?> GetByIdAsync(int id);
    Task<PayrollDto> CreateAsync(CreatePayrollDto dto);
    Task<PayrollDto?> UpdateStatusAsync(int id, PayrollStatus status);
    Task<bool> DeleteAsync(int id);
}
