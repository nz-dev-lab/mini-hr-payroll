import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from '@/components/ui/dialog';
import { usePayrollRunDetails } from '@/hooks/usePayroll';

interface RunDetailsDialogProps {
  payrollRunId: number | undefined;
  onOpenChange: (open: boolean) => void;
}

export function RunDetailsDialog({ payrollRunId, onOpenChange }: RunDetailsDialogProps) {
  const { data: items = [], isLoading } = usePayrollRunDetails(payrollRunId);

  return (
    <Dialog open={!!payrollRunId} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-3xl">
        <DialogHeader>
          <DialogTitle>Payroll Run Details</DialogTitle>
          <DialogDescription>Salary breakdown for each employee in this run.</DialogDescription>
        </DialogHeader>

        {isLoading ? (
          <p className="text-sm text-muted-foreground py-4">Loading...</p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b text-muted-foreground text-left">
                  <th className="py-2 pr-4">Employee</th>
                  <th className="py-2 pr-4 text-right">Basic</th>
                  <th className="py-2 pr-4 text-right">Housing</th>
                  <th className="py-2 pr-4 text-right">Transport</th>
                  <th className="py-2 pr-4 text-right">Gross</th>
                  <th className="py-2 pr-4 text-right">Absent</th>
                  <th className="py-2 pr-4 text-right">Deduction</th>
                  <th className="py-2 text-right font-semibold">Net</th>
                </tr>
              </thead>
              <tbody>
                {items.map((item) => (
                  <tr key={item.id} className="border-b last:border-0">
                    <td className="py-2 pr-4 font-medium">{item.employeeName}</td>
                    <td className="py-2 pr-4 text-right tabular-nums">{item.basicSalary.toLocaleString()}</td>
                    <td className="py-2 pr-4 text-right tabular-nums">{item.housingAllowance.toLocaleString()}</td>
                    <td className="py-2 pr-4 text-right tabular-nums">{item.transportAllowance.toLocaleString()}</td>
                    <td className="py-2 pr-4 text-right tabular-nums">{item.grossSalary.toLocaleString()}</td>
                    <td className="py-2 pr-4 text-right tabular-nums">{item.absentDays}</td>
                    <td className="py-2 pr-4 text-right tabular-nums text-destructive">{item.absentDeduction.toLocaleString()}</td>
                    <td className="py-2 text-right tabular-nums font-semibold">{item.netSalary.toLocaleString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
