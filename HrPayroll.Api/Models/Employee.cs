namespace HrPayroll.Api.Models;

public class Employee
{
    public int Id { get; set; }
    public string EmployeeCode { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string Designation { get; set; } = string.Empty;
    public int DepartmentId { get; set; }
    public Department Department { get; set; } = null!;
    public DateTime JoinDate { get; set; }
    public string Nationality { get; set; } = string.Empty;
    public string VisaType { get; set; } = string.Empty;
    public string? EmiratesId { get; set; }
    public string? BankAccount { get; set; }
    public decimal BasicSalary { get; set; }
    public decimal HousingAllowance { get; set; }
    public decimal TransportAllowance { get; set; }
    public string Status { get; set; } = "Active";

    public ICollection<AttendanceRecord> AttendanceRecords { get; set; } = new List<AttendanceRecord>();
    public ICollection<PayrollLineItem> PayrollLineItems { get; set; } = new List<PayrollLineItem>();
    public LeaveBalance? LeaveBalance { get; set; }
}
