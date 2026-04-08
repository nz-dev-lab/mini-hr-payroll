import { useState } from 'react';
import { NavLink } from 'react-router-dom';
import { Menu, LayoutDashboard, Users, Building2, Clock, DollarSign } from 'lucide-react';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';

const navItems = [
  { to: '/', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/employees', label: 'Employees', icon: Users },
  { to: '/departments', label: 'Departments', icon: Building2 },
  { to: '/attendance', label: 'Attendance', icon: Clock },
  { to: '/payroll', label: 'Payroll', icon: DollarSign },
];

export function Header() {
  const [open, setOpen] = useState(false);

  return (
    <header className="flex h-14 items-center border-b px-4 md:px-6">
      {/* Mobile nav */}
      <Sheet open={open} onOpenChange={setOpen}>
        <SheetTrigger
          render={<Button variant="ghost" size="icon" className="md:hidden mr-2" />}
        >
          <Menu className="h-5 w-5" />
        </SheetTrigger>
        <SheetContent side="left" className="w-56 p-0">
          <div className="px-6 py-5 border-b">
            <span className="font-semibold text-lg tracking-tight">HR Payroll</span>
          </div>
          <nav className="px-3 py-4 space-y-1">
            {navItems.map(({ to, label, icon: Icon }) => (
              <NavLink
                key={to}
                to={to}
                end={to === '/'}
                onClick={() => setOpen(false)}
                className={({ isActive }) =>
                  cn(
                    'flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors',
                    isActive
                      ? 'bg-accent text-accent-foreground'
                      : 'hover:bg-accent/60'
                  )
                }
              >
                <Icon className="h-4 w-4" />
                {label}
              </NavLink>
            ))}
          </nav>
        </SheetContent>
      </Sheet>

      <span className="font-semibold text-base md:hidden">HR Payroll</span>
    </header>
  );
}
