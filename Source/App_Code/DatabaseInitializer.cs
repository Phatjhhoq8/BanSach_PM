using System;
using System.Data.SqlClient;

public static class DatabaseInitializer
{
    private static readonly object PasswordMigrationLock = new object();
    private static bool _passwordsMigrated;

    public static void EnsureInitialized()
    {
        FahasaCatalogService.GetFeaturedProducts(1);
        MigratePlainTextPasswords();
    }

    public static string GetSetting(string key, string fallback)
    {
        EnsureInitialized();

        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT [Value] FROM dbo.CaiDat WHERE [Key] = @Key", conn))
            {
                cmd.Parameters.AddWithValue("@Key", key);
                conn.Open();
                object value = cmd.ExecuteScalar();
                if (value == null || value == DBNull.Value || string.IsNullOrWhiteSpace(value.ToString()))
                {
                    return fallback;
                }

                return value.ToString();
            }
        }
    }

    public static decimal GetDecimalSetting(string key, decimal fallback)
    {
        decimal value;
        if (decimal.TryParse(GetSetting(key, fallback.ToString(System.Globalization.CultureInfo.InvariantCulture)), out value))
        {
            return value;
        }

        return fallback;
    }

    private static void MigratePlainTextPasswords()
    {
        if (_passwordsMigrated) return;

        lock (PasswordMigrationLock)
        {
            if (_passwordsMigrated) return;

            using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
            {
                conn.Open();
                MigrateTable(conn, "dbo.KhachHang", "MaKH", "MatKhau");
                MigrateTable(conn, "dbo.AdminUser", "Username", "Password");
                _passwordsMigrated = true;
            }
        }
    }

    private static void MigrateTable(SqlConnection conn, string tableName, string keyColumn, string passwordColumn)
    {
        using (SqlCommand select = new SqlCommand("SELECT " + keyColumn + ", " + passwordColumn + " FROM " + tableName, conn))
        using (SqlDataReader reader = select.ExecuteReader())
        {
            System.Collections.Generic.List<object[]> rows = new System.Collections.Generic.List<object[]>();
            while (reader.Read())
            {
                string password = reader[passwordColumn].ToString();
                if (!SecurityHelper.IsHashed(password))
                {
                    rows.Add(new object[] { reader[keyColumn], SecurityHelper.HashPassword(password) });
                }
            }

            reader.Close();
            foreach (object[] row in rows)
            {
                using (SqlCommand update = new SqlCommand("UPDATE " + tableName + " SET " + passwordColumn + " = @Password WHERE " + keyColumn + " = @Key", conn))
                {
                    update.Parameters.AddWithValue("@Password", row[1]);
                    update.Parameters.AddWithValue("@Key", row[0]);
                    update.ExecuteNonQuery();
                }
            }
        }
    }
}
