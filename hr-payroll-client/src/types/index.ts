export interface DepartmentDto {
  id: number;
  name: string;
  description?: string;
  employeeCount: number;
}

export interface EmployeeDto {
  id: number;
  employeeCode: string;
  fullName: string;
  designation: string;
  departmentId: number;
  departmentName: string;
  joinDate: string;
  nationality: string;
  visaType: string;
  emiratesId?: string;
  bankAccount?: string;
  basicSalary: number;
  housingAllowance: number;
  transportAllowance: number;
  grossSalary: number;
  status: string;
  annualLeaveEntitlement?: number;
  annualLeaveUsed?: number;
  annualLeaveRemaining?: number;
  sickLeaveUsed?: number;
}

export interface AttendanceDto {
  id: number;
  employeeId: number;
  employeeName: string;
  date: string;
  status: string;
  notes?: string;
}

export interface PayrollRunDto {
  id: number;
  month: number;
  year: number;
  processedAt: string;
  isLocked: boolean;
  totalGross: number;
  totalNet: number;
  employeeCount: number;
}

export interface PayrollLineItemDto {
  id: number;
  payrollRunId: number;
  employeeId: number;
  employeeName: string;
  designation: string;
  department: string;
  basicSalary: number;
  housingAllowance: number;
  transportAllowance: number;
  grossSalary: number;
  absentDays: number;
  absentDeduction: number;
  netSalary: number;
}

export interface PayslipDto {
  id: number;
  payrollRunId: number;
  month: number;
  year: number;
  employeeId: number;
  employeeCode: string;
  employeeName: string;
  designation: string;
  department: string;
  basicSalary: number;
  housingAllowance: number;
  transportAllowance: number;
  grossSalary: number;
  absentDays: number;
  absentDeduction: number;
  netSalary: number;
}
