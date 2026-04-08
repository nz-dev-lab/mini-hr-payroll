import { NavLink } from 'react-router-dom';
import { LayoutDashboard, Users, Building2, CalendarCheck, Banknote } from 'lucide-react';
import { cn } from '@/lib/utils';

const navItems = [
  { to: '/', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/employees', label: 'Employees', icon: Users },
  { to: '/departments', label: 'Departments', icon: Building2 },
  { to: '/attendance', label: 'Attendance', icon: CalendarCheck },
  { to: '/payroll', label: 'Payroll', icon: Banknote },
];

const APP_VERSION = import.meta.env.VITE_APP_VERSION ?? '0.1.0';

export function Sidebar() {
  return (
    <aside className="hidden md:flex w-56 flex-col border-r bg-sidebar min-h-screen">
      <div className="px-6 py-5 border-b border-sidebar-border">
        <span className="font-semibold text-lg tracking-tight text-sidebar-foreground">
          HR Payroll
        </span>
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
                  ? 'bg-sidebar-primary text-sidebar-primary-foreground'
                  : 'text-sidebar-foreground hover:bg-sidebar-accent hover:text-sidebar-accent-foreground'
              )
            }
          >
            <Icon className="h-4 w-4 shrink-0" />
            {label}
          </NavLink>
        ))}
      </nav>

      <div className="px-6 py-4 border-t border-sidebar-border">
        <p className="text-xs text-sidebar-foreground/50">v{APP_VERSION}</p>
      </div>
    </aside>
  );
}
