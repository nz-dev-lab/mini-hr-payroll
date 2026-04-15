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
