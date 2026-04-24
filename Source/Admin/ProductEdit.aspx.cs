using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
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
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
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
                    imgPreview.ImageUrl = txtHinhAnhUrl.Text;
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
            string folderPath = Server.MapPath("~/img/books/");
            if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);
            
            fuHinhAnh.SaveAs(Path.Combine(folderPath, fileName));
            txtHinhAnhUrl.Text = "img/books/" + fileName;
            imgPreview.ImageUrl = "~/img/books/" + fileName;
        }
        catch (Exception ex)
        {
            // Handle error
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string id = Request.QueryString["id"];
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "";
            if (string.IsNullOrEmpty(id))
            {
                sql = @"INSERT INTO dbo.SanPham 
                        (TenSP, TacGia, MoTa, Gia, GiaKhuyenMai, SoLuongTon, HinhAnh, LoaiBia, NhaXuatBan, NhaCungCap, MaDM, TrangThai) 
                        VALUES (@TenSP, @TacGia, @MoTa, @Gia, @GiaKhuyenMai, @SoLuongTon, @HinhAnh, @LoaiBia, @NhaXuatBan, @NhaCungCap, @MaDM, @TrangThai)";
            }
            else
            {
                sql = @"UPDATE dbo.SanPham SET 
                        TenSP=@TenSP, TacGia=@TacGia, MoTa=@MoTa, Gia=@Gia, GiaKhuyenMai=@GiaKhuyenMai, 
                        SoLuongTon=@SoLuongTon, HinhAnh=@HinhAnh, LoaiBia=@LoaiBia, NhaXuatBan=@NhaXuatBan, 
                        NhaCungCap=@NhaCungCap, MaDM=@MaDM, TrangThai=@TrangThai 
                        WHERE MaSP=@Id";
            }

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@TenSP", txtTenSP.Text.Trim());
            cmd.Parameters.AddWithValue("@TacGia", txtTacGia.Text.Trim());
            cmd.Parameters.AddWithValue("@MoTa", txtMoTa.Text.Trim());
            cmd.Parameters.AddWithValue("@Gia", decimal.Parse(txtGia.Text.Replace(",", "")));
            cmd.Parameters.AddWithValue("@GiaKhuyenMai", string.IsNullOrEmpty(txtGiaKhuyenMai.Text) ? (object)DBNull.Value : decimal.Parse(txtGiaKhuyenMai.Text.Replace(",", "")));
            cmd.Parameters.AddWithValue("@SoLuongTon", int.Parse(txtSoLuongTon.Text));
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
}
