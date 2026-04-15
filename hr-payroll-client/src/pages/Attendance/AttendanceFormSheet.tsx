import { useEffect } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetDescription,
  SheetFooter,
} from '@/components/ui/sheet';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { FormField } from '@/components/shared';
import { useMarkAttendance } from '@/hooks/useAttendance';
import { useEmployees } from '@/hooks/useEmployees';

const schema = z.object({
  employeeId: z.number({ message: 'Employee is required' }).min(1, 'Employee is required'),
  date: z.string().min(1, 'Date is required'),
  status: z.enum(['Present', 'Absent', 'AnnualLeave', 'SickLeave']),
  notes: z.string().max(500).optional(),
});

type FormValues = z.infer<typeof schema>;

interface AttendanceFormSheetProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function AttendanceFormSheet({ open, onOpenChange }: AttendanceFormSheetProps) {
  const markMutation = useMarkAttendance();
  const { data: employees = [] } = useEmployees(undefined, undefined, open);

  const {
    register,
    handleSubmit,
    reset,
    control,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { date: new Date().toISOString().split('T')[0], notes: '' },
  });

  useEffect(() => {
    if (open) reset({ date: new Date().toISOString().split('T')[0], notes: '' });
  }, [open, reset]);

  async function onSubmit(values: FormValues) {
    await markMutation.mutateAsync(values);
    onOpenChange(false);
  }

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="w-full sm:max-w-md flex flex-col">
        <SheetHeader>
          <SheetTitle>Mark Attendance</SheetTitle>
          <SheetDescription>Record attendance for an employee.</SheetDescription>
        </SheetHeader>

        <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col flex-1 gap-5 py-4">
          <FormField label="Employee" error={errors.employeeId?.message} required>
            <Controller
              control={control}
              name="employeeId"
              render={({ field }) => (
                <Select
                  value={field.value ? String(field.value) : ''}
                  onValueChange={(v) => field.onChange(Number(v))}
                  disabled={markMutation.isPending}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select employee..." />
                  </SelectTrigger>
                  <SelectContent>
                    {employees.map((e) => (
                      <SelectItem key={e.id} value={String(e.id)}>
                        {e.fullName}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
          </FormField>

          <FormField label="Date" error={errors.date?.message} required>
            <Input type="date" {...register('date')} disabled={markMutation.isPending} />
          </FormField>

          <FormField label="Status" error={errors.status?.message} required>
            <Controller
              control={control}
              name="status"
              render={({ field }) => (
                <Select
                  value={field.value ?? ''}
                  onValueChange={field.onChange}
                  disabled={markMutation.isPending}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select status..." />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Present">Present</SelectItem>
                    <SelectItem value="Absent">Absent</SelectItem>
                    <SelectItem value="AnnualLeave">Annual Leave</SelectItem>
                    <SelectItem value="SickLeave">Sick Leave</SelectItem>
                  </SelectContent>
                </Select>
              )}
            />
          </FormField>

          <FormField label="Notes" error={errors.notes?.message}>
            <Textarea
              {...register('notes')}
              placeholder="Optional notes..."
              rows={3}
              disabled={markMutation.isPending}
            />
          </FormField>

          <SheetFooter className="mt-auto gap-2">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)} disabled={markMutation.isPending}>
              Cancel
            </Button>
            <Button type="submit" disabled={markMutation.isPending}>
              {markMutation.isPending ? 'Saving...' : 'Mark Attendance'}
            </Button>
          </SheetFooter>
        </form>
      </SheetContent>
    </Sheet>
  );
}
