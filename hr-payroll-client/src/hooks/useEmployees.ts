import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import { employeesApi, type CreateEmployeePayload, type UpdateEmployeePayload } from '@/api/employees';


const QUERY_KEY = ['employees'] as const;

export function useEmployees(status?: string, departmentId?: number, enabled = true){
    return useQuery({
        queryKey: [...QUERY_KEY, status, departmentId],
        queryFn: () => employeesApi.getAll(status, departmentId),
        enabled,
    });
}

export function useCreateEmployee() {
    const qc = useQueryClient();
    return useMutation({
      mutationFn: (payload: CreateEmployeePayload) => employeesApi.create(payload),
      onSuccess: () => {
        qc.invalidateQueries({ queryKey: QUERY_KEY });
        toast.success('Employee created.');
      },
      onError: () => toast.error('Failed to create employee.'),
    });
  
}

export function useUpdateEmployee() {
    const qc = useQueryClient();
    return useMutation({
      mutationFn: ({ id, payload }: { id: number; payload: UpdateEmployeePayload }) =>
        employeesApi.update(id, payload),
      onSuccess: () => {
        qc.invalidateQueries({ queryKey: QUERY_KEY });
        toast.success('Employee updated.');
      },
      onError: () => toast.error('Failed to update employee.'),
    });
}

export function useTerminateEmployee(){
    const qc = useQueryClient();
    return useMutation({
        mutationFn: ({id}: {id:number}) => employeesApi.terminate(id),
        onSuccess: () => {
            qc.invalidateQueries({ queryKey: QUERY_KEY });
            toast.success('Employee terminated.');
        },
        onError: () => toast.error('Failed to terminate employee.'),
    })
}
