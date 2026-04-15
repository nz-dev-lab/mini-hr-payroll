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

        -- Validate month and year
        IF @Month < 1 OR @Month > 12 OR @Year < 1900 OR @Year > 9999
            THROW 50051, 'Invalid month or year.', 1;

        -- Check if payroll has already been processed for this month and year
        IF EXISTS (SELECT 1 FROM PayrollRuns WHERE Month = @Month AND Year = @Year)
            THROW 50052, 'Payroll for this month and year has already been processed.', 1;

        -- Insert new payroll run (totals will be updated below)
        INSERT INTO PayrollRuns (Month, Year, ProcessedAt, IsLocked, TotalGross, TotalNet)
        VALUES (@Month, @Year, GETDATE(), 0, 0, 0);

        SET @NewPayrollRunId = SCOPE_IDENTITY();

        -- Calculate payroll for each active employee
        -- AbsentDays = number of Absent records that month
        -- AbsentDeduction = (BasicSalary / 30) * AbsentDays
        -- GrossSalary = BasicSalary + HousingAllowance + TransportAllowance
        -- NetSalary = GrossSalary - AbsentDeduction
        INSERT INTO PayrollLineItems
            (PayrollRunId, EmployeeId, BasicSalary, HousingAllowance, TransportAllowance,
             GrossSalary, AbsentDays, AbsentDeduction, NetSalary)
        SELECT
            @NewPayrollRunId,
            e.Id,
            e.BasicSalary,
            e.HousingAllowance,
            e.TransportAllowance,
            (e.BasicSalary + e.HousingAllowance + e.TransportAllowance)           AS GrossSalary,
            ISNULL(a.AbsentDays, 0)                                                AS AbsentDays,
            CAST(e.BasicSalary / 30.0 * ISNULL(a.AbsentDays, 0) AS DECIMAL(10,2)) AS AbsentDeduction,
            (e.BasicSalary + e.HousingAllowance + e.TransportAllowance)
                - CAST(e.BasicSalary / 30.0 * ISNULL(a.AbsentDays, 0) AS DECIMAL(10,2)) AS NetSalary
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

        -- Update the run totals
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
