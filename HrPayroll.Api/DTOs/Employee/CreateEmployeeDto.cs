using System.ComponentModel.DataAnnotations;

namespace HrPayroll.Api.DTOs.Employee;

public class CreateEmployeeDto
{
    [Required, MaxLength(150)]
    public string FullName { get; set; } = string.Empty;

    [Required, MaxLength(100)]
    public string Designation { get; set; } = string.Empty;

    [Required]
    public int DepartmentId { get; set; }

    public DateTime JoinDate { get; set; }

    [Required, MaxLength(50)]
    public string Nationality { get; set; } = string.Empty;

    [Required, MaxLength(30)]
    public string VisaType { get; set; } = string.Empty;

    [MaxLength(20)]
    public string? EmiratesId { get; set; }

    [MaxLength(30)]
    public string? BankAccount { get; set; }

    [Range(0, double.MaxValue)]
    public decimal BasicSalary { get; set; }

    [Range(0, double.MaxValue)]
    public decimal HousingAllowance { get; set; }

    [Range(0, double.MaxValue)]
    public decimal TransportAllowance { get; set; }
}
