-- =============================================================
-- SeedData.sql — Sample data for HrPayrollDb
-- Run against: HrPayrollDb
-- Safe to re-run: clears existing data first
-- =============================================================

-- Clear in reverse dependency order
DELETE FROM PayrollLineItems;
DELETE FROM PayrollRuns;
DELETE FROM AttendanceRecords;
DELETE FROM LeaveBalances;
DELETE FROM Employees;
DELETE FROM Departments;

-- Reset identity counters
DBCC CHECKIDENT ('Departments', RESEED, 0);
DBCC CHECKIDENT ('Employees', RESEED, 0);
DBCC CHECKIDENT ('AttendanceRecords', RESEED, 0);
DBCC CHECKIDENT ('LeaveBalances', RESEED, 0);
DBCC CHECKIDENT ('PayrollRuns', RESEED, 0);
DBCC CHECKIDENT ('PayrollLineItems', RESEED, 0);

-- ===================== DEPARTMENTS ===========================

INSERT INTO Departments (Name, Description, CreatedAt) VALUES
('Engineering',     'Software development and infrastructure',  GETDATE()),
('Human Resources', 'People operations and recruitment',        GETDATE()),
('Finance',         'Accounting, payroll and budgeting',        GETDATE()),
('Sales',           'Business development and client accounts', GETDATE()),
('Operations',      'Logistics and facilities management',      GETDATE());

-- ===================== EMPLOYEES =============================

INSERT INTO Employees (EmployeeCode, FullName, Designation, DepartmentId, JoinDate, Nationality, VisaType, EmiratesId, BankAccount, BasicSalary, HousingAllowance, TransportAllowance, Status) VALUES
('EMP-001', 'Ahmed Al Mansouri',  'Senior Software Engineer', 1, '2021-03-15', 'Emirati',     'Employment', '784-1990-1234567-1', 'AE070331234567890123456', 18000.00, 5000.00, 1500.00, 'Active'),
('EMP-002', 'Sara Khan',          'HR Manager',               2, '2020-06-01', 'Pakistani',   'Employment', '784-1985-2345678-2', 'AE070332345678901234567', 15000.00, 4500.00, 1200.00, 'Active'),
('EMP-003', 'James Okafor',       'Finance Analyst',          3, '2022-01-10', 'Nigerian',    'Employment', '784-1992-3456789-3', 'AE070333456789012345678', 12000.00, 3500.00, 1000.00, 'Active'),
('EMP-004', 'Priya Nair',         'Sales Executive',          4, '2021-09-20', 'Indian',      'Employment', '784-1993-4567890-4', 'AE070334567890123456789', 10000.00, 3000.00,  800.00, 'Active'),
('EMP-005', 'Mohammed Al Farsi',  'Operations Manager',       5, '2019-11-05', 'Emirati',     'Employment', '784-1988-5678901-5', 'AE070335678901234567890', 20000.00, 6000.00, 2000.00, 'Active'),
('EMP-006', 'Fatima Al Zaabi',    'Junior Developer',         1, '2023-02-14', 'Emirati',     'Employment', '784-1998-6789012-6', 'AE070336789012345678901',  9000.00, 2500.00,  800.00, 'Active'),
('EMP-007', 'David Mensah',       'Accountant',               3, '2020-08-22', 'Ghanaian',    'Employment', '784-1987-7890123-7', 'AE070337890123456789012', 11000.00, 3200.00,  900.00, 'Active'),
('EMP-008', 'Layla Hassan',       'HR Officer',               2, '2022-05-30', 'Egyptian',    'Employment', '784-1994-8901234-8', 'AE070338901234567890123',  9500.00, 2800.00,  800.00, 'Active'),
('EMP-009', 'Ravi Sharma',        'Sales Manager',            4, '2018-04-12', 'Indian',      'Employment', '784-1982-9012345-9', 'AE070339012345678901234', 16000.00, 4800.00, 1500.00, 'Active'),
('EMP-010', 'Nora Johansson',     'DevOps Engineer',          1, '2022-11-01', 'Swedish',     'Employment', '784-1991-0123456-0', 'AE070330123456789012345', 17000.00, 5000.00, 1500.00, 'Active'),
('EMP-011', 'Khalid Al Rashidi',  'Finance Manager',          3, '2017-07-18', 'Emirati',     'Employment', '784-1980-1234568-1', 'AE070331234568901234567', 22000.00, 7000.00, 2000.00, 'Active'),
('EMP-012', 'Maria Santos',       'Operations Coordinator',   5, '2023-01-09', 'Filipino',    'Employment', '784-1995-2345679-2', 'AE070332345679012345678',  8500.00, 2500.00,  700.00, 'Terminated');

-- ===================== LEAVE BALANCES ========================

INSERT INTO LeaveBalances (EmployeeId, Year, AnnualLeaveEntitlement, AnnualLeaveUsed, SickLeaveUsed) VALUES
(1,  2026, 30, 5,  2),
(2,  2026, 30, 8,  0),
(3,  2026, 30, 2,  1),
(4,  2026, 30, 0,  0),
(5,  2026, 30, 12, 3),
(6,  2026, 30, 0,  0),
(7,  2026, 30, 6,  2),
(8,  2026, 30, 3,  1),
(9,  2026, 30, 10, 0),
(10, 2026, 30, 1,  0),
(11, 2026, 30, 15, 5),
(12, 2026, 30, 4,  1);

-- ===================== ATTENDANCE RECORDS ====================
-- Sample attendance for April 2026 (first 10 days, active employees only)

INSERT INTO AttendanceRecords (EmployeeId, Date, Status, Notes) VALUES
-- Ahmed Al Mansouri
(1, '2026-04-01', 'Present',     NULL),
(1, '2026-04-02', 'Present',     NULL),
(1, '2026-04-03', 'Present',     NULL),
(1, '2026-04-06', 'Present',     NULL),
(1, '2026-04-07', 'AnnualLeave', 'Pre-approved leave'),
(1, '2026-04-08', 'AnnualLeave', 'Pre-approved leave'),
(1, '2026-04-09', 'Present',     NULL),
(1, '2026-04-10', 'Present',     NULL),

-- Sara Khan
(2, '2026-04-01', 'Present',  NULL),
(2, '2026-04-02', 'Present',  NULL),
(2, '2026-04-03', 'Absent',   'No show'),
(2, '2026-04-06', 'Present',  NULL),
(2, '2026-04-07', 'Present',  NULL),
(2, '2026-04-08', 'Present',  NULL),
(2, '2026-04-09', 'HalfDay',  'Left early'),
(2, '2026-04-10', 'Present',  NULL),

-- James Okafor
(3, '2026-04-01', 'Present',   NULL),
(3, '2026-04-02', 'SickLeave', 'Medical certificate submitted'),
(3, '2026-04-03', 'SickLeave', 'Medical certificate submitted'),
(3, '2026-04-06', 'Present',   NULL),
(3, '2026-04-07', 'Present',   NULL),
(3, '2026-04-08', 'Present',   NULL),
(3, '2026-04-09', 'Present',   NULL),
(3, '2026-04-10', 'Present',   NULL),

-- Mohammed Al Farsi
(5, '2026-04-01', 'Present', NULL),
(5, '2026-04-02', 'Present', NULL),
(5, '2026-04-03', 'Present', NULL),
(5, '2026-04-06', 'Absent',  'Unexcused'),
(5, '2026-04-07', 'Present', NULL),
(5, '2026-04-08', 'Present', NULL),
(5, '2026-04-09', 'Present', NULL),
(5, '2026-04-10', 'Present', NULL);

-- ===================== PAYROLL RUN (March 2026) ==============

INSERT INTO PayrollRuns (Month, Year, ProcessedAt, IsLocked, TotalGross, TotalNet) VALUES
(3, 2026, '2026-03-31 18:00:00', 1, 168000.00, 165600.00);

-- Payroll line items for March (active employees at that time, EMP-012 was still active)
INSERT INTO PayrollLineItems (PayrollRunId, EmployeeId, BasicSalary, HousingAllowance, TransportAllowance, GrossSalary, AbsentDays, AbsentDeduction, NetSalary) VALUES
(1,  1,  18000.00, 5000.00, 1500.00, 24500.00, 0, 0.00,    24500.00),
(1,  2,  15000.00, 4500.00, 1200.00, 20700.00, 1, 500.00,  20200.00),
(1,  3,  12000.00, 3500.00, 1000.00, 16500.00, 0, 0.00,    16500.00),
(1,  4,  10000.00, 3000.00,  800.00, 13800.00, 0, 0.00,    13800.00),
(1,  5,  20000.00, 6000.00, 2000.00, 28000.00, 0, 0.00,    28000.00),
(1,  6,   9000.00, 2500.00,  800.00, 12300.00, 0, 0.00,    12300.00),
(1,  7,  11000.00, 3200.00,  900.00, 15100.00, 0, 0.00,    15100.00),
(1,  8,   9500.00, 2800.00,  800.00, 13100.00, 0, 0.00,    13100.00),
(1,  9,  16000.00, 4800.00, 1500.00, 22300.00, 2, 1066.67, 21233.33),
(1, 10,  17000.00, 5000.00, 1500.00, 23500.00, 0, 0.00,    23500.00),
(1, 11,  22000.00, 7000.00, 2000.00, 31000.00, 0, 0.00,    31000.00),
(1, 12,   8500.00, 2500.00,  700.00, 11700.00, 0, 0.00,    11700.00);

-- ===================== VERIFY ================================

SELECT 'Departments'     AS TableName, COUNT(*) AS Rows FROM Departments
UNION ALL
SELECT 'Employees',        COUNT(*) FROM Employees
UNION ALL
SELECT 'LeaveBalances',    COUNT(*) FROM LeaveBalances
UNION ALL
SELECT 'AttendanceRecords',COUNT(*) FROM AttendanceRecords
UNION ALL
SELECT 'PayrollRuns',      COUNT(*) FROM PayrollRuns
UNION ALL
SELECT 'PayrollLineItems', COUNT(*) FROM PayrollLineItems;
