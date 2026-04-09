CREATE PROCEDURE UpdateEmployee
    @EmployeeId         INT,
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
    @TransportAllowance DECIMAL(10,2)  = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Employees WHERE Id = @EmployeeId)
        THROW 50001, 'Employee not found.', 1;

    UPDATE Employees SET
        FullName           = @FullName,
        Designation        = @Designation,
        DepartmentId       = @DepartmentId,
        JoinDate           = @JoinDate,
        Nationality        = @Nationality,
        VisaType           = @VisaType,
        EmiratesId         = @EmiratesId,
        BankAccount        = @BankAccount,
        BasicSalary        = @BasicSalary,
        HousingAllowance   = @HousingAllowance,
        TransportAllowance = @TransportAllowance
    WHERE Id = @EmployeeId;
END;
