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
