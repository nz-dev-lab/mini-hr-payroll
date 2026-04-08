namespace HrPayroll.Api.Models;

public class Department
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }

    // FK to Employee (manager)
    public int? ManagerId { get; set; }
    public Employee? Manager { get; set; }

    public ICollection<Employee> Employees { get; set; } = new List<Employee>();
}
