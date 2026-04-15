using System.ComponentModel.DataAnnotations;

namespace HrPayroll.Api.DTOs.Attendance;

public class CreateAttendanceDto
{
    [Required]
    public int EmployeeId { get; set; }

    [Required]
    public DateOnly Date { get; set; }

    [Required, MaxLength(20)]
    public string Status { get; set; } = "Present";

    [MaxLength(500)]
    public string? Notes { get; set; }
}
