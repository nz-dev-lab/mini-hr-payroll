namespace HrPayroll.Api.Models;

public class AttendanceRecord
{
    public int Id { get; set; }
    public int EmployeeId { get; set; }
    public Employee Employee { get; set; } = null!;
    public DateOnly Date { get; set; }
    public string Status { get; set; } = string.Empty;
    public string? Notes { get; set; }
}
