-- =============================================================
-- RunAll.sql — Install all stored procedures into HrPayrollDb
-- Safe to re-run: DROP IF EXISTS before each CREATE
-- Run against: HrPayrollDb
-- =============================================================

-- ===================== EMPLOYEES =============================

DROP PROCEDURE IF EXISTS GetAllEmployees;
GO

CREATE PROCEDURE GetAllEmployees
    @Status       NVARCHAR(20) = NULL,
    @DepartmentId INT          = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        e.Id,
        e.EmployeeCode,
        e.FullName,
        e.Designation,
        e.DepartmentId,
        d.Name AS DepartmentName,
        e.JoinDate,
        e.Nationality,
        e.EmiratesId,
        e.BankAccount,
        e.BasicSalary,
        e.HousingAllowance,
        e.TransportAllowance,
        e.VisaType,
        e.Status,
        (e.BasicSalary + e.HousingAllowance + e.TransportAllowance) AS GrossSalary,
        NULL AS AnnualLeaveEntitlement,
        NULL AS AnnualLeaveUsed,
        NULL AS AnnualLeaveRemaining,
        NULL AS SickLeaveUsed
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentId = d.Id
    WHERE (@Status IS NULL OR e.Status = @Status)
      AND (@DepartmentId IS NULL OR e.DepartmentId = @DepartmentId)
    ORDER BY e.FullName;
END;
GO

DROP PROCEDURE IF EXISTS GetEmployeeById;
GO

CREATE PROCEDURE GetEmployeeById
    @EmployeeId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        e.Id,
        e.EmployeeCode,
        e.FullName,
        e.Designation,
        e.DepartmentId,
        d.Name AS DepartmentName,
        e.JoinDate,
        e.Nationality,
        e.VisaType,
        e.EmiratesId,
        e.BankAccount,
        e.BasicSalary,
        e.HousingAllowance,
        e.TransportAllowance,
        (e.BasicSalary + e.HousingAllowance + e.TransportAllowance) AS GrossSalary,
        e.Status,
        lb.AnnualLeaveEntitlement,
        lb.AnnualLeaveUsed,
        (lb.AnnualLeaveEntitlement - lb.AnnualLeaveUsed) AS AnnualLeaveRemaining,
        lb.SickLeaveUsed
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentId = d.Id
    LEFT JOIN LeaveBalances lb
        ON lb.EmployeeId = e.Id
        AND lb.Year = YEAR(GETDATE())
    WHERE e.Id = @EmployeeId;
END;
GO

DROP PROCEDURE IF EXISTS CreateEmployee;
GO

CREATE PROCEDURE CreateEmployee
    @FullName           NVARCHAR(150),
    @Designation        NVARCHAR(100),
    @DepartmentId       INT,
    @JoinDate           DATE,
    @Nationality        NVARCHAR(50),
    @VisaType           NVARCHAR(30),
    @EmiratesId         NVARCHAR(20)   = NULL,
    @BankAccount        NVARCHAR(30)   = NULL,
    @BasicSalary        DECIMAL(10,2),
    @HousingAllowance   DECIMAL(10,2)  = 0,
    @TransportAllowance DECIMAL(10,2)  = 0,
    @NewEmployeeId      INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

            DECLARE @LastId INT = (SELECT ISNULL(MAX(Id), 0) FROM Employees);
            DECLARE @EmployeeCode NVARCHAR(10) = 'EMP-' + RIGHT('000' + CAST(@LastId + 1 AS NVARCHAR), 3);

            INSERT INTO Employees
                (EmployeeCode, FullName, Designation, DepartmentId, JoinDate,
                 Nationality, VisaType, EmiratesId, BankAccount,
                 BasicSalary, HousingAllowance, TransportAllowance, Status)
            VALUES
                (@EmployeeCode, @FullName, @Designation, @DepartmentId, @JoinDate,
                 @Nationality, @VisaType, @EmiratesId, @BankAccount,
                 @BasicSalary, @HousingAllowance, @TransportAllowance, 'Active');

            SET @NewEmployeeId = SCOPE_IDENTITY();

            INSERT INTO LeaveBalances (EmployeeId, Year, AnnualLeaveEntitlement, AnnualLeaveUsed, SickLeaveUsed)
            VALUES (@NewEmployeeId, YEAR(GETDATE()), 30, 0, 0);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS UpdateEmployee;
GO

CREATE PROCEDURE UpdateEmployee
    @EmployeeId         INT,
    @FullName           NVARCHAR(150),
    @Designation        NVARCHAR(100),
    @DepartmentId       INT,
    @JoinDate           DATE,
    @Nationality        NVARCHAR(50),
    @VisaType           NVARCHAR(30),
    @EmiratesId         NVARCHAR(20)   = NULL,
    @BankAccount        NVARCHAR(30)   = NULL,
    @BasicSalary        DECIMAL(10,2),
    @HousingAllowance   DECIMAL(10,2)  = 0,
    @TransportAllowance DECIMAL(10,2)  = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Employees WHERE Id = @EmployeeId)
        THROW 50001, 'Employee not found.', 1;

    UPDATE Employees SET
        FullName           = @FullName,
        Designation        = @Designation,
        DepartmentId       = @DepartmentId,
        JoinDate           = @JoinDate,
        Nationality        = @Nationality,
        VisaType           = @VisaType,
        EmiratesId         = @EmiratesId,
        BankAccount        = @BankAccount,
        BasicSalary        = @BasicSalary,
        HousingAllowance   = @HousingAllowance,
        TransportAllowance = @TransportAllowance
    WHERE Id = @EmployeeId;
END;
GO

DROP PROCEDURE IF EXISTS TerminateEmployee;
GO

CREATE PROCEDURE TerminateEmployee
    @EmployeeId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Employees
    SET Status = 'Terminated'
    WHERE Id = @EmployeeId AND Status = 'Active';

    IF @@ROWCOUNT = 0
        THROW 50002, 'Employee not found or already terminated.', 1;
END;
GO

-- ===================== ATTENDANCE ============================

DROP PROCEDURE IF EXISTS MarkAttendance;
GO
CREATE PROCEDURE MarkAttendance
    @EmployeeId  INT,
    @Date        DATE,
    @Status      NVARCHAR(20),
    @Notes       NVARCHAR(500) = NULL,
    @NewRecordId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Date > CAST(GETDATE() AS DATE)
            THROW 50002, 'Cannot mark attendance for a future date.', 1;

        IF NOT EXISTS (SELECT 1 FROM Employees WHERE Id = @EmployeeId AND Status = 'Active')
            THROW 50001, 'Employee not found or not active.', 1;

        IF EXISTS (SELECT 1 FROM AttendanceRecords WHERE EmployeeId = @EmployeeId AND Date = @Date)
            THROW 50003, 'Attendance for this date already exists.', 1;

        IF @Status NOT IN ('Present', 'Absent', 'AnnualLeave', 'SickLeave')
            THROW 50004, 'Invalid attendance status.', 1;

        INSERT INTO AttendanceRecords (EmployeeId, Date, Status, Notes)
        VALUES (@EmployeeId, @Date, @Status, @Notes);

        SET @NewRecordId = SCOPE_IDENTITY();

        IF @Status = 'AnnualLeave'
            UPDATE LeaveBalances
            SET AnnualLeaveUsed = AnnualLeaveUsed + 1
            WHERE EmployeeId = @EmployeeId AND Year = YEAR(@Date);

        IF @Status = 'SickLeave'
            UPDATE LeaveBalances
            SET SickLeaveUsed = SickLeaveUsed + 1
            WHERE EmployeeId = @EmployeeId AND Year = YEAR(@Date);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS BulkMarkPresent;
GO
CREATE PROCEDURE BulkMarkPresent
    @Date DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Date > CAST(GETDATE() AS DATE)
            THROW 50002, 'Cannot mark attendance for a future date.', 1;

        INSERT INTO AttendanceRecords (EmployeeId, Date, Status, Notes)
        SELECT e.Id, @Date, 'Present', 'Marked as present by bulk operation'
        FROM Employees e
        WHERE e.Status = 'Active'
        AND NOT EXISTS (
            SELECT 1 FROM AttendanceRecords a WHERE a.EmployeeId = e.Id AND a.Date = @Date
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS GetMonthlyAttendance;
GO
CREATE PROCEDURE GetMonthlyAttendance
    @EmployeeId INT = NULL,
    @Month      INT,
    @Year       INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        a.Id,
        a.EmployeeId,
        e.FullName AS EmployeeName,
        a.Date,
        a.Status,
        a.Notes
    FROM AttendanceRecords a
    INNER JOIN Employees e ON a.EmployeeId = e.Id
    WHERE (@EmployeeId IS NULL OR a.EmployeeId = @EmployeeId)
      AND MONTH(a.Date) = @Month
      AND YEAR(a.Date) = @Year
    ORDER BY a.Date;
END;
GO

DROP PROCEDURE IF EXISTS GetLeaveBalances;
GO
CREATE PROCEDURE GetLeaveBalances
    @EmployeeId INT = NULL,
    @Year       INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        e.FullName,
        d.Name AS Department,
        lb.Year,
        lb.AnnualLeaveEntitlement,
        lb.AnnualLeaveUsed,
        (lb.AnnualLeaveEntitlement - lb.AnnualLeaveUsed) AS AnnualLeaveRemaining,
        lb.SickLeaveUsed
    FROM LeaveBalances lb
    INNER JOIN Employees e ON lb.EmployeeId = e.Id
    INNER JOIN Departments d ON e.DepartmentId = d.Id
    WHERE (@EmployeeId IS NULL OR lb.EmployeeId = @EmployeeId)
      AND (@Year IS NULL OR lb.Year = @Year);
END;
GO

-- ===================== PAYROLL ===============================

DROP PROCEDURE IF EXISTS ProcessMonthlyPayroll;
GO
CREATE PROCEDURE ProcessMonthlyPayroll
    @Month INT,
    @Year  INT,
    @NewPayrollRunId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Month < 1 OR @Month > 12 OR @Year < 1900 OR @Year > 9999
            THROW 50051, 'Invalid month or year.', 1;

        IF EXISTS (SELECT 1 FROM PayrollRuns WHERE Month = @Month AND Year = @Year)
            THROW 50052, 'Payroll for this month and year has already been processed.', 1;

        INSERT INTO PayrollRuns (Month, Year, ProcessedAt, IsLocked, TotalGross, TotalNet)
        VALUES (@Month, @Year, GETDATE(), 0, 0, 0);

        SET @NewPayrollRunId = SCOPE_IDENTITY();

        INSERT INTO PayrollLineItems
            (PayrollRunId, EmployeeId, BasicSalary, HousingAllowance, TransportAllowance,
             GrossSalary, AbsentDays, AbsentDeduction, NetSalary)
        SELECT
            @NewPayrollRunId,
            e.Id,
            e.BasicSalary,
            e.HousingAllowance,
            e.TransportAllowance,
            (e.BasicSalary + e.HousingAllowance + e.TransportAllowance),
            ISNULL(a.AbsentDays, 0),
            CAST(e.BasicSalary / 30.0 * ISNULL(a.AbsentDays, 0) AS DECIMAL(10,2)),
            (e.BasicSalary + e.HousingAllowance + e.TransportAllowance)
                - CAST(e.BasicSalary / 30.0 * ISNULL(a.AbsentDays, 0) AS DECIMAL(10,2))
        FROM Employees e
        LEFT JOIN (
            SELECT EmployeeId, COUNT(*) AS AbsentDays
            FROM AttendanceRecords
            WHERE Status = 'Absent'
              AND MONTH(Date) = @Month
              AND YEAR(Date)  = @Year
            GROUP BY EmployeeId
        ) a ON a.EmployeeId = e.Id
        WHERE e.Status = 'Active';

        UPDATE PayrollRuns
        SET
            TotalGross = (SELECT ISNULL(SUM(GrossSalary), 0) FROM PayrollLineItems WHERE PayrollRunId = @NewPayrollRunId),
            TotalNet   = (SELECT ISNULL(SUM(NetSalary),   0) FROM PayrollLineItems WHERE PayrollRunId = @NewPayrollRunId)
        WHERE Id = @NewPayrollRunId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS GetPayrollRuns;
GO
CREATE PROCEDURE GetPayrollRuns
    @Month INT = NULL,
    @Year  INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        pr.Id,
        pr.Month,
        pr.Year,
        pr.ProcessedAt,
        pr.IsLocked,
        pr.TotalGross,
        pr.TotalNet,
        (SELECT COUNT(*) FROM PayrollLineItems WHERE PayrollRunId = pr.Id) AS EmployeeCount
    FROM PayrollRuns pr
    WHERE (@Month IS NULL OR pr.Month = @Month)
      AND (@Year  IS NULL OR pr.Year  = @Year)
    ORDER BY pr.Year DESC, pr.Month DESC;
END;
GO

DROP PROCEDURE IF EXISTS GetPayrollRunDetails;
GO
CREATE PROCEDURE GetPayrollRunDetails
    @PayrollRunId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM PayrollRuns WHERE Id = @PayrollRunId)
        THROW 50053, 'Payroll run not found.', 1;

    SELECT
        pli.Id,
        pli.PayrollRunId,
        pli.EmployeeId,
        e.FullName          AS EmployeeName,
        e.Designation,
        d.Name              AS Department,
        pli.BasicSalary,
        pli.HousingAllowance,
        pli.TransportAllowance,
        pli.GrossSalary,
        pli.AbsentDays,
        pli.AbsentDeduction,
        pli.NetSalary
    FROM PayrollLineItems pli
    INNER JOIN Employees   e ON pli.EmployeeId   = e.Id
    INNER JOIN Departments d ON e.DepartmentId   = d.Id
    WHERE pli.PayrollRunId = @PayrollRunId
    ORDER BY e.FullName;
END;
GO

DROP PROCEDURE IF EXISTS GetPayslip;
GO
CREATE PROCEDURE GetPayslip
    @PayrollRunId INT,
    @EmployeeId   INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM PayrollRuns WHERE Id = @PayrollRunId)
        THROW 50053, 'Payroll run not found.', 1;

    IF NOT EXISTS (SELECT 1 FROM Employees WHERE Id = @EmployeeId)
        THROW 50054, 'Employee not found.', 1;

    SELECT
        pli.Id,
        pli.PayrollRunId,
        pr.Month,
        pr.Year,
        pli.EmployeeId,
        e.EmployeeCode,
        e.FullName          AS EmployeeName,
        e.Designation,
        d.Name              AS Department,
        pli.BasicSalary,
        pli.HousingAllowance,
        pli.TransportAllowance,
        pli.GrossSalary,
        pli.AbsentDays,
        pli.AbsentDeduction,
        pli.NetSalary
    FROM PayrollLineItems pli
    INNER JOIN PayrollRuns  pr ON pli.PayrollRunId = pr.Id
    INNER JOIN Employees     e ON pli.EmployeeId   = e.Id
    INNER JOIN Departments   d ON e.DepartmentId   = d.Id
    WHERE pli.PayrollRunId = @PayrollRunId
      AND pli.EmployeeId   = @EmployeeId;
END;
GO
