using HrPayroll.Api.DTOs.Attendance;

namespace HrPayroll.Api.Services.Interfaces;

public interface IAttendanceService
{
    Task<IEnumerable<AttendanceDto>> GetAllAsync(int? employeeId = null, DateOnly? from = null, DateOnly? to = null);
    Task<AttendanceDto?> GetByIdAsync(int id);
    Task<AttendanceDto> CreateAsync(CreateAttendanceDto dto);
    Task<bool> DeleteAsync(int id);
}
