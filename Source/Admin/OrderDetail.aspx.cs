using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

public partial class Admin_OrderDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadOrder();
    }

    private void LoadOrder()
    {
        int orderId;
        if (!int.TryParse(Request.QueryString["id"], out orderId)) { ShowNotFound(); return; }
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT dh.MaDH, dh.NgayDat, dh.TongTien, dh.DiaChiGiaoHang, dh.SoDienThoaiGiao, dh.TrangThai, kh.HoTen, kh.Email
                FROM dbo.DonHang dh JOIN dbo.KhachHang kh ON kh.MaKH = dh.MaKH
                WHERE dh.MaDH = @MaDH", conn);
            cmd.Parameters.AddWithValue("@MaDH", orderId);
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (!reader.Read()) { ShowNotFound(); return; }
                litOrderId.Text = reader["MaDH"].ToString();
                litCustomer.Text = reader["HoTen"] + "<br><span class='text-slate-500'>" + reader["Email"] + "</span>";
                litDate.Text = Convert.ToDateTime(reader["NgayDat"]).ToString("dd/MM/yyyy HH:mm");
                litStatus.Text = GetStatusText(Convert.ToInt32(reader["TrangThai"]));
                litAddress.Text = reader["DiaChiGiaoHang"] == DBNull.Value ? "Chưa có" : reader["DiaChiGiaoHang"].ToString();
                litPhone.Text = reader["SoDienThoaiGiao"] == DBNull.Value ? "Chưa có" : reader["SoDienThoaiGiao"].ToString();
                litTotal.Text = Convert.ToDecimal(reader["TongTien"]).ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
            }
            SqlDataAdapter da = new SqlDataAdapter(@"SELECT sp.TenSP, sp.HinhAnh, ct.SoLuong, ct.DonGia, ct.SoLuong * ct.DonGia AS ThanhTien FROM dbo.ChiTietDonHang ct JOIN dbo.SanPham sp ON sp.MaSP = ct.MaSP WHERE ct.MaDH = @MaDH", conn);
            da.SelectCommand.Parameters.AddWithValue("@MaDH", orderId);
            DataTable dt = new DataTable(); da.Fill(dt); rptItems.DataSource = dt; rptItems.DataBind();
        }
        phContent.Visible = true; phNotFound.Visible = false;
    }

    private void ShowNotFound() { phContent.Visible = false; phNotFound.Visible = true; }
    private string GetStatusText(int s) { switch (s) { case 0: return "Chờ xác nhận"; case 1: return "Đang đóng gói"; case 2: return "Đang giao"; case 3: return "Hoàn thành"; case 4: return "Đã hủy"; default: return "Không xác định"; } }
}
