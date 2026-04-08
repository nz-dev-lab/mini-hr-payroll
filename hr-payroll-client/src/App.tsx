import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { Toaster } from 'react-hot-toast';
import { ThemeProvider } from '@/contexts/ThemeContext';
import { AuthProvider } from '@/contexts/AuthContext';
import { AppShell } from '@/components/layout/AppShell';
import { ProtectedRoute } from '@/components/shared/ProtectedRoute';
import LoginPage from '@/pages/Login';
import DashboardPage from '@/pages/Dashboard';
import EmployeesPage from '@/pages/Employees';
import DepartmentsPage from '@/pages/Departments';
import AttendancePage from '@/pages/Attendance';
import PayrollPage from '@/pages/Payroll';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 1000 * 60 * 5 }, // 5-min cache
  },
});

export default function App() {
  return (
    <ThemeProvider>
      <AuthProvider>
        <QueryClientProvider client={queryClient}>
          <BrowserRouter>
            <Routes>
              <Route path="login" element={<LoginPage />} />
              <Route element={<ProtectedRoute />}>
                <Route element={<AppShell />}>
                  <Route index element={<DashboardPage />} />
                  <Route path="employees" element={<EmployeesPage />} />
                  <Route path="departments" element={<DepartmentsPage />} />
                  <Route path="attendance" element={<AttendancePage />} />
                  <Route path="payroll" element={<PayrollPage />} />
                </Route>
              </Route>
            </Routes>
          </BrowserRouter>
          <Toaster position="top-right" />
        </QueryClientProvider>
      </AuthProvider>
    </ThemeProvider>
  );
}
