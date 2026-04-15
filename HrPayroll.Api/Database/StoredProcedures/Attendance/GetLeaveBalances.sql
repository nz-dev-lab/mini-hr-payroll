-- TODO: WOR-123 — implement when building the Attendance module
-- Full SP definition is in WOR-123

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
    WHERE (@EmployeeId IS NULL OR lb.EmployeeId = @EmployeeId )AND (@Year IS NULL OR lb.Year = @Year);
END;
GO