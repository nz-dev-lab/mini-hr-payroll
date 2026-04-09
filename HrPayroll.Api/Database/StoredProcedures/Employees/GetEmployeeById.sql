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
