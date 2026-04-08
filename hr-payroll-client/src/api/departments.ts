import apiClient from './client';
import type { DepartmentDto } from '@/types';

export type CreateDepartmentPayload = Pick<DepartmentDto, 'name' | 'description'>;
export type UpdateDepartmentPayload = Partial<CreateDepartmentPayload>;

export const departmentsApi = {
  getAll: () =>
    apiClient.get<DepartmentDto[]>('/departments').then((r) => r.data),

  getById: (id: number) =>
    apiClient.get<DepartmentDto>(`/departments/${id}`).then((r) => r.data),

  create: (payload: CreateDepartmentPayload) =>
    apiClient.post<DepartmentDto>('/departments', payload).then((r) => r.data),

  update: (id: number, payload: UpdateDepartmentPayload) =>
    apiClient.put<DepartmentDto>(`/departments/${id}`, payload).then((r) => r.data),

  delete: (id: number) =>
    apiClient.delete(`/departments/${id}`),
};
