using System.ComponentModel.DataAnnotations;

namespace HrPayroll.Api.DTOs.Payroll;

public class CreatePayrollDto
{
    [Required]
    public int EmployeeId { get; set; }

    [Required]
    public DateOnly PeriodStart { get; set; }

    [Required]
    public DateOnly PeriodEnd { get; set; }

    [Range(0, double.MaxValue)]
    public decimal BasicSalary { get; set; }

    [Range(0, double.MaxValue)]
    public decimal Allowances { get; set; }

    [Range(0, double.MaxValue)]
    public decimal Deductions { get; set; }
}
