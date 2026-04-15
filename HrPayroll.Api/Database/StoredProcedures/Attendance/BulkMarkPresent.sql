-- TODO: WOR-123 — implement when building the Attendance module
-- Full SP definition is in WOR-123

DROP PROCEDURE IF EXISTS BulkMarkPresent;
GO
CREATE PROCEDURE BulkMarkPresent
    @Date        DATE
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