-- INSERT INTO Departments (Name, Description, CreatedAt) VALUES ('Information Technology', 'IT Technicians and IT Maintenance', GETUTCDATE());

-- UPDATE --
-- UPDATE Departments SET Description = 'IT Technicians, IT Security' WHERE Name = 'Information Technology';
-- INSERT INTO Employees (EmployeeCode, FullName, Designation, JoinDate, Nationality, VisaType, EmiratesId, BankAccount, BasicSalary, Status, DepartmentId, HousingAllowance, TransportAllowance) VALUES ('EMP-013', 'John Doe', 'IT Technician', GETUTCDATE(), 'American', 'Employment', '784-1975-2345679-3', 'AE070332345679012345679', 7000, 'Active', 7, 2000, 100);
-- DELETE FROM Employees WHERE Id = 15;
-- SELECT d.Name AS Department, SUM(BasicSalary) AS TotalBasicSalary FROM Employees e INNER JOIN Departments d ON e.DepartmentId = d.Id WHERE d.Name = 'Finance' GROUP BY d.Name;
-- SELECT e.Nationality, AVG(e.BasicSalary) AS AverageBasicSalary FROM Employees e INNER JOIN Departments d ON e.DepartmentId = d.Id GROUP BY e.Nationality;
-- Goal: Get the average gross salary (BasicSalary + HousingAllowance + TransportAllowance) per department name, but only show departments where the average gross salary is above 15000. Order by average descending.

-- This one needs JOIN (for department name), GROUP BY, HAVING, and ORDER BY.

-- SELECT d.Name AS Department, AVG((e.BasicSalary + e.HousingAllowance + e.TransportAllowance)) AS AverageGrossSalary FROM Employees e INNER JOIN Departments d ON e.DepartmentId = d.Id GROUP BY d.Name HAVING AVG((e.BasicSalary + e.HousingAllowance + e.TransportAllowance)) > 20000 ORDER BY AverageGrossSalary ASC;

-- Goal: Show all employees with their full name, bank account, and Emirates ID. Replace any NULL values with 'Missing'. Only show employees where either BankAccount OR EmiratesId is NULL.

-- Hint: you'll need IS NULL, OR, and ISNULL().
-- INSERT INTO Employees (EmployeeCode, FullName, Designation, JoinDate, Nationality, VisaType, EmiratesId, BankAccount, BasicSalary, Status, DepartmentId, HousingAllowance, TransportAllowance)
-- VALUES ('EMP-014', 'Test Employee', 'Intern', GETUTCDATE(), 'British', 'Employment', NULL, NULL, 5000, 'Active', 1, 500, 100);
-- SELECT e.FullName, ISNULL(e.BankAccount, 'Missing') AS BankAccount, ISNULL(e.EmiratesId, 'Not Provided') as EID FROM Employees e WHERE e.BankAccount IS NULL OR e.EmiratesId IS NULL; 
-- ALTER TABLE Employees ADD ContactNumber NVARCHAR(20) NULL; 
-- EXEC sp_rename 'Employees.ContactNumber', 'Phone', 'COLUMN';
-- ALTER TABLE Employees ADD CONSTRAINT CHK_STATS CHECK(Status IN('Active', 'Inactive', 'Terminated', 'Suspended'));
-- This should FAIL
-- INSERT INTO Employees (EmployeeCode, FullName, Designation, JoinDate, Nationality, VisaType, BasicSalary, Status, DepartmentId, HousingAllowance, TransportAllowance)
-- VALUES ('EMP-099', 'Test Employee', 'Intern', GETUTCDATE(), 'British', 'Employment', 5000, 'InvalidStatus', 1, 500, 100);
-- -- This should PASS
-- INSERT INTO Employees (EmployeeCode, FullName, Designation, JoinDate, Nationality, VisaType, BasicSalary, Status, DepartmentId, HousingAllowance, TransportAllowance)
-- VALUES ('EMP-099', 'Test Employee', 'Intern', GETUTCDATE(), 'British', 'Employment', 5000, 'Suspended', 1, 500, 100);

-- STORED PROCEDURES
-- Goal 1: Create Practice_GetAllDepartments — returns all departments ordered by name.

-- Goal 2: Create Practice_GetAllActiveEmployees — returns all active employees with department name and gross salary, ordered by full name.

-- CREATE PROCEDURE Practice_GetAllDepartments
-- AS
-- BEGIN
-- SELECT * FROM Departments;
-- END

-- EXEC Practice_GetAllDepartments;

-- CREATE PROCEDURE Practice_GetAllActiveEmployees
-- AS
-- BEGIN
-- SELECT e.FullName, d.Name AS Department, (e.BasicSalary + e.HousingAllowance + e.TransportAllowance) AS GrossSalary FROM Employees e INNER JOIN Departments d ON e.DepartmentId = d.Id WHERE Status = 'Active' ORDER BY e.FullName;
-- END

-- EXEC Practice_GetAllActiveEmployees;

-- Goal 3: Create Practice_GetEmployeesByDepartment — accepts @DepartmentName and returns all employees in that department.

-- Goal 4: Create Practice_GetEmployeesByStatus — accepts @Status and returns matching employees with gross salary.

-- CREATE PROCEDURE Practice_GetEmployeesByDepartment
-- @DepartmentName NVARCHAR(100)
-- AS
-- BEGIN


-- SELECT e.FullName, d.Name AS Department, e.Status FROM Employees e INNER JOIN Departments d ON d.Id = e.DepartmentId WHERE d.Name = @DepartmentName;
-- END

-- EXEC Practice_GetEmployeesByDepartment @DepartmentName = 'Sales';

-- CREATE PROCEDURE Practice_GetEmployeesByStatus
-- @Status NVARCHAR(100)
-- AS
-- BEGIN
-- SELECT e.FullName, d.Name AS Department, (e.BasicSalary + e.HousingAllowance + e.TransportAllowance) AS GrossSalary, e.Status FROM Employees e INNER JOIN Departments d ON d.Id = e.DepartmentId WHERE e.Status = @Status;
-- END

-- EXEC Practice_GetEmployeesByStatus @Status = 'Active';

-- Level 3 — INSERT / UPDATE via SP
-- Goal 5: Create Practice_AddDepartment — accepts @Name and @Description, inserts a new department.

-- Goal 6: Create Practice_UpdateEmployeeSalary — accepts @EmployeeCode and @NewBasicSalary, updates the salary.

-- CREATE PROCEDURE Practice_AddDepartment
-- @Name NVARCHAR(100), @Description NVARCHAR(100)
-- AS
-- BEGIN
-- INSERT INTO Departments (Name, Description) VALUES (@Name, @Description);
-- END
-- EXEC Practice_AddDepartment @Name = 'Cleaning', @Description = 'Property cleaning staffs';
-- ERROR: Started executing query at Line 1
-- Msg 515, Level 16, State 2, Procedure Practice_AddDepartment, Line 85
-- Cannot insert the value NULL into column 'CreatedAt', table 'HrPayrollDb.dbo.Departments'; column does not allow nulls. INSERT fails.
-- The statement has been terminated.
-- Total execution time: 00:00:00.004

-- ALTER PROCEDURE Practice_AddDepartment
-- @Name NVARCHAR(100), @Description NVARCHAR(100), @Date DATETIME
-- AS
-- BEGIN
-- INSERT INTO Departments (Name, Description, CreatedAt) VALUES (@Name, @Description, @Date);
-- END
-- EXEC Practice_AddDepartment @Name = 'Cleaning', @Description = 'Property cleaning staffs', @Date = GETUTCDATE();

-- ALTER PROCEDURE Practice_AddDepartment
-- @Name NVARCHAR(100), @Description NVARCHAR(100)
-- AS
-- BEGIN
-- INSERT INTO Departments (Name, Description, CreatedAt) VALUES (@Name, @Description, GETUTCDATE());
-- END
-- EXEC Practice_AddDepartment @Name = 'Cleaning', @Description = 'Property cleaning staffs';

-- CREATE PROCEDURE Practice_UpdateEmployeeSalary
-- @EmpCode NVARCHAR(100), @NewBasicSalary DECIMAL
-- AS
-- BEGIN
-- UPDATE Employees SET BasicSalary = @NewBasicSalary WHERE EmployeeCode = @EmpCode;
-- END
-- EXEC Practice_UpdateEmployeeSalary @EmpCode = 'EMP-002', @NewBasicSalary = 20000;
-- Move on to Goal 7 — output parameters, new concept:

-- Practice_GetEmployeeCount — accepts @DepartmentName, returns the employee count for that department as an output parameter.

-- Hint — execution will look like this:


-- DECLARE @Count INT;
-- EXEC Practice_GetEmployeeCount @DepartmentName = 'Engineering', @EmployeeCount = @Count OUTPUT;
-- SELECT @Count AS EmployeeCount;

-- CREATE PROCEDURE Practice_GetEmployeeCount
-- @DepartmentName NVARCHAR(100), @EmpCount INT OUTPUT
-- AS
-- BEGIN
-- SELECT @EmpCount = COUNT(*) FROM Employees e INNER JOIN Departments d ON d.Id = e.DepartmentId WHERE d.Name = @DepartmentName;
-- END
-- DECLARE @Count INT;
-- EXEC Practice_GetEmployeeCount @DepartmentName = 'Sales', @EmpCount = @Count OUTPUT;
-- SELECT @Count AS EMPCOUNT; 

-- Practice_DeleteDepartment — accepts @DepartmentId, tries to delete the department, catches the foreign key error if employees exist and prints a friendly message.

-- CREATE PROCEDURE Practice_DeleteDepartment
-- @DepId INT
-- AS
-- BEGIN
-- BEGIN TRY
-- DELETE FROM Departments WHERE Id = @DepId;
-- END TRY
-- BEGIN CATCH
-- PRINT 'The Operation went wrong because: ' + ERROR_MESSAGE();
-- END CATCH
-- END

-- EXEC Practice_DeleteDepartment @DepId = 4;
-- EXEC Practice_DeleteDepartment @DepId = 1;

-- ALTER PROCEDURE Practice_InsertEmployee
-- @EmployeeCode NVARCHAR(20), @FullName NVARCHAR(100)
-- AS
-- BEGIN
-- BEGIN TRY
-- INSERT INTO Employees (EmployeeCode, FullName, Designation, JoinDate, Nationality, VisaType, BasicSalary, Status, DepartmentId, HousingAllowance, TransportAllowance)
-- VALUES (@EmployeeCode, @FullName, 'Default', GETUTCDATE(), 'Unknown', 'Employment', 0, 'Active', 2, 0, 0);

-- DROP PROCEDURE IF EXISTS Practice_GetEmployees_By_Status_Optional;
-- CREATE PROCEDURE Practice_GetEmployees_By_Status_Optionall
--     @Status NVARCHAR(100) = NULL
-- AS
-- BEGIN
--     SET NOCOUNT ON
--     SELECT * FROM Employees WHERE (@Status IS NULL OR Status = @Status);
-- END
-- EXEC Practice_GetEmployees_By_Status_Optionall;
-- CREATE PROCEDURE Practice_AddDepartmentReturnId
-- @Name NVARCHAR(100), @Description NVARCHAR(100), @NewId INT OUTPUT
-- AS
-- BEGIN
-- SET NOCOUNT ON
-- INSERT INTO Departments (Name, Description, CreatedAt) VALUES (@Name, @Description, GETUTCDATE());
-- SET @NewId = SCOPE_IDENTITY();
-- END
-- DECLARE @NewId INT;
-- EXEC Practice_AddDepartmentReturnId @Name = 'ReturnIDDepartmentTesting', @Description = 'This should return the ID of new Department', @NewId = @NewId OUTPUT;
-- SELECT @NewId AS NewDepartmentID;

-- CREATE PROCEDURE Practice_UpdateDepartmentName
-- @DepartmentId INT, @NewName NVARCHAR(100)
-- AS
-- BEGIN
-- UPDATE Departments SET Name = @NewName WHERE Id = @DepartmentId;
-- IF @@ROWCOUNT = 0
--     PRINT 'Department Not Found';
-- ELSE
--     PRINT 'Department Updated Succesfully';
-- END
-- EXEC Practice_UpdateDepartmentName @DepartmentId = 999, @NewName = 'HR: Human Resources';
-- ALTER PROCEDURE Practice_AddEmployee_WithValidation
-- @EmployeeCode NVARCHAR(20), @BasicSalary DECIMAL
-- AS
-- BEGIN
-- IF @BasicSalary <= 0
-- THROW 50001, 'Basic Salary Must Be Greater Than 0', 1;
-- INSERT INTO Employees (EmployeeCode, FullName, Designation, JoinDate, Nationality, VisaType, BasicSalary, Status, DepartmentId, HousingAllowance, TransportAllowance)
-- VALUES (@EmployeeCode, 'Default', 'Default', GETUTCDATE(), 'Unknown', 'Employment', @BasicSalary, 'Active', 1, 0, 0);
-- END
-- EXEC Practice_AddEmployee_WithValidation @EmployeeCode = 'EMP-TEST-01', @BasicSalary = 0;
-- Create Practice_TransferEmployee — accepts @EmployeeId and @NewDepartmentId. This should:

-- Check if @NewDepartmentId exists — if not, throw a custom error
-- Update the employee's DepartmentId
-- Log a message 'Transfer complete.'
-- Wrap the update inside a transaction — if anything goes wrong, ROLLBACK, otherwise COMMIT.

-- CREATE PROCEDURE Practice_TransferEmployee
-- @EmployeeId INT, @NewDepartmentId INT
-- AS
-- BEGIN
-- BEGIN TRANSACTION
-- SELECT * FROM Departments WHERE Id = @NewDepartmentId;
-- IF @@ROWCOUNT = 0
-- BEGIN
-- ROLLBACK;
-- PRINT 'Department Not Found';
-- RETURN;
-- END
-- BEGIN
-- UPDATE Employees SET DepartmentId = @NewDepartmentId WHERE Id = @EmployeeId;
-- END
-- COMMIT;
-- PRINT 'Transfer Complete';
-- END

-- EXEC Practice_TransferEmployee @EmployeeId = 5, @NewDepartmentId = 2;