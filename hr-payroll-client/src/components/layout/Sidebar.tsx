import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Users, Building2, Clock, DollarSign } from 'lucide-react';
import { cn } from '@/lib/utils';

const navItems = [
  { to: '/', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/employees', label: 'Employees', icon: Users },
  { to: '/departments', label: 'Departments', icon: Building2 },
  { to: '/attendance', label: 'Attendance', icon: Clock },
  { to: '/payroll', label: 'Payroll', icon: DollarSign },
];

export function Sidebar() {
  return (
    <aside className="hidden md:flex w-56 flex-col border-r bg-sidebar min-h-screen">
      <div className="px-6 py-5 border-b">
        <span className="font-semibold text-lg tracking-tight">HR Payroll</span>
      </div>
      <nav className="flex-1 px-3 py-4 space-y-1">
        {navItems.map(({ to, label, icon: Icon }) => (
          <NavLink
            key={to}
            to={to}
            end={to === '/'}
            className={({ isActive }) =>
              cn(
                'flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors',
                isActive
                  ? 'bg-sidebar-accent text-sidebar-accent-foreground'
                  : 'text-sidebar-foreground hover:bg-sidebar-accent/60'
              )
            }
          >
            <Icon className="h-4 w-4" />
            {label}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
}
