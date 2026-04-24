using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Web.Script.Serialization;

public class SeedProduct
{
    public string title { get; set; }
    public string productUrl { get; set; }
    public string thumbnailUrl { get; set; }
    public string id { get; set; }
    public string supplier { get; set; }
    public string author { get; set; }
    public string publisher { get; set; }
    public string coverType { get; set; }
    public string description { get; set; }
}

public static class RepairSqlVietnamese
{
    private static object DbText(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return DBNull.Value;
        }

        return value;
    }

    private static object Truncate(string value, int maxLength)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return DBNull.Value;
        }

        if (value.Length > maxLength)
        {
            return value.Substring(0, maxLength);
        }

        return value;
    }

    public static int Main(string[] args)
    {
        string root = Path.GetFullPath(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, ".."));
        string jsonPath = Path.Combine(root, "Source", "App_Data", "product-details.json");
        if (!File.Exists(jsonPath))
        {
            Console.Error.WriteLine("Missing JSON: " + jsonPath);
            return 1;
        }

        string json = File.ReadAllText(jsonPath, System.Text.Encoding.UTF8);
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        serializer.MaxJsonLength = int.MaxValue;
        serializer.RecursionLimit = 1024;
        Dictionary<string, SeedProduct> products = serializer.Deserialize<Dictionary<string, SeedProduct>>(json);

        string connString = "Data Source=.\\SQLEXPRESS;Initial Catalog=BanSachPremium;Integrated Security=True";
        int updated = 0;
        int missing = 0;

        using (SqlConnection connection = new SqlConnection(connString))
        {
            connection.Open();
            using (SqlTransaction transaction = connection.BeginTransaction())
            {
                try
                {
                    foreach (KeyValuePair<string, SeedProduct> pair in products)
                    {
                        SeedProduct item = pair.Value;
                        if (item == null)
                        {
                            continue;
                        }

                        string slug = string.IsNullOrWhiteSpace(item.id) ? pair.Key : item.id;
                        using (SqlCommand command = new SqlCommand(@"
UPDATE dbo.SanPham
SET TenSP = @TenSP,
    TacGia = @TacGia,
    MoTa = @MoTa,
    HinhAnh = @HinhAnh,
    LoaiBia = @LoaiBia,
    NhaXuatBan = @NhaXuatBan,
    NhaCungCap = @NhaCungCap,
    NguonUrl = @NguonUrl
WHERE Slug = @Slug", connection, transaction))
                        {
                            command.Parameters.AddWithValue("@TenSP", Truncate(item.title, 255));
                            command.Parameters.AddWithValue("@TacGia", Truncate(item.author, 255));
                            command.Parameters.AddWithValue("@MoTa", DbText(item.description));
                            command.Parameters.AddWithValue("@HinhAnh", Truncate(item.thumbnailUrl, 500));
                            command.Parameters.AddWithValue("@LoaiBia", Truncate(item.coverType, 100));
                            command.Parameters.AddWithValue("@NhaXuatBan", Truncate(item.publisher, 255));
                            command.Parameters.AddWithValue("@NhaCungCap", Truncate(item.supplier, 255));
                            command.Parameters.AddWithValue("@NguonUrl", Truncate(item.productUrl, 500));
                            command.Parameters.AddWithValue("@Slug", slug);

                            int rows = command.ExecuteNonQuery();
                            if (rows > 0)
                            {
                                updated += rows;
                            }
                            else
                            {
                                missing++;
                            }
                        }
                    }

                    UpdateCategory(connection, transaction, 6, "Văn học");
                    UpdateCategory(connection, transaction, 8, "Kinh tế");
                    UpdateCategory(connection, transaction, 10, "Thiếu nhi");
                    UpdateCategory(connection, transaction, 11, "Nuôi dạy con");
                    UpdateCategory(connection, transaction, 12, "Tâm lý - Kỹ năng sống");

                    using (SqlCommand command = new SqlCommand(@"
UPDATE dm
SET TrangThai = 0
FROM dbo.DanhMuc dm
WHERE NOT EXISTS (SELECT 1 FROM dbo.SanPham sp WHERE sp.MaDM = dm.MaDM)", connection, transaction))
                    {
                        command.ExecuteNonQuery();
                    }

                    transaction.Commit();
                }
                catch
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

        Console.OutputEncoding = System.Text.Encoding.UTF8;
        Console.WriteLine("updated_products=" + updated.ToString(CultureInfo.InvariantCulture));
        Console.WriteLine("missing_slugs=" + missing.ToString(CultureInfo.InvariantCulture));
        return 0;
    }

    private static void UpdateCategory(SqlConnection connection, SqlTransaction transaction, int id, string name)
    {
        using (SqlCommand command = new SqlCommand("UPDATE dbo.DanhMuc SET TenDM = @Name, TrangThai = 1 WHERE MaDM = @Id", connection, transaction))
        {
            command.Parameters.AddWithValue("@Name", name);
            command.Parameters.AddWithValue("@Id", id);
            command.ExecuteNonQuery();
        }
    }
}
