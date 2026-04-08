namespace HrPayroll.Api.Models;

public enum PayrollStatus
{
    Draft,
    Approved,
    Paid
}

public class PayrollRun
{
    public int Id { get; set; }
    public DateOnly PeriodStart { get; set; }
    public DateOnly PeriodEnd { get; set; }
    public decimal BasicSalary { get; set; }
    public decimal Allowances { get; set; }
    public decimal Deductions { get; set; }
    public decimal NetSalary => BasicSalary + Allowances - Deductions;
    public PayrollStatus Status { get; set; } = PayrollStatus.Draft;

    public int EmployeeId { get; set; }
    public Employee Employee { get; set; } = null!;
}
