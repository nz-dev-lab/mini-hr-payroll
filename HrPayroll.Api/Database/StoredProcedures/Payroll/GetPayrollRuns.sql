DROP PROCEDURE IF EXISTS GetPayrollRuns;
GO

CREATE PROCEDURE GetPayrollRuns
    @Month INT = NULL,
    @Year  INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        pr.Id,
        pr.Month,
        pr.Year,
        pr.ProcessedAt,
        pr.IsLocked,
        pr.TotalGross,
        pr.TotalNet,
        (SELECT COUNT(*) FROM PayrollLineItems WHERE PayrollRunId = pr.Id) AS EmployeeCount
    FROM PayrollRuns pr
    WHERE (@Month IS NULL OR pr.Month = @Month)
      AND (@Year  IS NULL OR pr.Year  = @Year)
    ORDER BY pr.Year DESC, pr.Month DESC;
END;
GO
