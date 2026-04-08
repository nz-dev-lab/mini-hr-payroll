using System.ComponentModel.DataAnnotations;

namespace HrPayroll.Api.DTOs.Department;

public class UpdateDepartmentDto
{
    [MaxLength(100)]
    public string? Name { get; set; }

    [MaxLength(500)]
    public string? Description { get; set; }

    public int? ManagerId { get; set; }
}
