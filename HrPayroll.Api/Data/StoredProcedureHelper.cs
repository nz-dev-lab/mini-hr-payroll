using System.Data;
using Microsoft.Data.SqlClient;

namespace HrPayroll.Api.Data;

/// <summary>
/// Reduces SqlParameter boilerplate when calling stored procedures.
/// </summary>
public static class SP
{
    /// <summary>Creates an input parameter. Converts null to DBNull automatically.</summary>
    public static SqlParameter Param(string name, object? value) =>
        new SqlParameter(name, value ?? DBNull.Value);

    /// <summary>Creates an OUTPUT parameter for capturing return values from SPs.</summary>
    public static SqlParameter ParamOut(string name, SqlDbType type)
    {
        var p = new SqlParameter(name, type)
        {
            Direction = ParameterDirection.Output
        };
        return p;
    }

    /// <summary>Reads an int OUTPUT parameter after SP execution.</summary>
    public static int GetInt(SqlParameter p) => (int)p.Value;
}
