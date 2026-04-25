using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

public static class CategoryResolver
{
    private static readonly Dictionary<string, string> CategoryByPageUrlSegment = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
    {
        { "/sach-hoc-ngoai-ngu/", "Sách học ngoại ngữ" },
        { "/kinh-te/", "Kinh tế" },
        { "/tam-ly-ky-nang-song/", "Tâm lý - Kỹ năng sống" },
        { "/van-hoc-trong-nuoc/", "Văn học trong nước" },
        { "/van-hoc-nuoc-ngoai/", "Văn học nước ngoài" },
        { "/thieu-nhi/", "Thiếu nhi" },
        { "/sach-giao-khoa-tham-khao/", "Sách giáo khoa - Tham khảo" },
        { "/nuoi-day-con/", "Nuôi dạy con" }
    };

    public static string NormalizeCategoryName(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        return Regex.Replace(value.Trim(), @"\s+", " ");
    }

    public static int ResolveCategoryId(SqlConnection connection, SqlTransaction transaction, string categoryName)
    {
        string normalizedName = NormalizeCategoryName(categoryName);
        if (string.IsNullOrWhiteSpace(normalizedName))
        {
            throw new ArgumentException("Tên danh mục không hợp lệ.", "categoryName");
        }

        using (SqlCommand command = new SqlCommand(@"
SELECT TOP 1 MaDM, TrangThai
FROM dbo.DanhMuc
WHERE LTRIM(RTRIM(TenDM)) = @TenDM
ORDER BY MaDM", connection, transaction))
        {
            command.Parameters.AddWithValue("@TenDM", normalizedName);
            using (SqlDataReader reader = command.ExecuteReader())
            {
                if (reader.Read())
                {
                    int maDM = Convert.ToInt32(reader["MaDM"]);
                    bool trangThai = Convert.ToBoolean(reader["TrangThai"]);
                    reader.Close();

                    if (!trangThai)
                    {
                        using (SqlCommand update = new SqlCommand("UPDATE dbo.DanhMuc SET TenDM = @TenDM, TrangThai = 1 WHERE MaDM = @MaDM", connection, transaction))
                        {
                            update.Parameters.AddWithValue("@TenDM", normalizedName);
                            update.Parameters.AddWithValue("@MaDM", maDM);
                            update.ExecuteNonQuery();
                        }
                    }

                    return maDM;
                }
            }
        }

        using (SqlCommand insert = new SqlCommand("INSERT INTO dbo.DanhMuc (TenDM, TrangThai) VALUES (@TenDM, 1); SELECT CAST(SCOPE_IDENTITY() AS INT);", connection, transaction))
        {
            insert.Parameters.AddWithValue("@TenDM", normalizedName);
            return Convert.ToInt32(insert.ExecuteScalar());
        }
    }

    public static string ResolveImportedCategoryName(string categoryName, string pageUrl)
    {
        string normalizedName = NormalizeCategoryName(categoryName);
        if (!string.IsNullOrWhiteSpace(normalizedName))
        {
            return normalizedName;
        }

        if (!string.IsNullOrWhiteSpace(pageUrl))
        {
            foreach (KeyValuePair<string, string> entry in CategoryByPageUrlSegment)
            {
                if (pageUrl.IndexOf(entry.Key, StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    return entry.Value;
                }
            }
        }

        return "Thiếu nhi";
    }
}
