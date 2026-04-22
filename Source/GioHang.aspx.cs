using System;
using System.Collections.Generic;

public partial class GioHang : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCart();
        }
    }

    private void LoadCart()
    {
        // Fake logic:
        // var db = new BanSachDataContext();
        // int maKH = 1; // get from Session
        // var items = db.ChiTietGioHangs.Where(x => x.MaKH == maKH).Select(x => new { x.SanPham.TenSP, x.SanPham.HinhAnh, x.SoLuong, x.SanPham.Gia }).ToList();

        var danhSach = new List<SanPhamDTO>
        {
            new SanPhamDTO { MaSP = 1, TenSP = "Dế Mèn Phiêu Lưu Ký", Gia = 45000, HinhAnh = "demen.jpg" },
            new SanPhamDTO { MaSP = 4, TenSP = "Clean Code", Gia = 450000, HinhAnh = "cleancode.jpg" }
        };

        if(danhSach.Count > 0){
            rptCart.DataSource = danhSach;
            rptCart.DataBind();
            
            decimal tong = 0;
            foreach(var item in danhSach) tong += item.Gia;
            lblSubTotal.Text = string.Format("{0:N0} đ", tong);
            lblTotal.Text = string.Format("{0:N0} đ", tong);
        } else {
            lblCartEmpty.Visible = true;
            btnCheckout.Enabled = false;
        }
    }

    protected void btnCheckout_Click(object sender, EventArgs e)
    {
        // Xử lý chuyển dữ liệu từ Giỏ Hàng -> Đơn Hàng trong DB
        // foreach(item in Cart) insert into ChiTietDonHang 
        // Sau đó hiển thị thông báo
        Response.Write("<script>alert('Đặt hàng thành công! Mã đơn của bạn là DH001.');</script>");
    }
}
