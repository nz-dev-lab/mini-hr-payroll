import { useEffect } from 'react';
import { useForm } from 'react-hook-form';
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
import { FormField } from '@/components/shared';
import { useCreateDepartment, useUpdateDepartment } from '@/hooks/useDepartments';
import type { DepartmentDto } from '@/types';

const schema = z.object({
  name: z.string().min(1, 'Name is required').max(100, 'Max 100 characters'),
  description: z.string().max(500, 'Max 500 characters').optional(),
});

type FormValues = z.infer<typeof schema>;

interface DepartmentFormSheetProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  /** Pass a department to edit; omit for create mode */
  department?: DepartmentDto;
}

export function DepartmentFormSheet({ open, onOpenChange, department }: DepartmentFormSheetProps) {
  const isEditing = !!department;
  const createMutation = useCreateDepartment();
  const updateMutation = useUpdateDepartment();
  const isPending = createMutation.isPending || updateMutation.isPending;

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { name: '', description: '' },
  });

  // Populate form when editing
  useEffect(() => {
    if (open) {
      reset({
        name: department?.name ?? '',
        description: department?.description ?? '',
      });
    }
  }, [open, department, reset]);

  async function onSubmit(values: FormValues) {
    if (isEditing) {
      await updateMutation.mutateAsync({ id: department!.id, payload: values });
    } else {
      await createMutation.mutateAsync(values);
    }
    onOpenChange(false);
  }

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="w-full sm:max-w-md flex flex-col">
        <SheetHeader>
          <SheetTitle>{isEditing ? 'Edit Department' : 'Add Department'}</SheetTitle>
          <SheetDescription>
            {isEditing
              ? 'Update the department details below.'
              : 'Fill in the details to create a new department.'}
          </SheetDescription>
        </SheetHeader>

        <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col flex-1 gap-5 py-4">
          <FormField label="Name" error={errors.name?.message} required>
            <Input {...register('name')} placeholder="e.g. Engineering" disabled={isPending} />
          </FormField>

          <FormField
            label="Description"
            error={errors.description?.message}
            helperText="Optional — briefly describe this department's role."
          >
            <Textarea
              {...register('description')}
              placeholder="e.g. Responsible for product development..."
              rows={4}
              disabled={isPending}
            />
          </FormField>

          <SheetFooter className="mt-auto gap-2">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)} disabled={isPending}>
              Cancel
            </Button>
            <Button type="submit" disabled={isPending}>
              {isPending ? 'Saving...' : isEditing ? 'Save Changes' : 'Create Department'}
            </Button>
          </SheetFooter>
        </form>
      </SheetContent>
    </Sheet>
  );
}
