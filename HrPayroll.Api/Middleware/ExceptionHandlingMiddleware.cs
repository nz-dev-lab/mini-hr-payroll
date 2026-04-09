using Microsoft.Data.SqlClient;

namespace HrPayroll.Api.Middleware;

public class ExceptionHandlingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionHandlingMiddleware> _logger;

    public ExceptionHandlingMiddleware(RequestDelegate next, ILogger<ExceptionHandlingMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (SqlException ex)
        {
            _logger.LogError(ex, "SQL Exception: {Number} - {Message}", ex.Number, ex.Message);
            await HandleSqlExceptionAsync(context, ex);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception");
            context.Response.StatusCode = 500;
            context.Response.ContentType = "application/json";
            await context.Response.WriteAsJsonAsync(new { message = "An unexpected error occurred." });
        }
    }

    private static async Task HandleSqlExceptionAsync(HttpContext context, SqlException ex)
    {
        var (statusCode, message) = ex.Number switch
        {
            // Employee errors
            50001 => (404, "Employee not found."),
            50002 => (400, "Employee is not active or already terminated."),

            // Attendance errors
            50010 => (400, "Cannot mark attendance for a future date."),
            50011 => (400, "Employee is not active."),
            50012 => (409, "Insufficient annual leave balance."),

            // Payroll errors
            50020 => (409, "Payroll for this month has already been processed."),
            50021 => (400, "No active employees found to process payroll."),

            // Department errors
            50030 => (409, "Cannot delete a department with active employees."),
            50031 => (409, "A department with this name already exists."),

            // Generic SQL constraint violations
            2627 => (409, "A record with this value already exists."),
            547  => (409, "This operation violates a data integrity constraint."),

            _ => (500, "A database error occurred.")
        };

        context.Response.StatusCode = statusCode;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(new { message });
    }
}
