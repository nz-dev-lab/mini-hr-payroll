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
        e.VisaType,
        e.Status,
        (e.BasicSalary + e.HousingAllowance + e.TransportAllowance) AS GrossSalary
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
-- TODO: WOR-123 — paste MarkAttendance, BulkMarkPresent, GetMonthlyAttendance, GetLeaveBalances here

-- ===================== PAYROLL ===============================
-- TODO: WOR-125 — paste ProcessMonthlyPayroll, GetPayrollRuns, GetPayrollRunDetails, GetPayslip here
