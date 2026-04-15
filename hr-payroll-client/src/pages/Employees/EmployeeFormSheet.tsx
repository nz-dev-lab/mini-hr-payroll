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
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { FormField, SearchableSelect } from '@/components/shared';
import { useCreateEmployee, useUpdateEmployee } from '@/hooks/useEmployees';
import { useDepartments } from '@/hooks/useDepartments';
import type { EmployeeDto } from '@/types';

const schema = z.object({
  fullName:           z.string().min(1, 'Full name is required'),
  designation:        z.string().min(1, 'Designation is required'),
  departmentId:       z.number({ message: 'Department is required' }).min(1, 'Department is required'),
  joinDate:           z.string().min(1, 'Join date is required'),
  nationality:        z.string().min(1, 'Nationality is required'),
  visaType:           z.string().min(1, 'Visa type is required'),
  emiratesId:         z.string().optional(),
  bankAccount:        z.string().optional(),
  basicSalary:        z.number({ message: 'Basic salary is required' }).min(0),
  housingAllowance:   z.number().min(0),
  transportAllowance: z.number().min(0),
});

type FormValues = z.infer<typeof schema>;

interface EmployeeFormSheetProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  employee?: EmployeeDto;
}

export function EmployeeFormSheet({ open, onOpenChange, employee }: EmployeeFormSheetProps) {
  const isEditing = !!employee;
  const createMutation = useCreateEmployee();
  const updateMutation = useUpdateEmployee();
  const { data: departments = [] } = useDepartments();
  const isPending = createMutation.isPending || updateMutation.isPending;

  const deptOptions = departments.map((d) => ({ value: String(d.id), label: d.name }));

  const {
    register,
    handleSubmit,
    reset,
    control,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      fullName: '', designation: '', joinDate: '', nationality: '',
      visaType: '', emiratesId: '', bankAccount: '',
      basicSalary: 0, housingAllowance: 0, transportAllowance: 0,
    },
  });

  useEffect(() => {
    if (open) {
      reset({
        fullName:           employee?.fullName           ?? '',
        designation:        employee?.designation        ?? '',
        departmentId:       employee?.departmentId       ?? undefined,
        joinDate:           employee?.joinDate           ?? '',
        nationality:        employee?.nationality        ?? '',
        visaType:           employee?.visaType           ?? '',
        emiratesId:         employee?.emiratesId         ?? '',
        bankAccount:        employee?.bankAccount        ?? '',
        basicSalary:        employee?.basicSalary        ?? 0,
        housingAllowance:   employee?.housingAllowance   ?? 0,
        transportAllowance: employee?.transportAllowance ?? 0,
      });
    }
  }, [open, employee, reset]);

  async function onSubmit(values: FormValues) {
    if (isEditing) {
      await updateMutation.mutateAsync({ id: employee!.id, payload: values });
    } else {
      await createMutation.mutateAsync(values);
    }
    onOpenChange(false);
  }

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="w-full sm:max-w-lg flex flex-col overflow-y-auto px-6">
        <SheetHeader>
          <SheetTitle>{isEditing ? 'Edit Employee' : 'Add Employee'}</SheetTitle>
          <SheetDescription>
            {isEditing ? 'Update employee details below.' : 'Fill in the details to add a new employee.'}
          </SheetDescription>
        </SheetHeader>

        <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col flex-1 gap-5 py-4 px-1">
          <FormField label="Full Name" error={errors.fullName?.message} required>
            <Input {...register('fullName')} placeholder="e.g. John Smith" disabled={isPending} />
          </FormField>

          <FormField label="Designation" error={errors.designation?.message} required>
            <Input {...register('designation')} placeholder="e.g. Software Engineer" disabled={isPending} />
          </FormField>

          <FormField label="Department" error={errors.departmentId?.message} required>
            <Controller
              control={control}
              name="departmentId"
              render={({ field }) => (
                <SearchableSelect
                  options={deptOptions}
                  value={field.value ? String(field.value) : ''}
                  onChange={(v) => field.onChange(Number(v))}
                  placeholder="Select department..."
                  disabled={isPending}
                />
              )}
            />
          </FormField>

          <FormField label="Join Date" error={errors.joinDate?.message} required>
            <Input type="date" {...register('joinDate')} disabled={isPending} />
          </FormField>

          <FormField label="Nationality" error={errors.nationality?.message} required>
            <Input {...register('nationality')} placeholder="e.g. Indian" disabled={isPending} />
          </FormField>

          <FormField label="Visa Type" error={errors.visaType?.message} required>
            <Controller
              control={control}
              name="visaType"
              render={({ field }) => (
                <Select value={field.value ?? ''} onValueChange={field.onChange} disabled={isPending}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select visa type..." />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Employment">Employment</SelectItem>
                    <SelectItem value="Investor">Investor</SelectItem>
                    <SelectItem value="Dependent">Dependent</SelectItem>
                    <SelectItem value="Tourist">Tourist</SelectItem>
                  </SelectContent>
                </Select>
              )}
            />
          </FormField>

          <FormField label="Emirates ID" error={errors.emiratesId?.message}>
            <Input {...register('emiratesId')} placeholder="e.g. 784-1990-1234567-1" disabled={isPending} />
          </FormField>

          <FormField label="Bank Account" error={errors.bankAccount?.message}>
            <Input {...register('bankAccount')} placeholder="e.g. AE070331234567890123456" disabled={isPending} />
          </FormField>

          <FormField label="Basic Salary" error={errors.basicSalary?.message} required>
            <Input type="number" min={0} step="0.01" {...register('basicSalary', { valueAsNumber: true })} disabled={isPending} />
          </FormField>

          <FormField label="Housing Allowance" error={errors.housingAllowance?.message}>
            <Input type="number" min={0} step="0.01" {...register('housingAllowance', { valueAsNumber: true })} disabled={isPending} />
          </FormField>

          <FormField label="Transport Allowance" error={errors.transportAllowance?.message}>
            <Input type="number" min={0} step="0.01" {...register('transportAllowance', { valueAsNumber: true })} disabled={isPending} />
          </FormField>

          <SheetFooter className="mt-auto gap-2">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)} disabled={isPending}>
              Cancel
            </Button>
            <Button type="submit" disabled={isPending}>
              {isPending ? 'Saving...' : isEditing ? 'Save Changes' : 'Add Employee'}
            </Button>
          </SheetFooter>
        </form>
      </SheetContent>
    </Sheet>
  );
}
