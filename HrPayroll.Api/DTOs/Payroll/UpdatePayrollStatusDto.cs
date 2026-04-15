using System.ComponentModel.DataAnnotations;

namespace HrPayroll.Api.DTOs.Payroll;

public class ProcessPayrollDto
{
    [Required, Range(1, 12)]
    public int Month { get; set; }

    [Required]
    public int Year { get; set; }
}
