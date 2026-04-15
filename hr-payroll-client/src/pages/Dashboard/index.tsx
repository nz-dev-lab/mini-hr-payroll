import { Users, Building2, CalendarCheck, Banknote } from 'lucide-react';
import { useEmployees } from '@/hooks/useEmployees';
import { useDepartments } from '@/hooks/useDepartments';
import { useAttendance } from '@/hooks/useAttendance';
import { usePayrollRuns } from '@/hooks/usePayroll';

function StatCard({
  label,
  value,
  icon: Icon,
  sub,
}: {
  label: string;
  value: string | number;
  icon: React.ElementType;
  sub?: string;
}) {
  return (
    <div className="rounded-xl border bg-card p-5 flex items-start gap-4 shadow-sm">
      <div className="rounded-lg bg-primary/10 p-2.5">
        <Icon className="h-5 w-5 text-primary" />
      </div>
      <div>
        <p className="text-sm text-muted-foreground">{label}</p>
        <p className="text-2xl font-semibold tabular-nums">{value}</p>
        {sub && <p className="text-xs text-muted-foreground mt-0.5">{sub}</p>}
      </div>
    </div>
  );
}

export default function DashboardPage() {
  const now = new Date();
  const { data: employees = [] } = useEmployees();
  const { data: departments = [] } = useDepartments();
  const { data: attendance = [] } = useAttendance(now.getMonth() + 1, now.getFullYear());
  const { data: payrollRuns = [] } = usePayrollRuns();

  const activeEmployees   = employees.filter((e) => e.status === 'Active').length;
  const presentToday      = attendance.filter((a) => a.status === 'Present').length;
  const absentToday       = attendance.filter((a) => a.status === 'Absent').length;
  const lastRun           = payrollRuns[0];

  const MONTH_NAMES = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">Dashboard</h1>
        <p className="text-sm text-muted-foreground">
          Welcome back — here's what's happening today.
        </p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          label="Active Employees"
          value={activeEmployees}
          icon={Users}
          sub={`${employees.length} total`}
        />
        <StatCard
          label="Departments"
          value={departments.length}
          icon={Building2}
        />
        <StatCard
          label="Present This Month"
          value={presentToday}
          icon={CalendarCheck}
          sub={absentToday > 0 ? `${absentToday} absent` : 'No absences'}
        />
        <StatCard
          label="Last Payroll Run"
          value={lastRun ? `${MONTH_NAMES[lastRun.month]} ${lastRun.year}` : '—'}
          icon={Banknote}
          sub={lastRun ? `Net: ${lastRun.totalNet.toLocaleString()} AED` : 'No runs yet'}
        />
      </div>

      {/* Recent Payroll Runs */}
      <div className="rounded-xl border bg-card shadow-sm">
        <div className="px-5 py-4 border-b">
          <h2 className="font-medium text-sm">Recent Payroll Runs</h2>
        </div>
        <div className="divide-y">
          {payrollRuns.length === 0 ? (
            <p className="px-5 py-6 text-sm text-muted-foreground">No payroll runs yet.</p>
          ) : (
            payrollRuns.slice(0, 5).map((run) => (
              <div key={run.id} className="px-5 py-3 flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium">{MONTH_NAMES[run.month]} {run.year}</p>
                  <p className="text-xs text-muted-foreground">{run.employeeCount} employees</p>
                </div>
                <div className="text-right">
                  <p className="text-sm font-semibold tabular-nums">{run.totalNet.toLocaleString()} AED</p>
                  <p className="text-xs text-muted-foreground">Gross: {run.totalGross.toLocaleString()}</p>
                </div>
              </div>
            ))
          )}
        </div>
      </div>

      {/* Recent Attendance */}
      <div className="rounded-xl border bg-card shadow-sm">
        <div className="px-5 py-4 border-b">
          <h2 className="font-medium text-sm">
            Attendance — {MONTH_NAMES[now.getMonth() + 1]} {now.getFullYear()}
          </h2>
        </div>
        <div className="divide-y">
          {attendance.length === 0 ? (
            <p className="px-5 py-6 text-sm text-muted-foreground">No attendance records this month.</p>
          ) : (
            attendance.slice(0, 5).map((record) => (
              <div key={record.id} className="px-5 py-3 flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium">{record.employeeName}</p>
                  <p className="text-xs text-muted-foreground">{new Date(record.date).toLocaleDateString()}</p>
                </div>
                <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${
                  record.status === 'Present'     ? 'bg-green-100 text-green-700' :
                  record.status === 'Absent'      ? 'bg-red-100 text-red-700' :
                  record.status === 'AnnualLeave' ? 'bg-blue-100 text-blue-700' :
                  'bg-orange-100 text-orange-700'
                }`}>
                  {record.status}
                </span>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
