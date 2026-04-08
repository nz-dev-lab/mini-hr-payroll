import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { AppShell } from '@/components/layout/AppShell';
import DashboardPage from '@/pages/Dashboard';
import EmployeesPage from '@/pages/Employees';
import DepartmentsPage from '@/pages/Departments';
import AttendancePage from '@/pages/Attendance';
import PayrollPage from '@/pages/Payroll';

const queryClient = new QueryClient();

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <Routes>
          <Route element={<AppShell />}>
            <Route index element={<DashboardPage />} />
            <Route path="employees" element={<EmployeesPage />} />
            <Route path="departments" element={<DepartmentsPage />} />
            <Route path="attendance" element={<AttendancePage />} />
            <Route path="payroll" element={<PayrollPage />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </QueryClientProvider>
  );
}
