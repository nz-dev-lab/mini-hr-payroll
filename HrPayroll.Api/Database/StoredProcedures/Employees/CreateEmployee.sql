CREATE PROCEDURE CreateEmployee
    @FullName           NVARCHAR(150),
    @Designation        NVARCHAR(100),
    @DepartmentId       INT,
    @JoinDate           DATE,
    @Nationality        NVARCHAR(50),
    @VisaType           NVARCHAR(30),
    @EmiratesId         NVARCHAR(20)   = NULL,
    @BankAccount        NVARCHAR(30)   = NULL,
    @BasicSalary        DECIMAL(10,2),
    @HousingAllowance   DECIMAL(10,2)  = 0,
    @TransportAllowance DECIMAL(10,2)  = 0,
    @NewEmployeeId      INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

            -- Auto-generate employee code
            DECLARE @LastId INT = (SELECT ISNULL(MAX(Id), 0) FROM Employees);
            DECLARE @EmployeeCode NVARCHAR(10) = 'EMP-' + RIGHT('000' + CAST(@LastId + 1 AS NVARCHAR), 3);

            INSERT INTO Employees
                (EmployeeCode, FullName, Designation, DepartmentId, JoinDate,
                 Nationality, VisaType, EmiratesId, BankAccount,
                 BasicSalary, HousingAllowance, TransportAllowance, Status)
            VALUES
                (@EmployeeCode, @FullName, @Designation, @DepartmentId, @JoinDate,
                 @Nationality, @VisaType, @EmiratesId, @BankAccount,
                 @BasicSalary, @HousingAllowance, @TransportAllowance, 'Active');

            SET @NewEmployeeId = SCOPE_IDENTITY();

            -- Create leave balance for current year in same transaction
            INSERT INTO LeaveBalances (EmployeeId, Year, AnnualLeaveEntitlement, AnnualLeaveUsed, SickLeaveUsed)
            VALUES (@NewEmployeeId, YEAR(GETDATE()), 30, 0, 0);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
