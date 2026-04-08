using Microsoft.EntityFrameworkCore;
using HrPayroll.Api.Models;

namespace HrPayroll.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Employee> Employees => Set<Employee>();
    public DbSet<Department> Departments => Set<Department>();
    public DbSet<AttendanceRecord> AttendanceRecords => Set<AttendanceRecord>();
    public DbSet<PayrollRun> PayrollRuns => Set<PayrollRun>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Employee
        modelBuilder.Entity<Employee>(e =>
        {
            e.Property(x => x.FirstName).HasMaxLength(100).IsRequired();
            e.Property(x => x.LastName).HasMaxLength(100).IsRequired();
            e.Property(x => x.Email).HasMaxLength(200).IsRequired();
            e.HasIndex(x => x.Email).IsUnique();
            e.Property(x => x.Phone).HasMaxLength(20);
            e.Property(x => x.JobTitle).HasMaxLength(150).IsRequired();
            e.Property(x => x.BaseSalary).HasColumnType("decimal(18,2)");
        });

        // Department — prevent cascade delete on Manager FK to avoid cycles
        modelBuilder.Entity<Department>(d =>
        {
            d.Property(x => x.Name).HasMaxLength(100).IsRequired();
            d.HasOne(x => x.Manager)
             .WithMany()
             .HasForeignKey(x => x.ManagerId)
             .OnDelete(DeleteBehavior.SetNull);
        });

        // Employee → Department
        modelBuilder.Entity<Employee>()
            .HasOne(e => e.Department)
            .WithMany(d => d.Employees)
            .HasForeignKey(e => e.DepartmentId)
            .OnDelete(DeleteBehavior.Restrict);

        // PayrollRun
        modelBuilder.Entity<PayrollRun>(p =>
        {
            p.Property(x => x.BasicSalary).HasColumnType("decimal(18,2)");
            p.Property(x => x.Allowances).HasColumnType("decimal(18,2)");
            p.Property(x => x.Deductions).HasColumnType("decimal(18,2)");
            p.Ignore(x => x.NetSalary); // computed, not stored
        });
    }
}
