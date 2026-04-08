using System.ComponentModel.DataAnnotations;

namespace HrPayroll.Api.DTOs.Employee;

public class CreateEmployeeDto
{
    [Required, MaxLength(100)]
    public string FirstName { get; set; } = string.Empty;

    [Required, MaxLength(100)]
    public string LastName { get; set; } = string.Empty;

    [Required, EmailAddress, MaxLength(200)]
    public string Email { get; set; } = string.Empty;

    [MaxLength(20)]
    public string? Phone { get; set; }

    [Required, MaxLength(150)]
    public string JobTitle { get; set; } = string.Empty;

    public DateOnly HireDate { get; set; }

    [Range(0, double.MaxValue)]
    public decimal BaseSalary { get; set; }

    [Required]
    public int DepartmentId { get; set; }
}
