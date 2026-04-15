import apiClient from './client';
import type { AttendanceDto } from '@/types';

export type CreateAttendancePayload = Pick<AttendanceDto, 'employeeId' | 'date' | 'status'> & {
  notes?: string;
};

export const attendanceApi = {
  getAll: (employeeId?: number, month?: number, year?: number) =>
    apiClient.get<AttendanceDto[]>('/attendance', { params: { employeeId, month, year } }).then((r) => r.data),

  getById: (id: number) =>
    apiClient.get<AttendanceDto>(`/attendance/${id}`).then((r) => r.data),

  create: (payload: CreateAttendancePayload) =>
    apiClient.post<AttendanceDto>('/attendance', payload).then((r) => r.data),

  delete: (id: number) =>
    apiClient.delete(`/attendance/${id}`),
};
