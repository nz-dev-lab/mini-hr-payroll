using Microsoft.EntityFrameworkCore;
using HrPayroll.Api.Data;
using HrPayroll.Api.DTOs.Department;
using HrPayroll.Api.Models;
using HrPayroll.Api.Services.Interfaces;

namespace HrPayroll.Api.Services.Implementations;

public class DepartmentService : IDepartmentService
{
    private readonly AppDbContext _db;

    public DepartmentService(AppDbContext db) => _db = db;

    public async Task<IEnumerable<DepartmentDto>> GetAllAsync()
    {
        return await _db.Departments
            .Include(d => d.Manager)
            .Select(d => ToDto(d, _db.Employees.Count(e => e.DepartmentId == d.Id)))
            .ToListAsync();
    }

    public async Task<DepartmentDto?> GetByIdAsync(int id)
    {
        var d = await _db.Departments.Include(d => d.Manager).FirstOrDefaultAsync(d => d.Id == id);
        if (d is null) return null;
        var count = await _db.Employees.CountAsync(e => e.DepartmentId == id);
        return ToDto(d, count);
    }

    public async Task<DepartmentDto> CreateAsync(CreateDepartmentDto dto)
    {
        var dept = new Department
        {
            Name = dto.Name,
            Description = dto.Description,
            ManagerId = dto.ManagerId
        };
        _db.Departments.Add(dept);
        await _db.SaveChangesAsync();
        if (dept.ManagerId.HasValue)
            await _db.Entry(dept).Reference(d => d.Manager).LoadAsync();
        return ToDto(dept, 0);
    }

    public async Task<DepartmentDto?> UpdateAsync(int id, UpdateDepartmentDto dto)
    {
        var dept = await _db.Departments.Include(d => d.Manager).FirstOrDefaultAsync(d => d.Id == id);
        if (dept is null) return null;

        if (dto.Name is not null) dept.Name = dto.Name;
        if (dto.Description is not null) dept.Description = dto.Description;
        if (dto.ManagerId is not null) dept.ManagerId = dto.ManagerId;

        await _db.SaveChangesAsync();
        if (dept.ManagerId.HasValue)
            await _db.Entry(dept).Reference(d => d.Manager).LoadAsync();
        var count = await _db.Employees.CountAsync(e => e.DepartmentId == id);
        return ToDto(dept, count);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var dept = await _db.Departments.FindAsync(id);
        if (dept is null) return false;
        _db.Departments.Remove(dept);
        await _db.SaveChangesAsync();
        return true;
    }

    private static DepartmentDto ToDto(Department d, int count) => new()
    {
        Id = d.Id,
        Name = d.Name,
        Description = d.Description,
        ManagerId = d.ManagerId,
        ManagerName = d.Manager is null ? null : $"{d.Manager.FirstName} {d.Manager.LastName}",
        EmployeeCount = count
    };
}
