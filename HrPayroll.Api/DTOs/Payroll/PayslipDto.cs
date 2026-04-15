namespace HrPayroll.Api.DTOs.Payroll;

public class PayslipDto
{
    public int Id { get; set; }
    public int PayrollRunId { get; set; }
    public int Month { get; set; }
    public int Year { get; set; }
    public int EmployeeId { get; set; }
    public string EmployeeCode { get; set; } = string.Empty;
    public string EmployeeName { get; set; } = string.Empty;
    public string Designation { get; set; } = string.Empty;
    public string Department { get; set; } = string.Empty;
    public decimal BasicSalary { get; set; }
    public decimal HousingAllowance { get; set; }
    public decimal TransportAllowance { get; set; }
    public decimal GrossSalary { get; set; }
    public int AbsentDays { get; set; }
    public decimal AbsentDeduction { get; set; }
    public decimal NetSalary { get; set; }
}
