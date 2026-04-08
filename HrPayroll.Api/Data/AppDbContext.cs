using Microsoft.EntityFrameworkCore;

namespace HrPayroll.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
}
