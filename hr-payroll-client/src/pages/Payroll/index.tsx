import { useState, useMemo, useCallback } from 'react';
import { Plus, Trash2, Eye } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import { Button } from '@/components/ui/button';
import { DataTable, PageHeader, ConfirmDialog } from '@/components/shared';
import { usePayrollRuns, useDeletePayrollRun } from '@/hooks/usePayroll';
import { ProcessPayrollDialog } from './ProcessPayrollDialog';
import { RunDetailsDialog } from './RunDetailsDialog';
import type { PayrollRunDto } from '@/types';

const MONTH_NAMES = [
  '', 'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

const columns = (
  onViewDetails: (run: PayrollRunDto) => void,
  onDelete: (run: PayrollRunDto) => void,
): ColumnDef<PayrollRunDto>[] => [
  {
    accessorKey: 'month',
    header: 'Period',
    cell: ({ row }) => (
      <span className="font-medium">
        {MONTH_NAMES[row.original.month]} {row.original.year}
      </span>
    ),
  },
  {
    accessorKey: 'processedAt',
    header: 'Processed On',
    cell: ({ row }) => new Date(row.original.processedAt).toLocaleDateString(),
  },
  {
    accessorKey: 'employeeCount',
    header: 'Employees',
    cell: ({ row }) => <span className="tabular-nums">{row.original.employeeCount}</span>,
  },
  {
    accessorKey: 'totalGross',
    header: 'Total Gross',
    cell: ({ row }) => (
      <span className="tabular-nums">{row.original.totalGross.toLocaleString()}</span>
    ),
  },
  {
    accessorKey: 'totalNet',
    header: 'Total Net',
    cell: ({ row }) => (
      <span className="tabular-nums font-medium">{row.original.totalNet.toLocaleString()}</span>
    ),
  },
  {
    accessorKey: 'isLocked',
    header: 'Status',
    cell: ({ row }) => (
      <span className={row.original.isLocked ? 'text-muted-foreground text-sm' : 'text-green-600 text-sm font-medium'}>
        {row.original.isLocked ? 'Locked' : 'Open'}
      </span>
    ),
  },
  {
    id: 'actions',
    enableSorting: false,
    header: () => <span className="sr-only">Actions</span>,
    cell: ({ row }) => (
      <div className="flex items-center justify-end gap-2">
        <Button
          variant="ghost"
          size="icon"
          onClick={() => onViewDetails(row.original)}
          aria-label="View details"
        >
          <Eye className="h-4 w-4" />
        </Button>
        <Button
          variant="ghost"
          size="icon"
          className="text-destructive hover:text-destructive"
          onClick={() => onDelete(row.original)}
          aria-label="Delete run"
        >
          <Trash2 className="h-4 w-4" />
        </Button>
      </div>
    ),
  },
];

export default function PayrollPage() {
  const { data: runs = [], isLoading } = usePayrollRuns();
  const deleteMutation = useDeletePayrollRun();

  const [processOpen, setProcessOpen]       = useState(false);
  const [detailsRunId, setDetailsRunId]     = useState<number | undefined>();
  const [deleting, setDeleting]             = useState<PayrollRunDto | undefined>();

  const handleConfirmDelete = useCallback(async () => {
    if (!deleting) return;
    await deleteMutation.mutateAsync(deleting.id);
    setDeleting(undefined);
  }, [deleting, deleteMutation]);

  const handleViewDetails = useCallback((run: PayrollRunDto) => setDetailsRunId(run.id), []);

  const cols = useMemo(() => columns(handleViewDetails, setDeleting), [handleViewDetails]);

  return (
    <div>
      <PageHeader
        title="Payroll"
        subtitle="Process and review monthly payroll runs"
        action={{ label: 'Process Payroll', onClick: () => setProcessOpen(true), icon: <Plus className="h-4 w-4" /> }}
      />

      <DataTable
        columns={cols}
        data={runs}
        isLoading={isLoading}
        searchPlaceholder="Search by period..."
        searchColumn="month"
      />

      <ProcessPayrollDialog open={processOpen} onOpenChange={setProcessOpen} />

      <RunDetailsDialog
        payrollRunId={detailsRunId}
        onOpenChange={(open) => !open && setDetailsRunId(undefined)}
      />

      <ConfirmDialog
        open={!!deleting}
        onOpenChange={(open) => !open && setDeleting(undefined)}
        title="Delete Payroll Run"
        description={`Are you sure you want to delete the payroll run for ${deleting ? `${MONTH_NAMES[deleting.month]} ${deleting.year}` : ''}? This cannot be undone.`}
        confirmLabel="Delete"
        variant="destructive"
        onConfirm={handleConfirmDelete}
        isLoading={deleteMutation.isPending}
      />
    </div>
  );
}
