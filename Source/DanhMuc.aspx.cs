using System;
using System.Collections.Generic;

public partial class DanhMuc : System.Web.UI.Page
{
    public string VideoBgUrl { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDanhMuc();
        }
    }

    private void LoadDanhMuc()
    {
        string tl = Request.QueryString["tl"];
        
        // Logic switch background video
        if (!string.IsNullOrEmpty(tl) && (tl.ToLower() == "truyentranh" || tl.ToLower() == "hoathinh"))
        {
            // Thể loại truyện tranh / hoạt hình thì dùng cartoon
            VideoBgUrl = "videos/cartoon.mp4";
            litTitle.Text = "Truyện Tranh Ký Tức";
        }
        else
        {
            // Còn lại dùng book.mp4
            VideoBgUrl = "videos/book.mp4";
            
            if(tl == "kinhte") litTitle.Text = "Kinh Tế Kinh Doanh";
            else if (tl == "kynang") litTitle.Text = "Kỹ Năng Sống";
            else litTitle.Text = "Tất Cả Tác Phẩm";
        }

        // Fake Data Load - Khởi tạo lượng dữ liệu cực lớn để mường tượng hệ thống thực tế
        var danhSach = new List<SanPhamDTO>();
        Random rnd = new Random();
        
        string[] authors = { "Nguyễn Nhật Ánh", "Tô Hoài", "Eiichiro Oda", "Naoki Urasawa", "Dale Carnegie", "Haruki Murakami" };
        string[] imgPlaceholders = { "Dế+Mèn", "Kính+Vạn+Hoa", "One+Piece", "Đắc+Nhân+Tâm", "Sách+Giáo+Khoa", "Monster" };

        for (int i = 1; i <= 50; i++)
        {
            int authorIdx = rnd.Next(authors.Length);
            
            danhSach.Add(new SanPhamDTO 
            { 
                MaSP = i, 
                TenSP = "Tuyệt phẩm Tri thức " + (tl == "truyentranh" ? "Graphic Novel" : "Văn Học") + " - Quyển thứ " + i, 
                TacGia = authors[authorIdx], 
                Gia = rnd.Next(35, 150) * 1000, 
                HinhAnh = "https://placehold.co/400x600/1C1917/FFF?text=" + imgPlaceholders[authorIdx] + "+" + i 
            });
        }

        if (danhSach.Count > 0)
        {
            rptSach.DataSource = danhSach;
            rptSach.DataBind();
        }
        else
        {
            LabelNoData.Visible = true;
        }
    }
}
