import { useState } from 'react';
import { Plus, Pencil, Trash2 } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import { Button } from '@/components/ui/button';
import { DataTable, PageHeader, ConfirmDialog } from '@/components/shared';
import { useDepartments, useDeleteDepartment } from '@/hooks/useDepartments';
import { DepartmentFormSheet } from './DepartmentFormSheet';
import type { DepartmentDto } from '@/types';

const columns = (
  onEdit: (dept: DepartmentDto) => void,
  onDelete: (dept: DepartmentDto) => void,
): ColumnDef<DepartmentDto>[] => [
  {
    accessorKey: 'name',
    header: 'Name',
    cell: ({ row }) => <span className="font-medium">{row.original.name}</span>,
  },
  {
    accessorKey: 'description',
    header: 'Description',
    enableSorting: false,
    cell: ({ row }) => (
      <span className="text-muted-foreground text-sm line-clamp-1">
        {row.original.description ?? '—'}
      </span>
    ),
  },
  {
    accessorKey: 'employeeCount',
    header: 'Employees',
    cell: ({ row }) => (
      <span className="tabular-nums">{row.original.employeeCount}</span>
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
          aria-label="Edit department"
        >
          <Pencil className="h-4 w-4" />
        </Button>
        <Button
          variant="ghost"
          size="icon"
          className="text-destructive hover:text-destructive"
          onClick={() => onDelete(row.original)}
          aria-label="Delete department"
        >
          <Trash2 className="h-4 w-4" />
        </Button>
      </div>
    ),
  },
];

export default function DepartmentsPage() {
  const { data: departments = [], isLoading } = useDepartments();
  const deleteMutation = useDeleteDepartment();

  const [sheetOpen, setSheetOpen] = useState(false);
  const [editing, setEditing] = useState<DepartmentDto | undefined>();
  const [deleting, setDeleting] = useState<DepartmentDto | undefined>();

  function handleAdd() {
    setEditing(undefined);
    setSheetOpen(true);
  }

  function handleEdit(dept: DepartmentDto) {
    setEditing(dept);
    setSheetOpen(true);
  }

  function handleDeleteRequest(dept: DepartmentDto) {
    setDeleting(dept);
  }

  async function handleConfirmDelete() {
    if (!deleting) return;
    await deleteMutation.mutateAsync(deleting.id);
    setDeleting(undefined);
  }

  return (
    <div>
      <PageHeader
        title="Departments"
        subtitle="Manage your company's departments"
        action={{ label: 'Add Department', onClick: handleAdd, icon: <Plus className="h-4 w-4" /> }}
      />

      <DataTable
        columns={columns(handleEdit, handleDeleteRequest)}
        data={departments}
        isLoading={isLoading}
        searchPlaceholder="Search by name..."
        searchColumn="name"
      />

      <DepartmentFormSheet
        open={sheetOpen}
        onOpenChange={setSheetOpen}
        department={editing}
      />

      <ConfirmDialog
        open={!!deleting}
        onOpenChange={(open) => !open && setDeleting(undefined)}
        title="Delete Department"
        description={`Are you sure you want to delete "${deleting?.name}"? This cannot be undone.`}
        confirmLabel="Delete"
        variant="destructive"
        onConfirm={handleConfirmDelete}
        isLoading={deleteMutation.isPending}
      />
    </div>
  );
}
