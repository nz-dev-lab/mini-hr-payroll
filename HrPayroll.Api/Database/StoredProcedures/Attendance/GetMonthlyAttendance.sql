-- TODO: WOR-123 — implement when building the Attendance module
-- CREATE PROCEDURE GetMonthlyAttendance

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