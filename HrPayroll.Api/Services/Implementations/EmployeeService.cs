using Microsoft.EntityFrameworkCore;
using HrPayroll.Api.Data;
using HrPayroll.Api.DTOs.Employee;
using HrPayroll.Api.Models;
using HrPayroll.Api.Services.Interfaces;

namespace HrPayroll.Api.Services.Implementations;

public class EmployeeService : IEmployeeService
{
    private readonly AppDbContext _db;

    public EmployeeService(AppDbContext db) => _db = db;

    public async Task<IEnumerable<EmployeeDto>> GetAllAsync()
    {
        return await _db.Employees
            .Include(e => e.Department)
            .Select(e => ToDto(e))
            .ToListAsync();
    }

    public async Task<EmployeeDto?> GetByIdAsync(int id)
    {
        var e = await _db.Employees.Include(e => e.Department).FirstOrDefaultAsync(e => e.Id == id);
        return e is null ? null : ToDto(e);
    }

    public async Task<EmployeeDto> CreateAsync(CreateEmployeeDto dto)
    {
        var employee = new Employee
        {
            FirstName = dto.FirstName,
            LastName = dto.LastName,
            Email = dto.Email,
            Phone = dto.Phone,
            JobTitle = dto.JobTitle,
            HireDate = dto.HireDate,
            BaseSalary = dto.BaseSalary,
            DepartmentId = dto.DepartmentId,
            IsActive = true
        };
        _db.Employees.Add(employee);
        await _db.SaveChangesAsync();
        await _db.Entry(employee).Reference(e => e.Department).LoadAsync();
        return ToDto(employee);
    }

    public async Task<EmployeeDto?> UpdateAsync(int id, UpdateEmployeeDto dto)
    {
        var employee = await _db.Employees.Include(e => e.Department).FirstOrDefaultAsync(e => e.Id == id);
        if (employee is null) return null;

        if (dto.FirstName is not null) employee.FirstName = dto.FirstName;
        if (dto.LastName is not null) employee.LastName = dto.LastName;
        if (dto.Email is not null) employee.Email = dto.Email;
        if (dto.Phone is not null) employee.Phone = dto.Phone;
        if (dto.JobTitle is not null) employee.JobTitle = dto.JobTitle;
        if (dto.HireDate is not null) employee.HireDate = dto.HireDate.Value;
        if (dto.BaseSalary is not null) employee.BaseSalary = dto.BaseSalary.Value;
        if (dto.DepartmentId is not null) employee.DepartmentId = dto.DepartmentId.Value;
        if (dto.IsActive is not null) employee.IsActive = dto.IsActive.Value;

        await _db.SaveChangesAsync();
        await _db.Entry(employee).Reference(e => e.Department).LoadAsync();
        return ToDto(employee);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var employee = await _db.Employees.FindAsync(id);
        if (employee is null) return false;
        _db.Employees.Remove(employee);
        await _db.SaveChangesAsync();
        return true;
    }

    private static EmployeeDto ToDto(Employee e) => new()
    {
        Id = e.Id,
        FirstName = e.FirstName,
        LastName = e.LastName,
        Email = e.Email,
        Phone = e.Phone,
        JobTitle = e.JobTitle,
        HireDate = e.HireDate,
        BaseSalary = e.BaseSalary,
        IsActive = e.IsActive,
        DepartmentId = e.DepartmentId,
        DepartmentName = e.Department?.Name ?? string.Empty
    };
}
