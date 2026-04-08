namespace HrPayroll.Api.Models;

public enum AttendanceStatus
{
    Present,
    Absent,
    Late,
    HalfDay
}

public class AttendanceRecord
{
    public int Id { get; set; }
    public DateOnly Date { get; set; }
    public TimeOnly? CheckIn { get; set; }
    public TimeOnly? CheckOut { get; set; }
    public AttendanceStatus Status { get; set; } = AttendanceStatus.Present;
    public string? Notes { get; set; }

    public int EmployeeId { get; set; }
    public Employee Employee { get; set; } = null!;
}
