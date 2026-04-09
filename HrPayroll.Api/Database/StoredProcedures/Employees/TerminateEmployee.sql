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
