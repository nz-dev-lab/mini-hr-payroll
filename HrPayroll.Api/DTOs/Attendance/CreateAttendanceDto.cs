using System.ComponentModel.DataAnnotations;
using HrPayroll.Api.Models;

namespace HrPayroll.Api.DTOs.Attendance;

public class CreateAttendanceDto
{
    [Required]
    public int EmployeeId { get; set; }

    [Required]
    public DateOnly Date { get; set; }

    public TimeOnly? CheckIn { get; set; }
    public TimeOnly? CheckOut { get; set; }
    public AttendanceStatus Status { get; set; } = AttendanceStatus.Present;

    [MaxLength(500)]
    public string? Notes { get; set; }
}
