namespace HrPayroll.Api.DTOs.Payroll;

public class PayrollDto
{
    public int Id { get; set; }
    public int Month { get; set; }
    public int Year { get; set; }
    public DateTime ProcessedAt { get; set; }
    public bool IsLocked { get; set; }
    public decimal TotalGross { get; set; }
    public decimal TotalNet { get; set; }
    public int EmployeeCount { get; set; }
}
