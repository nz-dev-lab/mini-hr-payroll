using System.Security.Cryptography;
using HrPayroll.Api.Data;
using HrPayroll.Api.DTOs.Employee;
using HrPayroll.Api.Services.Interfaces;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace HrPayroll.Api.Services.Implementations;

public class EmployeeService : IEmployeeService
{
    private readonly AppDbContext _db;
    public EmployeeService(AppDbContext db) => _db = db;

    // TODO: WOR-122 — implement using stored procedures
    public async Task<IEnumerable<EmployeeDto>> GetAllAsync(string? status = null, int? departmentId = null)
    {
        var results = await _db.Database.SqlQueryRaw<EmployeeDto>(
            "EXEC GetAllEmployees @Status, @DepartmentId",
            new SqlParameter("@Status", (object?)status ?? DBNull.Value),
            new SqlParameter("@DepartmentId", (object?)departmentId ?? DBNull.Value)
        ).ToListAsync();
        return results;
    }
    public async Task<EmployeeDto?> GetByIdAsync(int id)
    {
        var results = await _db.Database.SqlQueryRaw<EmployeeDto>(
            "EXEC GetEmployeeById @EmployeeId",
            SP.Param("@EmployeeId", id)
        )
        .ToListAsync();
        return results.FirstOrDefault();
    }
    public async Task<EmployeeDto> CreateAsync(CreateEmployeeDto dto)
{
    var newIdParam = SP.ParamOut("@NewEmployeeId", System.Data.SqlDbType.Int);

    await _db.Database.ExecuteSqlRawAsync(
        "EXEC CreateEmployee @FullName, @Designation, @DepartmentId, @JoinDate, @Nationality, @VisaType, @EmiratesId, @BankAccount, @BasicSalary, @HousingAllowance, @TransportAllowance, @NewEmployeeId OUTPUT",
        SP.Param("@FullName", dto.FullName),
        SP.Param("@Designation", dto.Designation),
        SP.Param("@DepartmentId", dto.DepartmentId),
        SP.Param("@JoinDate", dto.JoinDate),
        SP.Param("@Nationality", dto.Nationality),
        SP.Param("@VisaType", dto.VisaType),
        SP.Param("@EmiratesId", dto.EmiratesId),
        SP.Param("@BankAccount", dto.BankAccount),
        SP.Param("@BasicSalary", dto.BasicSalary),
        SP.Param("@HousingAllowance", dto.HousingAllowance),
        SP.Param("@TransportAllowance", dto.TransportAllowance),
        newIdParam
    );

    var newId = SP.GetInt(newIdParam);
    return (await GetByIdAsync(newId))!;
}

    public async Task<EmployeeDto?> UpdateAsync(int id, UpdateEmployeeDto dto)
    {
        var exists = await GetByIdAsync(id);
        if (exists is null) return null;

        await _db.Database.ExecuteSqlRawAsync(
            "EXEC UpdateEmployee @EmployeeId, @FullName, @Designation, @DepartmentId, @JoinDate, @Nationality, @VisaType, @EmiratesId, @BankAccount, @BasicSalary, @HousingAllowance, @TransportAllowance",
            SP.Param("@EmployeeId", id),
            SP.Param("@FullName", dto.FullName),
            SP.Param("@Designation", dto.Designation),
            SP.Param("@DepartmentId", dto.DepartmentId),
            SP.Param("@JoinDate", dto.JoinDate),
            SP.Param("@Nationality", dto.Nationality),
            SP.Param("@VisaType", dto.VisaType),
            SP.Param("@EmiratesId", dto.EmiratesId),
            SP.Param("@BankAccount", dto.BankAccount),
            SP.Param("@BasicSalary", dto.BasicSalary),
            SP.Param("@HousingAllowance", dto.HousingAllowance),
            SP.Param("@TransportAllowance", dto.TransportAllowance)
        );
        return (await GetByIdAsync(id))!;
    }
    public async Task<bool> TerminateAsync(int id)
    {
        var rows = await _db.Database.ExecuteSqlRawAsync(
            "EXEC TerminateEmployee @EmployeeId",
            SP.Param("@EmployeeId", id)
        );
        return rows > 0;
    }
}
