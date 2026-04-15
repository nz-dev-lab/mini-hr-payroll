-- Goal 1 — Basic LEFT JOIN:

-- Show all departments and their employees. Departments with no employees should still appear with NULL for employee name.

-- Goal 2 — LEFT JOIN with ISNULL:

-- Same as Goal 1 but replace NULL employee names with 'No Employees'.

-- Goal 3 — LEFT JOIN filtered:

-- Show only departments that have no employees using LEFT JOIN.

-- Hint: filter where employee column IS NULL.

-- Goal 4 — RIGHT JOIN:

-- Show all employees and their departments. This time use RIGHT JOIN — switch the table order so employees are on the left and departments on the right.

-- Goal 5 — LEFT JOIN with COUNT:

-- Show all departments with their employee count. Departments with no employees should show 0 not NULL.

-- Hint: use COUNT(e.Id) not COUNT(*) — why? Try both and see the difference!

-- SELECT d.Name, e.FullName FROM Departments d LEFT JOIN Employees e ON e.DepartmentId = d.Id ORDER BY d.Name;
-- SELECT d.Name, ISNULL(e.FullName, 'No Employees') FROM Departments d LEFT JOIN Employees e ON e.DepartmentId = d.Id ORDER BY d.Name;
-- SELECT d.Name, ISNULL(e.FullName, 'No Employees') FROM Departments d LEFT JOIN Employees e ON e.DepartmentId = d.Id WHERE e.FullName IS NULL ORDER BY d.Name;
-- SELECT e.FullName, d.Name AS Departments FROM Employees e RIGHT JOIN Departments d ON d.Id = e.DepartmentId ORDER BY e.FullName;
-- SELECT d.Name, COUNT(*) FROM Departments d LEFT JOIN Employees e ON e.DepartmentId = d.Id GROUP BY d.Name ORDER BY d.Name;

-- Goal 1 — Basic View:
-- Create Practice_View_ActiveEmployees — shows all active employees with department name and gross salary.

-- Goal 2 — View with LEFT JOIN:
-- Create Practice_View_DepartmentEmployeeCount — shows all departments with their employee count. Empty departments should show 0.

-- Goal 3 — Filtered View:
-- Create Practice_View_HighEarners — shows employees whose gross salary is above 20000, with their department name.

-- Goal 4 — View with ISNULL:
-- Create Practice_View_EmployeeDetails — shows all employees with EmiratesId and BankAccount, replacing NULLs with 'Not Provided'.

-- Goal 5 — Querying a View like a table:
-- After creating Goal 1's view, write a query against it — filter only Engineering employees from the view without touching the base tables.

DROP VIEW IF EXISTS Practice_View_ActiveEmployees;
GO
CREATE VIEW Practice_View_ActiveEmployees
AS
SELECT e.FullName, d.Name AS Department, e.Status, (e.BasicSalary + e.HousingAllowance + e.TransportAllowance) AS GrossSalary FROM Employees e INNER JOIN Departments d ON e.DepartmentId = d.Id WHERE e.Status = 'Active';
GO

SELECT * FROM Practice_View_ActiveEmployees;

DROP VIEW IF EXISTS Practice_View_DepartmentEmployeeCount;
GO
CREATE VIEW Practice_View_DepartmentEmployeeCount
AS
SELECT d.Name AS Department, COUNT(e.Id) AS EmployeeCount FROM Departments d LEFT JOIN Employees e ON e.DepartmentId = d.Id GROUP BY d.Name;
GO

SELECT * FROM Practice_View_DepartmentEmployeeCount;

DROP VIEW IF EXISTS Practice_View_HighEarners;
GO
CREATE VIEW Practice_View_HighEarners
AS
SELECT e.FullName, d.Name AS Department, (e.BasicSalary + e.HousingAllowance + e.TransportAllowance) AS GrossSalary FROM Employees e INNER JOIN Departments d ON d.Id = e.DepartmentId WHERE (e.BasicSalary + e.HousingAllowance + e.TransportAllowance) > 20000;
GO
SELECT * FROM Practice_View_HighEarners;

DROP VIEW IF EXISTS Practice_View_EmployeeDetails;
GO
CREATE VIEW Practice_View_EmployeeDetails
AS
SELECT FullName, ISNULL(EmiratesId, 'Not Provided') AS EmiratesId, ISNULL(BankAccount, 'Not Provided') AS BankAccount FROM Employees;  
GO

SELECT * FROM Practice_View_EmployeeDetails;

SELECT * FROM Practice_View_ActiveEmployees WHERE Department = 'Finance';