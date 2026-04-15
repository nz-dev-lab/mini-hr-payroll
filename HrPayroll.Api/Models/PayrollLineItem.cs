namespace HrPayroll.Api.Models;

public class PayrollLineItem
{
    public int Id { get; set; }
    public int PayrollRunId { get; set; }
    public PayrollRun PayrollRun { get; set; } = null!;
    public int EmployeeId { get; set; }
    public Employee Employee { get; set; } = null!;
    public decimal BasicSalary { get; set; }
    public decimal HousingAllowance { get; set; }
    public decimal TransportAllowance { get; set; }
    public decimal GrossSalary { get; set; }
    public int AbsentDays { get; set; }
    public decimal AbsentDeduction { get; set; }
    public decimal NetSalary { get; set; }
}
