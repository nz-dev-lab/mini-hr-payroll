import apiClient from './client';
import type { PayrollRunDto, PayrollLineItemDto, PayslipDto } from '@/types';

export type ProcessPayrollPayload = {
  month: number;
  year: number;
};

export const payrollApi = {
  getAll: (month?: number, year?: number) =>
    apiClient.get<PayrollRunDto[]>('/payroll', { params: { month, year } }).then((r) => r.data),
  getById: (id: number) =>
    apiClient.get<PayrollRunDto>(`/payroll/${id}`).then((r) => r.data),
  getRunDetails: (id: number) =>
    apiClient.get<PayrollLineItemDto[]>(`/payroll/${id}/details`).then((r) => r.data),
  process: (payload: ProcessPayrollPayload) =>
    apiClient.post<PayrollRunDto>('/payroll/process', payload).then((r) => r.data),
  delete: (id: number) =>
    apiClient.delete(`/payroll/${id}`),
  getPaySlip: (payrollRunId: number, employeeId: number) =>
    apiClient.get<PayslipDto>(`/payroll/${payrollRunId}/payslip/${employeeId}`).then((r) => r.data),
};