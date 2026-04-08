using System.ComponentModel.DataAnnotations;
using HrPayroll.Api.Models;

namespace HrPayroll.Api.DTOs.Payroll;

public class UpdatePayrollStatusDto
{
    [Required]
    public PayrollStatus Status { get; set; }
}
