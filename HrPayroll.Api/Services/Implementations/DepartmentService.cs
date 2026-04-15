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
            .Select(d => new DepartmentDto
            {
                Id = d.Id,
                Name = d.Name,
                Description = d.Description,
                EmployeeCount = _db.Employees.Count(e => e.DepartmentId == d.Id)
            })
            .ToListAsync();
    }

    public async Task<DepartmentDto?> GetByIdAsync(int id)
    {
        var d = await _db.Departments.FirstOrDefaultAsync(d => d.Id == id);
        if (d is null) return null;
        var count = await _db.Employees.CountAsync(e => e.DepartmentId == id);
        return new DepartmentDto { Id = d.Id, Name = d.Name, Description = d.Description, EmployeeCount = count };
    }

    public async Task<DepartmentDto> CreateAsync(CreateDepartmentDto dto)
    {
        var dept = new Department { Name = dto.Name, Description = dto.Description };
        _db.Departments.Add(dept);
        await _db.SaveChangesAsync();
        return new DepartmentDto { Id = dept.Id, Name = dept.Name, Description = dept.Description, EmployeeCount = 0 };
    }

    public async Task<DepartmentDto?> UpdateAsync(int id, UpdateDepartmentDto dto)
    {
        var dept = await _db.Departments.FirstOrDefaultAsync(d => d.Id == id);
        if (dept is null) return null;

        if (dto.Name is not null) dept.Name = dto.Name;
        if (dto.Description is not null) dept.Description = dto.Description;

        await _db.SaveChangesAsync();
        var count = await _db.Employees.CountAsync(e => e.DepartmentId == id);
        return new DepartmentDto { Id = dept.Id, Name = dept.Name, Description = dept.Description, EmployeeCount = count };
    }

    public async Task<DeleteResult> DeleteAsync(int id)
    {
        var dept = await _db.Departments.FindAsync(id);
        if (dept is null) return DeleteResult.NotFound;

        var hasEmployees = await _db.Employees.AnyAsync(e => e.DepartmentId == id);
        if (hasEmployees) return DeleteResult.HasEmployees;

        _db.Departments.Remove(dept);
        await _db.SaveChangesAsync();
        return DeleteResult.Success;
    }
}
