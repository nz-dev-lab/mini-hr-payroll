import apiClient from './client';
import type { EmployeeDto } from '@/types';

export type CreateEmployeePayload = Pick<EmployeeDto,
  'fullName' | 'designation' | 'departmentId' | 'joinDate' |
  'nationality' | 'visaType' | 'basicSalary' | 'housingAllowance' | 'transportAllowance'
> & {
  emiratesId?: string;
  bankAccount?: string;
};

export type UpdateEmployeePayload = CreateEmployeePayload;

export const employeesApi = {
  getAll: (status?: string, departmentId?: number) =>
    apiClient.get<EmployeeDto[]>('/employees', { params: { status, departmentId } }).then((r) => r.data),

  getById: (id: number) =>
    apiClient.get<EmployeeDto>(`/employees/${id}`).then((r) => r.data),

  create: (payload: CreateEmployeePayload) =>
    apiClient.post<EmployeeDto>('/employees', payload).then((r) => r.data),

  update: (id: number, payload: UpdateEmployeePayload) =>
    apiClient.put<EmployeeDto>(`/employees/${id}`, payload).then((r) => r.data),

  terminate: (id: number) =>
    apiClient.patch(`/employees/${id}/terminate`),
};
