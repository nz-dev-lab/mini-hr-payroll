import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import toast from "react-hot-toast";
import { payrollApi, type ProcessPayrollPayload } from "@/api/payroll";

const QUERY_KEY = ['payroll'] as const;

export function usePayrollRuns(month?: number, year?: number) {
    return useQuery({
        queryKey: [...QUERY_KEY, month, year],
        queryFn: () => payrollApi.getAll(month, year),
    });
}

export function usePayrollRunDetails(id?: number) {
    return useQuery({
        queryKey: [...QUERY_KEY, id, 'details'],
        queryFn: () => payrollApi.getRunDetails(id!),
        enabled: !!id,
    });
}

export function useProcessPayroll() {
    const qc = useQueryClient();
    return useMutation({
        mutationFn: (payload: ProcessPayrollPayload) => payrollApi.process(payload),
        onSuccess: () => {
            qc.invalidateQueries({ queryKey: QUERY_KEY });
            toast.success('Payroll processed.');
        },
        onError: () => toast.error('Failed to process payroll.'),
    });
}

export function useDeletePayrollRun() {
    const qc = useQueryClient();
    return useMutation({
        mutationFn: (id: number) => payrollApi.delete(id),
        onSuccess: () => {
            qc.invalidateQueries({ queryKey: QUERY_KEY });
            toast.success('Payroll run deleted.');
        },
        onError: () => toast.error('Failed to delete payroll run.'),
    });
}
