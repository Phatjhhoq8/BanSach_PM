using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

public partial class Orders : System.Web.UI.Page
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
            LoadOrders();
        }
    }

    private void LoadOrders()
    {
        int userId = (int)Session["UserId"];
        string connString = DbConfig.GetConnectionString();

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT dh.MaDH, dh.NgayDat, dh.TongTien, dh.TrangThai, 
                       ct.MaSP, ct.SoLuong, ct.DonGia, sp.TenSP,
                       CASE
                           WHEN sp.HinhAnh IS NULL OR LTRIM(RTRIM(sp.HinhAnh)) = '' THEN 'https://placehold.co/400x550/f8f1e3/3b3028?text=Book'
                           WHEN sp.HinhAnh LIKE 'http%' OR sp.HinhAnh LIKE 'img/%' OR sp.HinhAnh LIKE '/%' THEN sp.HinhAnh
                           ELSE 'img/books/' + sp.HinhAnh
                       END AS HinhAnh
                FROM dbo.DonHang dh
                JOIN dbo.ChiTietDonHang ct ON dh.MaDH = ct.MaDH
                JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
                WHERE dh.MaKH = @UID
                ORDER BY dh.MaDH DESC";
            
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            da.SelectCommand.Parameters.AddWithValue("@UID", userId);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                var orders = dt.AsEnumerable()
                    .GroupBy(r => new {
                        MaDH = r.Field<int>("MaDH"),
                        NgayDat = r.Field<DateTime>("NgayDat"),
                        TongTien = r.Field<decimal>("TongTien"),
                        TrangThai = r.Field<int>("TrangThai")
                    })
                    .Select(g => new {
                        MaDH = g.Key.MaDH,
                        NgayDat = g.Key.NgayDat,
                        TongTien = g.Key.TongTien,
                        TrangThai = g.Key.TrangThai,
                        Details = g.Select(r => new {
                            TenSP = r.Field<string>("TenSP"),
                            HinhAnh = r.Field<string>("HinhAnh"),
                            SoLuong = r.Field<int>("SoLuong"),
                            DonGia = r.Field<decimal>("DonGia")
                        }).ToList()
                    }).ToList();

                rptOrders.DataSource = orders;
                rptOrders.DataBind();
                phNoOrders.Visible = false;
            }
            else
            {
                phNoOrders.Visible = true;
            }
        }
    }

    protected string GetStatusText(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "Chờ xác nhận";
            case 1: return "Đang xử lý";
            case 2: return "Đang giao hàng";
            case 3: return "Hoàn thành";
            case 4: return "Đã hủy";
            default: return "Không xác định";
        }
    }

    protected string GetStatusClass(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "bg-blue-100 text-blue-600";
            case 1: return "bg-blue-100 text-blue-600";
            case 2: return "bg-sky-100 text-sky-600";
            case 3: return "bg-emerald-100 text-emerald-600";
            case 4: return "bg-rose-100 text-rose-600";
            default: return "bg-gray-100 text-gray-600";
        }
    }
}
