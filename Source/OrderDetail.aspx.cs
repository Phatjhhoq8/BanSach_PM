using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

public partial class OrderDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=OrderDetail.aspx?id=" + Request.QueryString["id"]);
            return;
        }

        if (!IsPostBack)
        {
            LoadOrder();
        }
    }

    private void LoadOrder()
    {
        int orderId;
        if (!int.TryParse(Request.QueryString["id"], out orderId))
        {
            ShowNotFound();
            return;
        }

        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            SqlCommand orderCmd = new SqlCommand(@"
                SELECT MaDH, NgayDat, TongTien, DiaChiGiaoHang, SoDienThoaiGiao, GhiChu, TrangThai, HinhThucThanhToan
                FROM dbo.DonHang
                WHERE MaDH = @MaDH AND MaKH = @MaKH", conn);
            orderCmd.Parameters.AddWithValue("@MaDH", orderId);
            orderCmd.Parameters.AddWithValue("@MaKH", (int)Session["UserId"]);

            using (SqlDataReader reader = orderCmd.ExecuteReader())
            {
                if (!reader.Read())
                {
                    ShowNotFound();
                    return;
                }

                litOrderId.Text = reader["MaDH"].ToString();
                litStatus.Text = GetStatusText(Convert.ToInt32(reader["TrangThai"]));
                litDate.Text = Convert.ToDateTime(reader["NgayDat"]).ToString("dd/MM/yyyy HH:mm");
                litAddress.Text = reader["DiaChiGiaoHang"] == DBNull.Value ? "Chưa có" : reader["DiaChiGiaoHang"].ToString();
                litPhone.Text = reader["SoDienThoaiGiao"] == DBNull.Value ? "Chưa có" : reader["SoDienThoaiGiao"].ToString();
                litPayment.Text = reader["HinhThucThanhToan"].ToString();
                litTotal.Text = Convert.ToDecimal(reader["TongTien"]).ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
            }

            SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT sp.TenSP, sp.HinhAnh, ctdh.SoLuong, ctdh.DonGia, ctdh.SoLuong * ctdh.DonGia AS ThanhTien
                FROM dbo.ChiTietDonHang ctdh
                JOIN dbo.SanPham sp ON sp.MaSP = ctdh.MaSP
                WHERE ctdh.MaDH = @MaDH", conn);
            da.SelectCommand.Parameters.AddWithValue("@MaDH", orderId);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptItems.DataSource = dt;
            rptItems.DataBind();
        }

        phContent.Visible = true;
        phNotFound.Visible = false;
    }

    private void ShowNotFound()
    {
        phContent.Visible = false;
        phNotFound.Visible = true;
    }

    private string GetStatusText(int status)
    {
        switch (status)
        {
            case 0: return "Chờ xác nhận";
            case 1: return "Đang đóng gói";
            case 2: return "Đang giao";
            case 3: return "Hoàn thành";
            case 4: return "Đã hủy";
            default: return "Không xác định";
        }
    }
}
