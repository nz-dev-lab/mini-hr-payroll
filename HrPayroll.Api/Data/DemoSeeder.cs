using HrPayroll.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace HrPayroll.Api.Data;

public static class DemoSeeder
{
    public static async Task SeedAsync(AppDbContext db)
    {
        // Skip if data already exists
        if (await db.Departments.AnyAsync()) return;

        // ── Departments ──────────────────────────────────────────────────────
        var depts = new[]
        {
            new Department { Name = "Engineering",     Description = "Software development and infrastructure",  CreatedAt = DateTime.UtcNow },
            new Department { Name = "Human Resources", Description = "People operations and recruitment",        CreatedAt = DateTime.UtcNow },
            new Department { Name = "Finance",         Description = "Accounting, payroll and budgeting",        CreatedAt = DateTime.UtcNow },
            new Department { Name = "Sales",           Description = "Business development and client accounts", CreatedAt = DateTime.UtcNow },
            new Department { Name = "Operations",      Description = "Logistics and facilities management",      CreatedAt = DateTime.UtcNow },
        };
        db.Departments.AddRange(depts);
        await db.SaveChangesAsync();

        int eng = depts[0].Id, hr = depts[1].Id, fin = depts[2].Id, sales = depts[3].Id, ops = depts[4].Id;

        // ── Employees ────────────────────────────────────────────────────────
        var employees = new[]
        {
            new Employee { EmployeeCode = "EMP-001", FullName = "Ahmed Al Mansouri", Designation = "Senior Software Engineer", DepartmentId = eng,   JoinDate = new DateTime(2021, 3,  15), Nationality = "Emirati",   VisaType = "Employment", EmiratesId = "784-1990-1234567-1", BankAccount = "AE070331234567890123456", BasicSalary = 18000, HousingAllowance = 5000, TransportAllowance = 1500, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-002", FullName = "Sara Khan",         Designation = "HR Manager",               DepartmentId = hr,    JoinDate = new DateTime(2020, 6,   1), Nationality = "Pakistani", VisaType = "Employment", EmiratesId = "784-1985-2345678-2", BankAccount = "AE070332345678901234567", BasicSalary = 15000, HousingAllowance = 4500, TransportAllowance = 1200, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-003", FullName = "James Okafor",      Designation = "Finance Analyst",           DepartmentId = fin,   JoinDate = new DateTime(2022, 1,  10), Nationality = "Nigerian",  VisaType = "Employment", EmiratesId = "784-1992-3456789-3", BankAccount = "AE070333456789012345678", BasicSalary = 12000, HousingAllowance = 3500, TransportAllowance = 1000, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-004", FullName = "Priya Nair",        Designation = "Sales Executive",           DepartmentId = sales, JoinDate = new DateTime(2021, 9,  20), Nationality = "Indian",    VisaType = "Employment", EmiratesId = "784-1993-4567890-4", BankAccount = "AE070334567890123456789", BasicSalary = 10000, HousingAllowance = 3000, TransportAllowance =  800, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-005", FullName = "Mohammed Al Farsi", Designation = "Operations Manager",        DepartmentId = ops,   JoinDate = new DateTime(2019, 11,  5), Nationality = "Emirati",   VisaType = "Employment", EmiratesId = "784-1988-5678901-5", BankAccount = "AE070335678901234567890", BasicSalary = 20000, HousingAllowance = 6000, TransportAllowance = 2000, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-006", FullName = "Fatima Al Zaabi",   Designation = "Junior Developer",          DepartmentId = eng,   JoinDate = new DateTime(2023, 2,  14), Nationality = "Emirati",   VisaType = "Employment", EmiratesId = "784-1998-6789012-6", BankAccount = "AE070336789012345678901", BasicSalary =  9000, HousingAllowance = 2500, TransportAllowance =  800, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-007", FullName = "David Mensah",      Designation = "Accountant",                DepartmentId = fin,   JoinDate = new DateTime(2020, 8,  22), Nationality = "Ghanaian",  VisaType = "Employment", EmiratesId = "784-1987-7890123-7", BankAccount = "AE070337890123456789012", BasicSalary = 11000, HousingAllowance = 3200, TransportAllowance =  900, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-008", FullName = "Layla Hassan",      Designation = "HR Officer",                DepartmentId = hr,    JoinDate = new DateTime(2022, 5,  30), Nationality = "Egyptian",  VisaType = "Employment", EmiratesId = "784-1994-8901234-8", BankAccount = "AE070338901234567890123", BasicSalary =  9500, HousingAllowance = 2800, TransportAllowance =  800, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-009", FullName = "Ravi Sharma",       Designation = "Sales Manager",             DepartmentId = sales, JoinDate = new DateTime(2018, 4,  12), Nationality = "Indian",    VisaType = "Employment", EmiratesId = "784-1982-9012345-9", BankAccount = "AE070339012345678901234", BasicSalary = 16000, HousingAllowance = 4800, TransportAllowance = 1500, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-010", FullName = "Nora Johansson",    Designation = "DevOps Engineer",           DepartmentId = eng,   JoinDate = new DateTime(2022, 11,  1), Nationality = "Swedish",   VisaType = "Employment", EmiratesId = "784-1991-0123456-0", BankAccount = "AE070330123456789012345", BasicSalary = 17000, HousingAllowance = 5000, TransportAllowance = 1500, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-011", FullName = "Khalid Al Rashidi", Designation = "Finance Manager",           DepartmentId = fin,   JoinDate = new DateTime(2017, 7,  18), Nationality = "Emirati",   VisaType = "Employment", EmiratesId = "784-1980-1234568-1", BankAccount = "AE070331234568901234567", BasicSalary = 22000, HousingAllowance = 7000, TransportAllowance = 2000, Status = "Active"     },
            new Employee { EmployeeCode = "EMP-012", FullName = "Maria Santos",      Designation = "Operations Coordinator",    DepartmentId = ops,   JoinDate = new DateTime(2023, 1,   9), Nationality = "Filipino",  VisaType = "Employment", EmiratesId = "784-1995-2345679-2", BankAccount = "AE070332345679012345678", BasicSalary =  8500, HousingAllowance = 2500, TransportAllowance =  700, Status = "Terminated" },
        };
        db.Employees.AddRange(employees);
        await db.SaveChangesAsync();

        int[] eId = employees.Select(e => e.Id).ToArray();

        // ── Leave Balances ───────────────────────────────────────────────────
        db.LeaveBalances.AddRange(
            new LeaveBalance { EmployeeId = eId[0],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 5,  SickLeaveUsed = 2 },
            new LeaveBalance { EmployeeId = eId[1],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 8,  SickLeaveUsed = 0 },
            new LeaveBalance { EmployeeId = eId[2],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 2,  SickLeaveUsed = 1 },
            new LeaveBalance { EmployeeId = eId[3],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 0,  SickLeaveUsed = 0 },
            new LeaveBalance { EmployeeId = eId[4],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 12, SickLeaveUsed = 3 },
            new LeaveBalance { EmployeeId = eId[5],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 0,  SickLeaveUsed = 0 },
            new LeaveBalance { EmployeeId = eId[6],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 6,  SickLeaveUsed = 2 },
            new LeaveBalance { EmployeeId = eId[7],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 3,  SickLeaveUsed = 1 },
            new LeaveBalance { EmployeeId = eId[8],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 10, SickLeaveUsed = 0 },
            new LeaveBalance { EmployeeId = eId[9],  Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 1,  SickLeaveUsed = 0 },
            new LeaveBalance { EmployeeId = eId[10], Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 15, SickLeaveUsed = 5 },
            new LeaveBalance { EmployeeId = eId[11], Year = 2026, AnnualLeaveEntitlement = 30, AnnualLeaveUsed = 4,  SickLeaveUsed = 1 }
        );
        await db.SaveChangesAsync();

        // ── Attendance Records (April 2026, active employees) ────────────────
        var attendance = new List<AttendanceRecord>
        {
            // Ahmed Al Mansouri (0)
            new() { EmployeeId = eId[0], Date = new DateOnly(2026, 4, 1),  Status = "Present",     Notes = null },
            new() { EmployeeId = eId[0], Date = new DateOnly(2026, 4, 2),  Status = "Present",     Notes = null },
            new() { EmployeeId = eId[0], Date = new DateOnly(2026, 4, 3),  Status = "Present",     Notes = null },
            new() { EmployeeId = eId[0], Date = new DateOnly(2026, 4, 6),  Status = "Present",     Notes = null },
            new() { EmployeeId = eId[0], Date = new DateOnly(2026, 4, 7),  Status = "AnnualLeave", Notes = "Pre-approved leave" },
            new() { EmployeeId = eId[0], Date = new DateOnly(2026, 4, 8),  Status = "AnnualLeave", Notes = "Pre-approved leave" },
            new() { EmployeeId = eId[0], Date = new DateOnly(2026, 4, 9),  Status = "Present",     Notes = null },
            new() { EmployeeId = eId[0], Date = new DateOnly(2026, 4, 10), Status = "Present",     Notes = null },

            // Sara Khan (1)
            new() { EmployeeId = eId[1], Date = new DateOnly(2026, 4, 1),  Status = "Present",  Notes = null },
            new() { EmployeeId = eId[1], Date = new DateOnly(2026, 4, 2),  Status = "Present",  Notes = null },
            new() { EmployeeId = eId[1], Date = new DateOnly(2026, 4, 3),  Status = "Absent",   Notes = "No show" },
            new() { EmployeeId = eId[1], Date = new DateOnly(2026, 4, 6),  Status = "Present",  Notes = null },
            new() { EmployeeId = eId[1], Date = new DateOnly(2026, 4, 7),  Status = "Present",  Notes = null },
            new() { EmployeeId = eId[1], Date = new DateOnly(2026, 4, 8),  Status = "Present",  Notes = null },
            new() { EmployeeId = eId[1], Date = new DateOnly(2026, 4, 9),  Status = "HalfDay",  Notes = "Left early" },
            new() { EmployeeId = eId[1], Date = new DateOnly(2026, 4, 10), Status = "Present",  Notes = null },

            // James Okafor (2)
            new() { EmployeeId = eId[2], Date = new DateOnly(2026, 4, 1),  Status = "Present",   Notes = null },
            new() { EmployeeId = eId[2], Date = new DateOnly(2026, 4, 2),  Status = "SickLeave", Notes = "Medical certificate submitted" },
            new() { EmployeeId = eId[2], Date = new DateOnly(2026, 4, 3),  Status = "SickLeave", Notes = "Medical certificate submitted" },
            new() { EmployeeId = eId[2], Date = new DateOnly(2026, 4, 6),  Status = "Present",   Notes = null },
            new() { EmployeeId = eId[2], Date = new DateOnly(2026, 4, 7),  Status = "Present",   Notes = null },
            new() { EmployeeId = eId[2], Date = new DateOnly(2026, 4, 8),  Status = "Present",   Notes = null },
            new() { EmployeeId = eId[2], Date = new DateOnly(2026, 4, 9),  Status = "Present",   Notes = null },
            new() { EmployeeId = eId[2], Date = new DateOnly(2026, 4, 10), Status = "Present",   Notes = null },

            // Mohammed Al Farsi (4)
            new() { EmployeeId = eId[4], Date = new DateOnly(2026, 4, 1),  Status = "Present", Notes = null },
            new() { EmployeeId = eId[4], Date = new DateOnly(2026, 4, 2),  Status = "Present", Notes = null },
            new() { EmployeeId = eId[4], Date = new DateOnly(2026, 4, 3),  Status = "Present", Notes = null },
            new() { EmployeeId = eId[4], Date = new DateOnly(2026, 4, 6),  Status = "Absent",  Notes = "Unexcused" },
            new() { EmployeeId = eId[4], Date = new DateOnly(2026, 4, 7),  Status = "Present", Notes = null },
            new() { EmployeeId = eId[4], Date = new DateOnly(2026, 4, 8),  Status = "Present", Notes = null },
            new() { EmployeeId = eId[4], Date = new DateOnly(2026, 4, 9),  Status = "Present", Notes = null },
            new() { EmployeeId = eId[4], Date = new DateOnly(2026, 4, 10), Status = "Present", Notes = null },
        };
        db.AttendanceRecords.AddRange(attendance);
        await db.SaveChangesAsync();

        // ── Payroll Run — March 2026 ─────────────────────────────────────────
        var payrollRun = new PayrollRun
        {
            Month       = 3,
            Year        = 2026,
            ProcessedAt = new DateTime(2026, 3, 31, 18, 0, 0, DateTimeKind.Utc),
            IsLocked    = true,
            TotalGross  = 168000.00m,
            TotalNet    = 165600.00m,
        };
        db.PayrollRuns.Add(payrollRun);
        await db.SaveChangesAsync();

        db.PayrollLineItems.AddRange(
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[0],  BasicSalary = 18000, HousingAllowance = 5000, TransportAllowance = 1500, GrossSalary = 24500.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 24500.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[1],  BasicSalary = 15000, HousingAllowance = 4500, TransportAllowance = 1200, GrossSalary = 20700.00m, AbsentDays = 1, AbsentDeduction =  500.00m, NetSalary = 20200.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[2],  BasicSalary = 12000, HousingAllowance = 3500, TransportAllowance = 1000, GrossSalary = 16500.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 16500.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[3],  BasicSalary = 10000, HousingAllowance = 3000, TransportAllowance =  800, GrossSalary = 13800.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 13800.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[4],  BasicSalary = 20000, HousingAllowance = 6000, TransportAllowance = 2000, GrossSalary = 28000.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 28000.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[5],  BasicSalary =  9000, HousingAllowance = 2500, TransportAllowance =  800, GrossSalary = 12300.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 12300.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[6],  BasicSalary = 11000, HousingAllowance = 3200, TransportAllowance =  900, GrossSalary = 15100.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 15100.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[7],  BasicSalary =  9500, HousingAllowance = 2800, TransportAllowance =  800, GrossSalary = 13100.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 13100.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[8],  BasicSalary = 16000, HousingAllowance = 4800, TransportAllowance = 1500, GrossSalary = 22300.00m, AbsentDays = 2, AbsentDeduction = 1066.67m, NetSalary = 21233.33m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[9],  BasicSalary = 17000, HousingAllowance = 5000, TransportAllowance = 1500, GrossSalary = 23500.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 23500.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[10], BasicSalary = 22000, HousingAllowance = 7000, TransportAllowance = 2000, GrossSalary = 31000.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 31000.00m },
            new PayrollLineItem { PayrollRunId = payrollRun.Id, EmployeeId = eId[11], BasicSalary =  8500, HousingAllowance = 2500, TransportAllowance =  700, GrossSalary = 11700.00m, AbsentDays = 0, AbsentDeduction =    0.00m, NetSalary = 11700.00m }
        );
        await db.SaveChangesAsync();
    }
}
