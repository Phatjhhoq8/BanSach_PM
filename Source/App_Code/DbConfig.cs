using System;
using System.Configuration;

public static class DbConfig
{
    public static string GetConnectionString()
    {
        string envConnectionString = Environment.GetEnvironmentVariable("BAN_SACH_CONNECTION_STRING");
        if (!string.IsNullOrWhiteSpace(envConnectionString))
        {
            return envConnectionString;
        }

        ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["BanSachConnectionString"];
        if (settings == null || string.IsNullOrWhiteSpace(settings.ConnectionString))
        {
            throw new InvalidOperationException("Không tìm thấy chuỗi kết nối BanSachConnectionString.");
        }

        return settings.ConnectionString;
    }
}
