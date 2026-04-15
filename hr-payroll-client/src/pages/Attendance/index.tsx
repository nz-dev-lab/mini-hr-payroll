import { useState, useMemo, useCallback } from 'react';
import { Plus, Trash2 } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { DataTable, PageHeader, ConfirmDialog, StatusBadge } from '@/components/shared';
import { useAttendance, useDeleteAttendance } from '@/hooks/useAttendance';
import { AttendanceFormSheet } from './AttendanceFormSheet';
import type { AttendanceDto } from '@/types';

const MONTH_NAMES = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

function getStatusVariant(status: string) {
  switch (status) {
    case 'Present':     return 'present' as const;
    case 'Absent':      return 'absent' as const;
    case 'AnnualLeave': return 'annual-leave' as const;
    case 'SickLeave':   return 'sick-leave' as const;
    default:            return 'present' as const;
  }
}

const columns = (
  onDelete: (record: AttendanceDto) => void,
): ColumnDef<AttendanceDto>[] => [
  {
    accessorKey: 'date',
    header: 'Date',
    cell: ({ row }) => new Date(row.original.date).toLocaleDateString(),
  },
  {
    accessorKey: 'employeeName',
    header: 'Employee',
    cell: ({ row }) => <span className="font-medium">{row.original.employeeName}</span>,
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => (
      <StatusBadge variant={getStatusVariant(row.original.status)} />
    ),
  },
  {
    accessorKey: 'notes',
    header: 'Notes',
    enableSorting: false,
    cell: ({ row }) => (
      <span className="text-muted-foreground text-sm">{row.original.notes ?? '—'}</span>
    ),
  },
  {
    id: 'actions',
    enableSorting: false,
    header: () => <span className="sr-only">Actions</span>,
    cell: ({ row }) => (
      <div className="flex items-center justify-end">
        <Button
          variant="ghost"
          size="icon"
          className="text-destructive hover:text-destructive"
          onClick={() => onDelete(row.original)}
          aria-label="Delete record"
        >
          <Trash2 className="h-4 w-4" />
        </Button>
      </div>
    ),
  },
];

export default function AttendancePage() {
  const now = new Date();
  const [month, setMonth] = useState(now.getMonth() + 1);
  const [year, setYear]   = useState(now.getFullYear());

  const { data: records = [], isLoading } = useAttendance(month, year);
  const deleteMutation = useDeleteAttendance();

  const [sheetOpen, setSheetOpen] = useState(false);
  const [deleting, setDeleting]   = useState<AttendanceDto | undefined>();

  const handleConfirmDelete = useCallback(async () => {
    if (!deleting) return;
    await deleteMutation.mutateAsync(deleting.id);
    setDeleting(undefined);
  }, [deleting, deleteMutation]);

  const years = Array.from({ length: 5 }, (_, i) => now.getFullYear() - 2 + i);
  const cols = useMemo(() => columns(setDeleting), []);

  return (
    <div>
      <PageHeader
        title="Attendance"
        subtitle="Track employee attendance records"
        action={{ label: 'Mark Attendance', onClick: () => setSheetOpen(true), icon: <Plus className="h-4 w-4" /> }}
      />

      <div className="flex gap-3 mb-4">
        <Select value={String(month)} onValueChange={(v) => setMonth(Number(v))}>
          <SelectTrigger className="w-40">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {MONTH_NAMES.map((name, i) => (
              <SelectItem key={i + 1} value={String(i + 1)}>{name}</SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select value={String(year)} onValueChange={(v) => setYear(Number(v))}>
          <SelectTrigger className="w-28">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {years.map((y) => (
              <SelectItem key={y} value={String(y)}>{y}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <DataTable
        columns={cols}
        data={records}
        isLoading={isLoading}
        searchPlaceholder="Search by employee..."
        searchColumn="employeeName"
      />

      <AttendanceFormSheet open={sheetOpen} onOpenChange={setSheetOpen} />

      <ConfirmDialog
        open={!!deleting}
        onOpenChange={(open) => !open && setDeleting(undefined)}
        title="Delete Attendance Record"
        description="Are you sure you want to delete this attendance record? This cannot be undone."
        confirmLabel="Delete"
        variant="destructive"
        onConfirm={handleConfirmDelete}
        isLoading={deleteMutation.isPending}
      />
    </div>
  );
}
