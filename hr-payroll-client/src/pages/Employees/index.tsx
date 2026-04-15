import { useState, useMemo, useCallback } from 'react';
import { Plus, Pencil, UserX } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import { Button } from '@/components/ui/button';
import { DataTable, PageHeader, ConfirmDialog, StatusBadge } from '@/components/shared';
import { useEmployees, useTerminateEmployee } from '@/hooks/useEmployees';
import { EmployeeFormSheet } from './EmployeeFormSheet';
import type { EmployeeDto } from '@/types';

const columns = (
  onEdit: (employee: EmployeeDto) => void,
  onTerminate: (employee: EmployeeDto) => void,
): ColumnDef<EmployeeDto>[] => [
  {
    accessorKey: 'employeeCode',
    header: 'Code',
    cell: ({ row }) => (
      <span className="text-muted-foreground text-sm font-mono">{row.original.employeeCode}</span>
    ),
  },
  {
    accessorKey: 'fullName',
    header: 'Name',
    cell: ({ row }) => <span className="font-medium">{row.original.fullName}</span>,
  },
  {
    accessorKey: 'designation',
    header: 'Designation',
  },
  {
    accessorKey: 'departmentName',
    header: 'Department',
  },
  {
    accessorKey: 'grossSalary',
    header: 'Gross Salary',
    cell: ({ row }) => (
      <span className="tabular-nums">{row.original.grossSalary.toLocaleString()}</span>
    ),
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => (
      <StatusBadge variant={row.original.status === 'Active' ? 'active' : 'terminated'} />
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
          onClick={() => onEdit(row.original)}
          aria-label="Edit employee"
        >
          <Pencil className="h-4 w-4" />
        </Button>
        {row.original.status === 'Active' && (
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive hover:text-destructive"
            onClick={() => onTerminate(row.original)}
            aria-label="Terminate employee"
          >
            <UserX className="h-4 w-4" />
          </Button>
        )}
      </div>
    ),
  },
];

export default function EmployeesPage() {
  const { data: employees = [], isLoading } = useEmployees();
  const terminateMutation = useTerminateEmployee();

  const [sheetOpen, setSheetOpen]       = useState(false);
  const [editing, setEditing]           = useState<EmployeeDto | undefined>();
  const [terminating, setTerminating]   = useState<EmployeeDto | undefined>();

  const handleAdd = useCallback(() => {
    setEditing(undefined);
    setSheetOpen(true);
  }, []);

  const handleEdit = useCallback((employee: EmployeeDto) => {
    setEditing(employee);
    setSheetOpen(true);
  }, []);

  const handleConfirmTerminate = useCallback(async () => {
    if (!terminating) return;
    await terminateMutation.mutateAsync({ id: terminating.id });
    setTerminating(undefined);
  }, [terminating, terminateMutation]);

  const cols = useMemo(() => columns(handleEdit, setTerminating), [handleEdit]);

  return (
    <div>
      <PageHeader
        title="Employees"
        subtitle="Manage your company's employees"
        action={{ label: 'Add Employee', onClick: handleAdd, icon: <Plus className="h-4 w-4" /> }}
      />

      <DataTable
        columns={cols}
        data={employees}
        isLoading={isLoading}
        searchPlaceholder="Search by name..."
        searchColumn="fullName"
      />

      <EmployeeFormSheet
        open={sheetOpen}
        onOpenChange={setSheetOpen}
        employee={editing}
      />

      <ConfirmDialog
        open={!!terminating}
        onOpenChange={(open) => !open && setTerminating(undefined)}
        title="Terminate Employee"
        description={`Are you sure you want to terminate "${terminating?.fullName}"? This action cannot be undone.`}
        confirmLabel="Terminate"
        variant="destructive"
        onConfirm={handleConfirmTerminate}
        isLoading={terminateMutation.isPending}
      />
    </div>
  );
}
