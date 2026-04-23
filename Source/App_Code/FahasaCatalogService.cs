using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;

public class CatalogProduct
{
    public CatalogProduct()
    {
        GalleryImages = new List<string>();
    }

    public int MaSP { get; set; }
    public string Slug { get; set; }
    public string TenSP { get; set; }
    public string TacGia { get; set; }
    public string MoTa { get; set; }
    public decimal Gia { get; set; }
    public decimal? GiaKhuyenMai { get; set; }
    public int? PhanTramGiam { get; set; }
    public string HinhAnh { get; set; }
    public string LoaiBia { get; set; }
    public string NhaXuatBan { get; set; }
    public string NhaCungCap { get; set; }
    public decimal? DanhGia { get; set; }
    public string NguonUrl { get; set; }
    public List<string> GalleryImages { get; set; }

    public decimal GiaHienThi
    {
        get
        {
            if (GiaKhuyenMai.HasValue && GiaKhuyenMai.Value > 0)
            {
                return GiaKhuyenMai.Value;
            }

            return Gia;
        }
    }

    public string GiaText
    {
        get { return string.Format(CultureInfo.GetCultureInfo("vi-VN"), "{0:N0}đ", GiaHienThi); }
    }

    public string GiaGocText
    {
        get
        {
            if (GiaKhuyenMai.HasValue && Gia > GiaKhuyenMai.Value)
            {
                return string.Format(CultureInfo.GetCultureInfo("vi-VN"), "{0:N0}đ", Gia);
            }

            return string.Empty;
        }
    }

    public string DiscountText
    {
        get
        {
            if (PhanTramGiam.HasValue && PhanTramGiam.Value > 0)
            {
                return string.Format("-{0}%", PhanTramGiam.Value);
            }

            return string.Empty;
        }
    }

    public string DisplayImageUrl
    {
        get
        {
            if (string.IsNullOrWhiteSpace(HinhAnh))
            {
                return "https://placehold.co/400x550/FFF/333?text=Book";
            }

            if (HinhAnh.StartsWith("http://", StringComparison.OrdinalIgnoreCase) ||
                HinhAnh.StartsWith("https://", StringComparison.OrdinalIgnoreCase) ||
                HinhAnh.StartsWith("/", StringComparison.OrdinalIgnoreCase))
            {
                return HinhAnh;
            }

            if (HinhAnh.StartsWith("img/", StringComparison.OrdinalIgnoreCase))
            {
                return HinhAnh;
            }

            return "img/books/" + HinhAnh;
        }
    }
}

internal class FahasaSeedProduct
{
    public string title { get; set; }
    public string productUrl { get; set; }
    public string price { get; set; }
    public string oldPrice { get; set; }
    public string discount { get; set; }
    public string rating { get; set; }
    public string sold { get; set; }
    public string thumbnailUrl { get; set; }
    public string id { get; set; }
    public string pageUrl { get; set; }
    public int pageNumber { get; set; }
    public string scrapedAt { get; set; }
    public string supplier { get; set; }
    public string author { get; set; }
    public string publisher { get; set; }
    public string coverType { get; set; }
    public string description { get; set; }
    public List<string> imageUrls { get; set; }
    public int imageCount { get; set; }
    public string detailScrapedAt { get; set; }
}

public static class FahasaCatalogService
{
    private const string SourceName = "FAHASA";
    private static readonly object SyncRoot = new object();
    private static bool _initialized;

    public static List<CatalogProduct> GetFeaturedProducts(int take)
    {
        EnsureInitialized();

        using (SqlConnection connection = CreateOpenConnection())
        {
            bool importedOnly = HasImportedCatalog(connection);
            string sql = string.Format(
                "SELECT TOP ({0}) sp.MaSP, sp.Slug, sp.TenSP, sp.TacGia, sp.MoTa, sp.Gia, sp.GiaKhuyenMai, sp.PhanTramGiam, sp.HinhAnh, sp.LoaiBia, sp.NhaXuatBan, sp.NhaCungCap, sp.DanhGia, sp.NguonUrl FROM dbo.SanPham sp WHERE {1} ORDER BY sp.MaSP DESC",
                take,
                importedOnly ? "sp.TrangThai = 1 AND sp.NguonDuLieu = @NguonDuLieu" : "sp.TrangThai = 1");

            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                if (importedOnly)
                {
                    command.Parameters.AddWithValue("@NguonDuLieu", SourceName);
                }

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    return ReadProducts(reader);
                }
            }
        }
    }

    public static List<CatalogProduct> GetAllProducts()
    {
        EnsureInitialized();

        using (SqlConnection connection = CreateOpenConnection())
        {
            bool importedOnly = HasImportedCatalog(connection);
            string sql = "SELECT sp.MaSP, sp.Slug, sp.TenSP, sp.TacGia, sp.MoTa, sp.Gia, sp.GiaKhuyenMai, sp.PhanTramGiam, sp.HinhAnh, sp.LoaiBia, sp.NhaXuatBan, sp.NhaCungCap, sp.DanhGia, sp.NguonUrl FROM dbo.SanPham sp WHERE " +
                         (importedOnly ? "sp.TrangThai = 1 AND sp.NguonDuLieu = @NguonDuLieu" : "sp.TrangThai = 1") +
                         " ORDER BY sp.MaSP DESC";

            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                if (importedOnly)
                {
                    command.Parameters.AddWithValue("@NguonDuLieu", SourceName);
                }

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    return ReadProducts(reader);
                }
            }
        }
    }

    public static CatalogProduct GetFirstProduct()
    {
        List<CatalogProduct> products = GetFeaturedProducts(1);
        if (products.Count == 0)
        {
            return null;
        }

        return products[0];
    }

    public static CatalogProduct GetProductByIdOrSlug(string idOrSlug)
    {
        EnsureInitialized();

        using (SqlConnection connection = CreateOpenConnection())
        {
            bool importedOnly = HasImportedCatalog(connection);
            bool isNumericId = false;
            int maSP = 0;

            if (!string.IsNullOrWhiteSpace(idOrSlug))
            {
                isNumericId = int.TryParse(idOrSlug, out maSP);
            }

            string sql = "SELECT TOP 1 sp.MaSP, sp.Slug, sp.TenSP, sp.TacGia, sp.MoTa, sp.Gia, sp.GiaKhuyenMai, sp.PhanTramGiam, sp.HinhAnh, sp.LoaiBia, sp.NhaXuatBan, sp.NhaCungCap, sp.DanhGia, sp.NguonUrl FROM dbo.SanPham sp WHERE " +
                         (importedOnly ? "sp.TrangThai = 1 AND sp.NguonDuLieu = @NguonDuLieu AND " : "sp.TrangThai = 1 AND ") +
                         (isNumericId ? "sp.MaSP = @Id" : "sp.Slug = @Slug") +
                         " ORDER BY sp.MaSP DESC";

            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                if (importedOnly)
                {
                    command.Parameters.AddWithValue("@NguonDuLieu", SourceName);
                }

                if (isNumericId)
                {
                    command.Parameters.AddWithValue("@Id", maSP);
                }
                else
                {
                    command.Parameters.AddWithValue("@Slug", (object)idOrSlug ?? DBNull.Value);
                }

                CatalogProduct product = null;
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    List<CatalogProduct> products = ReadProducts(reader);
                    if (products.Count > 0)
                    {
                        product = products[0];
                    }
                }

                if (product == null)
                {
                    return null;
                }

                using (SqlCommand imageCommand = new SqlCommand("SELECT UrlAnh FROM dbo.SanPhamHinhAnh WHERE MaSP = @MaSP ORDER BY ThuTu ASC, MaAnh ASC", connection))
                {
                    imageCommand.Parameters.AddWithValue("@MaSP", product.MaSP);
                    using (SqlDataReader imageReader = imageCommand.ExecuteReader())
                    {
                        while (imageReader.Read())
                        {
                            string imageUrl = SafeGetString(imageReader, "UrlAnh");
                            if (!string.IsNullOrWhiteSpace(imageUrl))
                            {
                                product.GalleryImages.Add(imageUrl);
                            }
                        }
                    }
                }

                if (product.GalleryImages.Count == 0 && !string.IsNullOrWhiteSpace(product.DisplayImageUrl))
                {
                    product.GalleryImages.Add(product.DisplayImageUrl);
                }

                return product;
            }
        }
    }

    private static void EnsureInitialized()
    {
        if (_initialized)
        {
            return;
        }

        lock (SyncRoot)
        {
            if (_initialized)
            {
                return;
            }

            EnsureDatabaseSchema();
            EnsureSeedData();
            _initialized = true;
        }
    }

    private static void EnsureDatabaseSchema()
    {
        string schemaPath = ResolveSchemaScriptPath();
        string script = File.ReadAllText(schemaPath);
        string[] batches = Regex.Split(script, @"^\s*GO\s*;?\s*$", RegexOptions.Multiline | RegexOptions.IgnoreCase);

        using (SqlConnection connection = CreateMasterConnection())
        {
            connection.Open();

            for (int i = 0; i < batches.Length; i++)
            {
                string batch = batches[i].Trim();
                if (string.IsNullOrWhiteSpace(batch))
                {
                    continue;
                }

                using (SqlCommand command = new SqlCommand(batch, connection))
                {
                    command.CommandTimeout = 120;
                    command.ExecuteNonQuery();
                }
            }
        }
    }

    private static void EnsureSeedData()
    {
        using (SqlConnection connection = CreateOpenConnection())
        {
            int importedCount = GetCount(connection, "SELECT COUNT(1) FROM dbo.SanPham WHERE NguonDuLieu = @NguonDuLieu", true);
            if (importedCount > 0)
            {
                return;
            }

            Dictionary<string, FahasaSeedProduct> sourceProducts = LoadSeedProducts();
            if (sourceProducts == null || sourceProducts.Count == 0)
            {
                return;
            }

            using (SqlTransaction transaction = connection.BeginTransaction())
            {
                int maDanhMuc = EnsureThieuNhiCategory(connection, transaction);
                List<KeyValuePair<string, FahasaSeedProduct>> orderedProducts = sourceProducts
                    .Where(pair => pair.Value != null)
                    .OrderBy(pair => pair.Value.pageNumber)
                    .ThenBy(pair => pair.Value.title)
                    .ToList();

                for (int i = 0; i < orderedProducts.Count; i++)
                {
                    FahasaSeedProduct item = orderedProducts[i].Value;
                    if (ShouldSkipItem(item))
                    {
                        continue;
                    }

                    decimal currentPrice = ParseCurrency(item.price);
                    decimal oldPrice = ParseCurrency(item.oldPrice);
                    decimal basePrice = currentPrice > 0 ? currentPrice : oldPrice;
                    decimal? salePrice = null;

                    if (oldPrice > currentPrice && currentPrice > 0)
                    {
                        basePrice = oldPrice;
                        salePrice = currentPrice;
                    }

                    if (basePrice <= 0)
                    {
                        continue;
                    }

                    int? discountPercent = ParseNullableInt(item.discount);
                    decimal? rating = ParseNullableDecimal(item.rating);

                    using (SqlCommand insertProduct = new SqlCommand(@"
INSERT INTO dbo.SanPham
    (Slug, TenSP, TacGia, MoTa, Gia, GiaKhuyenMai, PhanTramGiam, SoLuongTon, HinhAnh, LoaiBia, NhaXuatBan, NhaCungCap, DanhGia, NguonUrl, NguonDuLieu, MaDM, TrangThai)
VALUES
    (@Slug, @TenSP, @TacGia, @MoTa, @Gia, @GiaKhuyenMai, @PhanTramGiam, @SoLuongTon, @HinhAnh, @LoaiBia, @NhaXuatBan, @NhaCungCap, @DanhGia, @NguonUrl, @NguonDuLieu, @MaDM, 1);
SELECT CAST(SCOPE_IDENTITY() AS INT);", connection, transaction))
                    {
                        insertProduct.Parameters.AddWithValue("@Slug", ToDbValue(Truncate(item.id, 255)));
                        insertProduct.Parameters.AddWithValue("@TenSP", Truncate(item.title, 255));
                        insertProduct.Parameters.AddWithValue("@TacGia", ToDbValue(Truncate(item.author, 255)));
                        insertProduct.Parameters.AddWithValue("@MoTa", ToDbValue(item.description));
                        insertProduct.Parameters.AddWithValue("@Gia", basePrice);
                        insertProduct.Parameters.AddWithValue("@GiaKhuyenMai", ToDbValue(salePrice));
                        insertProduct.Parameters.AddWithValue("@PhanTramGiam", ToDbValue(discountPercent));
                        insertProduct.Parameters.AddWithValue("@SoLuongTon", 100);
                        insertProduct.Parameters.AddWithValue("@HinhAnh", ToDbValue(Truncate(item.thumbnailUrl, 500)));
                        insertProduct.Parameters.AddWithValue("@LoaiBia", ToDbValue(Truncate(item.coverType, 100)));
                        insertProduct.Parameters.AddWithValue("@NhaXuatBan", ToDbValue(Truncate(item.publisher, 255)));
                        insertProduct.Parameters.AddWithValue("@NhaCungCap", ToDbValue(Truncate(item.supplier, 255)));
                        insertProduct.Parameters.AddWithValue("@DanhGia", ToDbValue(rating));
                        insertProduct.Parameters.AddWithValue("@NguonUrl", ToDbValue(Truncate(item.productUrl, 500)));
                        insertProduct.Parameters.AddWithValue("@NguonDuLieu", SourceName);
                        insertProduct.Parameters.AddWithValue("@MaDM", maDanhMuc);

                        int maSP = Convert.ToInt32(insertProduct.ExecuteScalar());
                        InsertProductImages(connection, transaction, maSP, item);
                    }
                }

                transaction.Commit();
            }
        }
    }

    private static void InsertProductImages(SqlConnection connection, SqlTransaction transaction, int maSP, FahasaSeedProduct item)
    {
        HashSet<string> uniqueImages = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        List<string> images = new List<string>();

        if (!string.IsNullOrWhiteSpace(item.thumbnailUrl) && uniqueImages.Add(item.thumbnailUrl.Trim()))
        {
            images.Add(item.thumbnailUrl.Trim());
        }

        if (item.imageUrls != null)
        {
            for (int i = 0; i < item.imageUrls.Count; i++)
            {
                string imageUrl = item.imageUrls[i];
                if (string.IsNullOrWhiteSpace(imageUrl))
                {
                    continue;
                }

                imageUrl = imageUrl.Trim();
                if (uniqueImages.Add(imageUrl))
                {
                    images.Add(imageUrl);
                }
            }
        }

        for (int i = 0; i < images.Count; i++)
        {
            using (SqlCommand command = new SqlCommand("INSERT INTO dbo.SanPhamHinhAnh (MaSP, UrlAnh, ThuTu) VALUES (@MaSP, @UrlAnh, @ThuTu)", connection, transaction))
            {
                command.Parameters.AddWithValue("@MaSP", maSP);
                command.Parameters.AddWithValue("@UrlAnh", Truncate(images[i], 500));
                command.Parameters.AddWithValue("@ThuTu", i);
                command.ExecuteNonQuery();
            }
        }
    }

    private static int EnsureThieuNhiCategory(SqlConnection connection, SqlTransaction transaction)
    {
        using (SqlCommand command = new SqlCommand("SELECT TOP 1 MaDM FROM dbo.DanhMuc WHERE TenDM = N'Thiếu nhi'", connection, transaction))
        {
            object existing = command.ExecuteScalar();
            if (existing != null && existing != DBNull.Value)
            {
                return Convert.ToInt32(existing);
            }
        }

        using (SqlCommand insert = new SqlCommand("INSERT INTO dbo.DanhMuc (TenDM, TrangThai) VALUES (N'Thiếu nhi', 1); SELECT CAST(SCOPE_IDENTITY() AS INT);", connection, transaction))
        {
            return Convert.ToInt32(insert.ExecuteScalar());
        }
    }

    private static Dictionary<string, FahasaSeedProduct> LoadSeedProducts()
    {
        string jsonPath = ResolveJsonPath();
        string json = File.ReadAllText(jsonPath);
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        serializer.MaxJsonLength = int.MaxValue;
        serializer.RecursionLimit = 1024;
        return serializer.Deserialize<Dictionary<string, FahasaSeedProduct>>(json);
    }

    private static List<CatalogProduct> ReadProducts(SqlDataReader reader)
    {
        List<CatalogProduct> products = new List<CatalogProduct>();

        while (reader.Read())
        {
            CatalogProduct product = new CatalogProduct();
            product.MaSP = SafeGetInt(reader, "MaSP");
            product.Slug = SafeGetString(reader, "Slug");
            product.TenSP = SafeGetString(reader, "TenSP");
            product.TacGia = SafeGetString(reader, "TacGia");
            product.MoTa = SafeGetString(reader, "MoTa");
            product.Gia = SafeGetDecimal(reader, "Gia");
            product.GiaKhuyenMai = SafeGetNullableDecimal(reader, "GiaKhuyenMai");
            product.PhanTramGiam = SafeGetNullableInt(reader, "PhanTramGiam");
            product.HinhAnh = SafeGetString(reader, "HinhAnh");
            product.LoaiBia = SafeGetString(reader, "LoaiBia");
            product.NhaXuatBan = SafeGetString(reader, "NhaXuatBan");
            product.NhaCungCap = SafeGetString(reader, "NhaCungCap");
            product.DanhGia = SafeGetNullableDecimal(reader, "DanhGia");
            product.NguonUrl = SafeGetString(reader, "NguonUrl");
            products.Add(product);
        }

        return products;
    }

    private static bool HasImportedCatalog(SqlConnection connection)
    {
        return GetCount(connection, "SELECT COUNT(1) FROM dbo.SanPham WHERE TrangThai = 1 AND NguonDuLieu = @NguonDuLieu", true) > 0;
    }

    private static int GetCount(SqlConnection connection, string sql, bool includeSourceParameter)
    {
        using (SqlCommand command = new SqlCommand(sql, connection))
        {
            if (includeSourceParameter)
            {
                command.Parameters.AddWithValue("@NguonDuLieu", SourceName);
            }

            object value = command.ExecuteScalar();
            if (value == null || value == DBNull.Value)
            {
                return 0;
            }

            return Convert.ToInt32(value);
        }
    }

    private static SqlConnection CreateOpenConnection()
    {
        SqlConnection connection = new SqlConnection(GetConnectionString());
        connection.Open();
        return connection;
    }

    private static SqlConnection CreateMasterConnection()
    {
        SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(GetConnectionString());
        builder.InitialCatalog = "master";
        builder.ConnectTimeout = 120;
        return new SqlConnection(builder.ConnectionString);
    }

    private static string GetConnectionString()
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

    private static string ResolveSchemaScriptPath()
    {
        string scriptPath = Path.GetFullPath(Path.Combine(GetApplicationRootPath(), "..", "Database_Schema.sql"));
        if (!File.Exists(scriptPath))
        {
            throw new FileNotFoundException("Không tìm thấy file schema database.", scriptPath);
        }

        return scriptPath;
    }

    private static string ResolveJsonPath()
    {
        string configuredPath = Environment.GetEnvironmentVariable("BAN_SACH_FAHASA_JSON_PATH");
        if (!string.IsNullOrWhiteSpace(configuredPath))
        {
            string fullConfiguredPath = Path.GetFullPath(configuredPath);
            if (File.Exists(fullConfiguredPath))
            {
                return fullConfiguredPath;
            }
        }

        string repoLocalPath = Path.GetFullPath(Path.Combine(GetApplicationRootPath(), "App_Data", "product-details.json"));
        if (File.Exists(repoLocalPath))
        {
            return repoLocalPath;
        }

        string defaultPath = Path.GetFullPath(Path.Combine(GetApplicationRootPath(), "..", "..", "fahasa_output", "product-details.json"));
        if (!File.Exists(defaultPath))
        {
            throw new FileNotFoundException("Không tìm thấy file dữ liệu Fahasa để import.", defaultPath);
        }

        return defaultPath;
    }

    private static string GetApplicationRootPath()
    {
        string envAppRoot = Environment.GetEnvironmentVariable("BAN_SACH_APP_ROOT");
        if (!string.IsNullOrWhiteSpace(envAppRoot))
        {
            return Path.GetFullPath(envAppRoot);
        }

        if (!string.IsNullOrWhiteSpace(HttpRuntime.AppDomainAppPath))
        {
            return HttpRuntime.AppDomainAppPath;
        }

        return AppDomain.CurrentDomain.BaseDirectory;
    }

    private static bool ShouldSkipItem(FahasaSeedProduct item)
    {
        if (item == null)
        {
            return true;
        }

        string id = item.id ?? string.Empty;
        string productUrl = item.productUrl ?? string.Empty;
        string description = item.description ?? string.Empty;

        if (id.StartsWith("series", StringComparison.OrdinalIgnoreCase))
        {
            return true;
        }

        if (productUrl.IndexOf("/series", StringComparison.OrdinalIgnoreCase) >= 0)
        {
            return true;
        }

        if (description.IndexOf("Tất Cả Nhóm Series", StringComparison.OrdinalIgnoreCase) >= 0)
        {
            return true;
        }

        if (string.IsNullOrWhiteSpace(item.title))
        {
            return true;
        }

        return false;
    }

    private static decimal ParseCurrency(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return 0;
        }

        string digits = Regex.Replace(value, @"[^0-9]", string.Empty);
        if (string.IsNullOrWhiteSpace(digits))
        {
            return 0;
        }

        decimal result;
        if (decimal.TryParse(digits, NumberStyles.Number, CultureInfo.InvariantCulture, out result))
        {
            return result;
        }

        return 0;
    }

    private static int? ParseNullableInt(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        string digits = Regex.Replace(value, @"[^0-9]", string.Empty);
        if (string.IsNullOrWhiteSpace(digits))
        {
            return null;
        }

        int result;
        if (int.TryParse(digits, out result))
        {
            return result;
        }

        return null;
    }

    private static decimal? ParseNullableDecimal(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        decimal result;
        if (decimal.TryParse(value.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out result))
        {
            return result;
        }

        return null;
    }

    private static object ToDbValue(object value)
    {
        if (value == null)
        {
            return DBNull.Value;
        }

        string stringValue = value as string;
        if (stringValue != null && string.IsNullOrWhiteSpace(stringValue))
        {
            return DBNull.Value;
        }

        return value;
    }

    private static string Truncate(string value, int maxLength)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        value = value.Trim();
        if (value.Length <= maxLength)
        {
            return value;
        }

        return value.Substring(0, maxLength);
    }

    private static string SafeGetString(IDataRecord record, string columnName)
    {
        int ordinal = record.GetOrdinal(columnName);
        if (record.IsDBNull(ordinal))
        {
            return string.Empty;
        }

        return Convert.ToString(record.GetValue(ordinal));
    }

    private static int SafeGetInt(IDataRecord record, string columnName)
    {
        int ordinal = record.GetOrdinal(columnName);
        if (record.IsDBNull(ordinal))
        {
            return 0;
        }

        return Convert.ToInt32(record.GetValue(ordinal));
    }

    private static int? SafeGetNullableInt(IDataRecord record, string columnName)
    {
        int ordinal = record.GetOrdinal(columnName);
        if (record.IsDBNull(ordinal))
        {
            return null;
        }

        return Convert.ToInt32(record.GetValue(ordinal));
    }

    private static decimal SafeGetDecimal(IDataRecord record, string columnName)
    {
        int ordinal = record.GetOrdinal(columnName);
        if (record.IsDBNull(ordinal))
        {
            return 0;
        }

        return Convert.ToDecimal(record.GetValue(ordinal));
    }

    private static decimal? SafeGetNullableDecimal(IDataRecord record, string columnName)
    {
        int ordinal = record.GetOrdinal(columnName);
        if (record.IsDBNull(ordinal))
        {
            return null;
        }

        return Convert.ToDecimal(record.GetValue(ordinal));
    }
}
