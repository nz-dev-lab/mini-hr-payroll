using Microsoft.EntityFrameworkCore;
using HrPayroll.Api.Data;
using HrPayroll.Api.DTOs.Attendance;
using HrPayroll.Api.Models;
using HrPayroll.Api.Services.Interfaces;

namespace HrPayroll.Api.Services.Implementations;

public class AttendanceService : IAttendanceService
{
    private readonly AppDbContext _db;

    public AttendanceService(AppDbContext db) => _db = db;

    public async Task<IEnumerable<AttendanceDto>> GetAllAsync(int? employeeId = null, DateOnly? from = null, DateOnly? to = null)
    {
        var query = _db.AttendanceRecords.Include(a => a.Employee).AsQueryable();

        if (employeeId.HasValue) query = query.Where(a => a.EmployeeId == employeeId.Value);
        if (from.HasValue) query = query.Where(a => a.Date >= from.Value);
        if (to.HasValue) query = query.Where(a => a.Date <= to.Value);

        return await query.OrderByDescending(a => a.Date).Select(a => ToDto(a)).ToListAsync();
    }

    public async Task<AttendanceDto?> GetByIdAsync(int id)
    {
        var a = await _db.AttendanceRecords.Include(a => a.Employee).FirstOrDefaultAsync(a => a.Id == id);
        return a is null ? null : ToDto(a);
    }

    public async Task<AttendanceDto> CreateAsync(CreateAttendanceDto dto)
    {
        var record = new AttendanceRecord
        {
            EmployeeId = dto.EmployeeId,
            Date = dto.Date,
            CheckIn = dto.CheckIn,
            CheckOut = dto.CheckOut,
            Status = dto.Status,
            Notes = dto.Notes
        };
        _db.AttendanceRecords.Add(record);
        await _db.SaveChangesAsync();
        await _db.Entry(record).Reference(a => a.Employee).LoadAsync();
        return ToDto(record);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var record = await _db.AttendanceRecords.FindAsync(id);
        if (record is null) return false;
        _db.AttendanceRecords.Remove(record);
        await _db.SaveChangesAsync();
        return true;
    }

    private static AttendanceDto ToDto(AttendanceRecord a) => new()
    {
        Id = a.Id,
        EmployeeId = a.EmployeeId,
        EmployeeName = a.Employee is null ? string.Empty : $"{a.Employee.FirstName} {a.Employee.LastName}",
        Date = a.Date,
        CheckIn = a.CheckIn,
        CheckOut = a.CheckOut,
        Status = a.Status,
        Notes = a.Notes
    };
}
