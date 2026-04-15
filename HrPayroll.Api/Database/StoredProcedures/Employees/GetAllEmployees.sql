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
