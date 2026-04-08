using System.ComponentModel.DataAnnotations;

namespace HrPayroll.Api.DTOs.Department;

public class CreateDepartmentDto
{
    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [MaxLength(500)]
    public string? Description { get; set; }

    public int? ManagerId { get; set; }
}
