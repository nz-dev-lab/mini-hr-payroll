import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { FormField } from '@/components/shared';
import { useProcessPayroll } from '@/hooks/usePayroll';

const schema = z.object({
  month: z.number().min(1).max(12),
  year: z.number().min(2000).max(2100),
});

type FormValues = z.infer<typeof schema>;

interface ProcessPayrollDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function ProcessPayrollDialog({ open, onOpenChange }: ProcessPayrollDialogProps) {
  const processMutation = useProcessPayroll();
  const now = new Date();

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { month: now.getMonth() + 1, year: now.getFullYear() },
  });

  async function onSubmit(values: FormValues) {
    await processMutation.mutateAsync(values);
    reset();
    onOpenChange(false);
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-sm">
        <DialogHeader>
          <DialogTitle>Process Payroll</DialogTitle>
          <DialogDescription>
            Calculate and lock payroll for all active employees for the selected month.
          </DialogDescription>
        </DialogHeader>

        <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-4 py-2">
          <FormField label="Month" error={errors.month?.message} required>
            <Input
              type="number"
              min={1}
              max={12}
              {...register('month', { valueAsNumber: true })}
              disabled={processMutation.isPending}
            />
          </FormField>

          <FormField label="Year" error={errors.year?.message} required>
            <Input
              type="number"
              min={2000}
              max={2100}
              {...register('year', { valueAsNumber: true })}
              disabled={processMutation.isPending}
            />
          </FormField>

          <DialogFooter className="gap-2">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)} disabled={processMutation.isPending}>
              Cancel
            </Button>
            <Button type="submit" disabled={processMutation.isPending}>
              {processMutation.isPending ? 'Processing...' : 'Process Payroll'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
