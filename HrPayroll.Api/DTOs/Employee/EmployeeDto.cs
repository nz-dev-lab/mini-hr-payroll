namespace HrPayroll.Api.DTOs.Employee;

public class EmployeeDto
{
    public int Id { get; set; }
    public string EmployeeCode { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string Designation { get; set; } = string.Empty;
    public int DepartmentId { get; set; }
    public string DepartmentName { get; set; } = string.Empty;
    public DateTime JoinDate { get; set; }
    public string Nationality { get; set; } = string.Empty;
    public string VisaType { get; set; } = string.Empty;
    public string? EmiratesId { get; set; }
    public string? BankAccount { get; set; }
    public decimal BasicSalary { get; set; }
    public decimal HousingAllowance { get; set; }
    public decimal TransportAllowance { get; set; }
    public decimal GrossSalary { get; set; }
    public string Status { get; set; } = string.Empty;
    public int? AnnualLeaveEntitlement { get; set; }
    public int? AnnualLeaveUsed { get; set; }
    public int? AnnualLeaveRemaining { get; set; }
    public int? SickLeaveUsed { get; set; }
}
