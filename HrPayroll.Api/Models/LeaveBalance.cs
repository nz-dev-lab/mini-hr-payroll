namespace HrPayroll.Api.Models;

public class LeaveBalance
{
    public int Id { get; set; }
    public int EmployeeId { get; set; }
    public Employee Employee { get; set; } = null!;
    public int Year { get; set; }
    public int AnnualLeaveEntitlement { get; set; } = 30;
    public int AnnualLeaveUsed { get; set; } = 0;
    public int SickLeaveUsed { get; set; } = 0;
}
