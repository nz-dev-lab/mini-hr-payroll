using HrPayroll.Api.Data;
using HrPayroll.Api.DTOs.Attendance;
using HrPayroll.Api.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using System.Security.Cryptography;
namespace HrPayroll.Api.Services.Implementations;

public class AttendanceService : IAttendanceService
{
    private readonly AppDbContext _db;
    public AttendanceService(AppDbContext db) => _db = db;

    // TODO: WOR-123 — implement using stored procedures
    public async Task<IEnumerable<AttendanceDto>> GetAllAsync(int? employeeId = null, DateOnly? from = null, DateOnly? to = null)
    {
        var date = from ?? DateOnly.FromDateTime(DateTime.Today);

        var results = await _db.Database.SqlQueryRaw<AttendanceDto>(
            "EXEC GetMonthlyAttendance @EmployeeId, @Month, @Year",
            SP.Param("@EmployeeId", employeeId),
            SP.Param("@Month", date.Month),
            SP.Param("@Year", date.Year)
        ).ToListAsync();

        return results;
    }
    public async Task<AttendanceDto?> GetByIdAsync(int id)
    {
        var record = await _db.AttendanceRecords.Include(a => a.Employee).FirstOrDefaultAsync(a => a.Id == id);
        if (record is null) return null;
        return new AttendanceDto
        {
            Id = record.Id,
            EmployeeId = record.EmployeeId,
            EmployeeName = record.Employee.FullName,
            Date = record.Date,
            Status = record.Status,
            Notes = record.Notes
        };
    }
    public async Task<AttendanceDto> CreateAsync(CreateAttendanceDto dto)
    {
        var newIdParam = SP.ParamOut("@NewRecordId", System.Data.SqlDbType.Int);

        var result = await _db.Database.ExecuteSqlRawAsync(
            "EXEC MarkAttendance @EmployeeId, @Date, @Status, @Notes, @NewRecordId OUTPUT",
            SP.Param("@EmployeeId", dto.EmployeeId),
            SP.Param("@Date", dto.Date),
            SP.Param("@Status", dto.Status),
            SP.Param("@Notes", dto.Notes),
            newIdParam
        );

        var newId = SP.GetInt(newIdParam);
        return await GetByIdAsync(newId) ?? throw new Exception("Failed to retrieve newly created attendance record.");
    }
    public async Task<bool> DeleteAsync(int id)
    {
        return await _db.AttendanceRecords.Where(a => a.Id == id).ExecuteDeleteAsync() > 0;
    }
}
