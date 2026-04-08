export interface Employee {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  phone?: string;
  departmentId: number;
  departmentName?: string;
  jobTitle: string;
  hireDate: string;
  baseSalary: number;
  isActive: boolean;
}

export interface Department {
  id: number;
  name: string;
  description?: string;
  managerId?: number;
  managerName?: string;
  employeeCount?: number;
}

export interface AttendanceRecord {
  id: number;
  employeeId: number;
  employeeName?: string;
  date: string;
  checkIn?: string;
  checkOut?: string;
  status: 'present' | 'absent' | 'late' | 'half-day';
}

export interface PayrollRun {
  id: number;
  employeeId: number;
  employeeName?: string;
  periodStart: string;
  periodEnd: string;
  basicSalary: number;
  allowances: number;
  deductions: number;
  netSalary: number;
  status: 'draft' | 'approved' | 'paid';
}
