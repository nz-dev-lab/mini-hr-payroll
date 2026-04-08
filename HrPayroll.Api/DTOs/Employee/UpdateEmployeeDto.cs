using System.ComponentModel.DataAnnotations;

namespace HrPayroll.Api.DTOs.Employee;

public class UpdateEmployeeDto
{
    [MaxLength(100)]
    public string? FirstName { get; set; }

    [MaxLength(100)]
    public string? LastName { get; set; }

    [EmailAddress, MaxLength(200)]
    public string? Email { get; set; }

    [MaxLength(20)]
    public string? Phone { get; set; }

    [MaxLength(150)]
    public string? JobTitle { get; set; }

    public DateOnly? HireDate { get; set; }

    [Range(0, double.MaxValue)]
    public decimal? BaseSalary { get; set; }

    public int? DepartmentId { get; set; }
    public bool? IsActive { get; set; }
}
