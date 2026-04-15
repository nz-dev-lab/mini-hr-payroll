import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import toast from "react-hot-toast";
import { attendanceApi, type CreateAttendancePayload } from "@/api/attendance";

export function useAttendance(month?: number, year?: number) {
    return useQuery({
        queryKey: ['attendance', month, year],
        queryFn: () => attendanceApi.getAll(undefined, month, year),
    });
}

export function useMarkAttendance(){
    const qc = useQueryClient();
    return useMutation({
        mutationFn: (payload: CreateAttendancePayload) => attendanceApi.create(payload),
        onSuccess: () => {
            qc.invalidateQueries({ queryKey: ['attendance'] });
            toast.success('Attendance Marked.');
        },
        onError: () => toast.error('Failed to create attendance record.'),
    })
}

export function useDeleteAttendance(){
    const qc = useQueryClient();
    return useMutation({
        mutationFn: (id: number) => attendanceApi.delete(id),
        onSuccess: () => {
            qc.invalidateQueries({ queryKey: ['attendance'] });
            toast.success('Attendance record deleted.');
        },
        onError: () => toast.error('Failed to delete attendance record.'),
    })
}

