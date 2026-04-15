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
