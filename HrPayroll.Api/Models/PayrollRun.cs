namespace HrPayroll.Api.Models;

public class PayrollRun
{
    public int Id { get; set; }
    public int Month { get; set; }
    public int Year { get; set; }
    public DateTime ProcessedAt { get; set; }
    public bool IsLocked { get; set; } = false;
    public decimal TotalGross { get; set; }
    public decimal TotalNet { get; set; }

    public ICollection<PayrollLineItem> LineItems { get; set; } = new List<PayrollLineItem>();
}
