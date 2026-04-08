import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import axios from 'axios';
import { departmentsApi, type CreateDepartmentPayload, type UpdateDepartmentPayload } from '@/api/departments';

const QUERY_KEY = ['departments'] as const;

export function useDepartments() {
  return useQuery({
    queryKey: QUERY_KEY,
    queryFn: departmentsApi.getAll,
  });
}

export function useCreateDepartment() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateDepartmentPayload) => departmentsApi.create(payload),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: QUERY_KEY });
      toast.success('Department created.');
    },
    onError: () => toast.error('Failed to create department.'),
  });
}

export function useUpdateDepartment() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, payload }: { id: number; payload: UpdateDepartmentPayload }) =>
      departmentsApi.update(id, payload),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: QUERY_KEY });
      toast.success('Department updated.');
    },
    onError: () => toast.error('Failed to update department.'),
  });
}

export function useDeleteDepartment() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (id: number) => departmentsApi.delete(id),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: QUERY_KEY });
      toast.success('Department deleted.');
    },
    onError: (error) => {
      if (axios.isAxiosError(error) && error.response?.status === 409) {
        toast.error(error.response.data?.message ?? 'Cannot delete — department has employees.');
      } else {
        toast.error('Failed to delete department.');
      }
    },
  });
}
