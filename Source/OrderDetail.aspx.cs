using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

public partial class OrderDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=Orders.aspx");
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
        if (!int.TryParse(Request.QueryString["id"], out orderId) || orderId <= 0)
        {
            Response.Redirect("~/Orders.aspx");
            return;
        }

        int userId = (int)Session["UserId"];
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT MaDH, NgayDat, TamTinh, PhiVanChuyen, GiamGia, TongTien, MaKM, DiaChiGiaoHang, SoDienThoaiGiao, GhiChu, TrangThai, HinhThucThanhToan
                FROM dbo.DonHang
                WHERE MaDH = @OrderId AND MaKH = @UserId", conn);
            cmd.Parameters.AddWithValue("@OrderId", orderId);
            cmd.Parameters.AddWithValue("@UserId", userId);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (!reader.Read())
                {
                    Response.Redirect("~/Orders.aspx");
                    return;
                }

                litOrderId.Text = orderId.ToString();
                litDate.Text = Convert.ToDateTime(reader["NgayDat"]).ToString("dd/MM/yyyy HH:mm");
                decimal subtotal = Convert.ToDecimal(reader["TamTinh"]);
                decimal shippingFee = Convert.ToDecimal(reader["PhiVanChuyen"]);
                decimal discount = Convert.ToDecimal(reader["GiamGia"]);
                decimal total = Convert.ToDecimal(reader["TongTien"]);

                litSubtotal.Text = FormatCurrency(subtotal);
                litShippingFee.Text = FormatCurrency(shippingFee);
                litDiscount.Text = discount > 0 ? "-" + FormatCurrency(discount) : "0đ";
                litCoupon.Text = reader["MaKM"] == DBNull.Value ? "Không áp dụng" : HttpUtility.HtmlEncode(reader["MaKM"].ToString());
                litTotal.Text = FormatCurrency(total);
                litPayment.Text = HttpUtility.HtmlEncode(reader["HinhThucThanhToan"].ToString());
                litShippingInfo.Text = HttpUtility.HtmlEncode(reader["DiaChiGiaoHang"].ToString()) + "<br/>" + HttpUtility.HtmlEncode(reader["SoDienThoaiGiao"].ToString());

                int status = Convert.ToInt32(reader["TrangThai"]);
                litStatus.Text = GetStatusText(status);
                statusPill.Attributes["class"] = "status-pill " + GetStatusClass(status);
            }

            SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT ct.MaSP, sp.TenSP,
                       CASE
                           WHEN sp.HinhAnh IS NULL OR LTRIM(RTRIM(sp.HinhAnh)) = '' THEN 'https://placehold.co/400x550/f8f1e3/3b3028?text=Book'
                           WHEN sp.HinhAnh LIKE 'http%' OR sp.HinhAnh LIKE 'img/%' OR sp.HinhAnh LIKE '/%' THEN sp.HinhAnh
                           ELSE 'img/books/' + sp.HinhAnh
                       END AS HinhAnh,
                       ct.SoLuong, ct.DonGia, ct.SoLuong * ct.DonGia AS ThanhTien
                FROM dbo.ChiTietDonHang ct
                JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
                WHERE ct.MaDH = @OrderId", conn);
            da.SelectCommand.Parameters.AddWithValue("@OrderId", orderId);
            DataTable items = new DataTable();
            da.Fill(items);
            rptItems.DataSource = items;
            rptItems.DataBind();
        }
    }

    private string GetStatusText(int status)
    {
        switch (status)
        {
            case 0: return "Chờ xác nhận";
            case 1: return "Đang xử lý";
            case 2: return "Đang giao hàng";
            case 3: return "Hoàn thành";
            case 4: return "Đã hủy";
            default: return "Không xác định";
        }
    }

    private string GetStatusClass(int status)
    {
        switch (status)
        {
            case 0: return "bg-amber-100 text-amber-700";
            case 1: return "bg-blue-100 text-blue-700";
            case 2: return "bg-purple-100 text-purple-700";
            case 3: return "bg-emerald-100 text-emerald-700";
            case 4: return "bg-red-100 text-red-700";
            default: return "bg-stone-100 text-stone-700";
        }
    }

    private string FormatCurrency(decimal value)
    {
        return value.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
    }
}
