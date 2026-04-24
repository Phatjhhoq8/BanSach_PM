using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;

public partial class Admin_ProductEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategories();
            
            string id = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                litPageTitle.Text = "Chỉnh sửa sản phẩm #" + id;
                LoadProductData(int.Parse(id));
            }
        }

        if (fuHinhAnh.HasFile)
        {
            UploadImage();
        }
    }

    private void LoadCategories()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT MaDM, TenDM FROM dbo.DanhMuc WHERE TrangThai = 1";
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "TenDM";
            ddlCategory.DataValueField = "MaDM";
            ddlCategory.DataBind();
        }
    }

    private void LoadProductData(int id)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT * FROM dbo.SanPham WHERE MaSP = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                txtTenSP.Text = reader["TenSP"].ToString();
                txtTacGia.Text = reader["TacGia"].ToString();
                txtMoTa.Text = reader["MoTa"].ToString();
                txtGia.Text = Convert.ToDecimal(reader["Gia"]).ToString("N0").Replace(".", "");
                txtGiaKhuyenMai.Text = reader["GiaKhuyenMai"] != DBNull.Value ? Convert.ToDecimal(reader["GiaKhuyenMai"]).ToString("N0").Replace(".", "") : "";
                txtSoLuongTon.Text = reader["SoLuongTon"].ToString();
                txtHinhAnhUrl.Text = reader["HinhAnh"].ToString();
                txtLoaiBia.Text = reader["LoaiBia"].ToString();
                txtNhaXuatBan.Text = reader["NhaXuatBan"].ToString();
                txtNhaCungCap.Text = reader["NhaCungCap"].ToString();
                
                bool status = Convert.ToBoolean(reader["TrangThai"]);
                rbActive.Checked = status;
                rbInactive.Checked = !status;

                if (!string.IsNullOrEmpty(txtHinhAnhUrl.Text))
                {
                    imgPreview.ImageUrl = ToAdminImageUrl(txtHinhAnhUrl.Text);
                }
                
                ddlCategory.SelectedValue = reader["MaDM"].ToString();
            }
        }
    }

    private void UploadImage()
    {
        try
        {
            string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuHinhAnh.FileName);
            string ext = Path.GetExtension(fuHinhAnh.FileName).ToLowerInvariant();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
            {
                ShowError("Chỉ hỗ trợ ảnh JPG, PNG hoặc WebP.");
                return;
            }

            string folderPath = Server.MapPath("~/img/books/");
            if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);
            
            fuHinhAnh.SaveAs(Path.Combine(folderPath, fileName));
            txtHinhAnhUrl.Text = "img/books/" + fileName;
            imgPreview.ImageUrl = "~/img/books/" + fileName;
        }
        catch (Exception ex)
        {
            ShowError("Không thể tải ảnh lên. Vui lòng thử lại.");
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string id = Request.QueryString["id"];
        string connString = DbConfig.GetConnectionString();
        decimal gia;
        decimal giaKhuyenMai;
        int soLuongTon;

        if (string.IsNullOrWhiteSpace(txtTenSP.Text))
        {
            ShowError("Vui lòng nhập tên sách.");
            return;
        }

        if (!TryParseMoney(txtGia.Text, out gia) || gia <= 0)
        {
            ShowError("Giá bán chưa hợp lệ.");
            return;
        }

        bool hasSalePrice = !string.IsNullOrWhiteSpace(txtGiaKhuyenMai.Text);
        if (hasSalePrice && (!TryParseMoney(txtGiaKhuyenMai.Text, out giaKhuyenMai) || giaKhuyenMai <= 0 || giaKhuyenMai >= gia))
        {
            ShowError("Giá khuyến mãi phải lớn hơn 0 và nhỏ hơn giá bán.");
            return;
        }

        if (!int.TryParse(txtSoLuongTon.Text.Trim(), out soLuongTon) || soLuongTon < 0)
        {
            ShowError("Số lượng tồn chưa hợp lệ.");
            return;
        }

        int discountPercent = 0;
        object saleValue = DBNull.Value;
        object discountValue = DBNull.Value;
        if (hasSalePrice)
        {
            saleValue = giaKhuyenMai;
            discountPercent = (int)Math.Round((gia - giaKhuyenMai) * 100m / gia, 0);
            discountValue = discountPercent;
        }
        
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "";
            if (string.IsNullOrEmpty(id))
            {
                sql = @"INSERT INTO dbo.SanPham 
                        (TenSP, TacGia, MoTa, Gia, GiaKhuyenMai, PhanTramGiam, SoLuongTon, HinhAnh, LoaiBia, NhaXuatBan, NhaCungCap, MaDM, TrangThai)
                        VALUES (@TenSP, @TacGia, @MoTa, @Gia, @GiaKhuyenMai, @PhanTramGiam, @SoLuongTon, @HinhAnh, @LoaiBia, @NhaXuatBan, @NhaCungCap, @MaDM, @TrangThai)";
            }
            else
            {
                sql = @"UPDATE dbo.SanPham SET 
                        TenSP=@TenSP, TacGia=@TacGia, MoTa=@MoTa, Gia=@Gia, GiaKhuyenMai=@GiaKhuyenMai, PhanTramGiam=@PhanTramGiam,
                        SoLuongTon=@SoLuongTon, HinhAnh=@HinhAnh, LoaiBia=@LoaiBia, NhaXuatBan=@NhaXuatBan, 
                        NhaCungCap=@NhaCungCap, MaDM=@MaDM, TrangThai=@TrangThai 
                        WHERE MaSP=@Id";
            }

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@TenSP", txtTenSP.Text.Trim());
            cmd.Parameters.AddWithValue("@TacGia", txtTacGia.Text.Trim());
            cmd.Parameters.AddWithValue("@MoTa", txtMoTa.Text.Trim());
            cmd.Parameters.AddWithValue("@Gia", gia);
            cmd.Parameters.AddWithValue("@GiaKhuyenMai", saleValue);
            cmd.Parameters.AddWithValue("@PhanTramGiam", discountValue);
            cmd.Parameters.AddWithValue("@SoLuongTon", soLuongTon);
            cmd.Parameters.AddWithValue("@HinhAnh", txtHinhAnhUrl.Text.Trim());
            cmd.Parameters.AddWithValue("@LoaiBia", txtLoaiBia.Text.Trim());
            cmd.Parameters.AddWithValue("@NhaXuatBan", txtNhaXuatBan.Text.Trim());
            cmd.Parameters.AddWithValue("@NhaCungCap", txtNhaCungCap.Text.Trim());
            cmd.Parameters.AddWithValue("@MaDM", ddlCategory.SelectedValue);
            cmd.Parameters.AddWithValue("@TrangThai", rbActive.Checked);

            if (!string.IsNullOrEmpty(id))
            {
                cmd.Parameters.AddWithValue("@Id", int.Parse(id));
            }

            conn.Open();
            cmd.ExecuteNonQuery();
        }

        Response.Redirect("Products.aspx");
    }

    private bool TryParseMoney(string raw, out decimal value)
    {
        value = 0;
        if (string.IsNullOrWhiteSpace(raw))
        {
            return false;
        }

        string normalized = raw.Replace(".", "").Replace(",", "").Replace(" ", "").Trim();
        return decimal.TryParse(normalized, NumberStyles.Number, CultureInfo.InvariantCulture, out value);
    }

    private void ShowError(string message)
    {
        litError.Text = "<div class='mb-6 rounded-2xl border border-rose-500/40 bg-rose-500/10 p-4 text-sm font-bold text-rose-300'>" + HttpUtility.HtmlEncode(message) + "</div>";
    }

    private string ToAdminImageUrl(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return "https://placehold.co/400x550/f8f1e3/3b3028?text=Book";
        }

        if (value.StartsWith("http", StringComparison.OrdinalIgnoreCase) || value.StartsWith("/", StringComparison.OrdinalIgnoreCase) || value.StartsWith("~/", StringComparison.OrdinalIgnoreCase))
        {
            return value;
        }

        if (value.StartsWith("img/", StringComparison.OrdinalIgnoreCase))
        {
            return "../" + value;
        }

        return "../img/books/" + value;
    }
}
