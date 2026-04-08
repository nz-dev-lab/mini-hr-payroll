import { Badge } from '@/components/ui/badge';
import { cn } from '@/lib/utils';

export type BadgeVariant =
  // Employee status
  | 'active' | 'terminated' | 'on-leave'
  // Attendance
  | 'present' | 'absent' | 'late' | 'half-day'
  // Leave types
  | 'annual-leave' | 'sick-leave'
  // Payroll
  | 'draft' | 'approved' | 'paid';

const config: Record<BadgeVariant, { label: string; className: string }> = {
  // Green
  active:       { label: 'Active',        className: 'bg-green-100 text-green-800 border-green-200' },
  present:      { label: 'Present',       className: 'bg-green-100 text-green-800 border-green-200' },
  paid:         { label: 'Paid',          className: 'bg-green-100 text-green-800 border-green-200' },
  // Red
  terminated:   { label: 'Terminated',   className: 'bg-red-100 text-red-800 border-red-200' },
  absent:       { label: 'Absent',        className: 'bg-red-100 text-red-800 border-red-200' },
  // Yellow / Amber
  'half-day':   { label: 'Half Day',     className: 'bg-yellow-100 text-yellow-800 border-yellow-200' },
  late:         { label: 'Late',          className: 'bg-yellow-100 text-yellow-800 border-yellow-200' },
  draft:        { label: 'Draft',         className: 'bg-yellow-100 text-yellow-800 border-yellow-200' },
  // Blue
  'on-leave':   { label: 'On Leave',     className: 'bg-blue-100 text-blue-800 border-blue-200' },
  'annual-leave':{ label: 'Annual Leave', className: 'bg-blue-100 text-blue-800 border-blue-200' },
  approved:     { label: 'Approved',      className: 'bg-blue-100 text-blue-800 border-blue-200' },
  // Orange
  'sick-leave': { label: 'Sick Leave',   className: 'bg-orange-100 text-orange-800 border-orange-200' },
};

interface StatusBadgeProps {
  variant: BadgeVariant;
  label?: string;
  className?: string;
}

export function StatusBadge({ variant, label, className }: StatusBadgeProps) {
  const { label: defaultLabel, className: variantClass } = config[variant];
  return (
    <Badge
      variant="outline"
      className={cn('font-medium', variantClass, className)}
    >
      {label ?? defaultLabel}
    </Badge>
  );
}
