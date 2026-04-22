using System;
using System.Collections.Generic;

// Lớp giả lập DTO tạm thời cho đến khi kết nối LINQ thực
public class SanPhamDTO
{
    public int MaSP { get; set; }
    public string TenSP { get; set; }
    public string TacGia { get; set; }
    public decimal Gia { get; set; }
    public string HinhAnh { get; set; }
}

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadTrangChu();
        }
    }

    private void LoadTrangChu()
    {
        // Fake data. Sẽ được thay thế bằng LINQ to SQL trong Phase tiếp theo
        // var db = new BanSachDataContext();
        // rptSachNoiBat.DataSource = db.SanPhams.Take(10).ToList();

        var danhSach = new List<SanPhamDTO>();
        Random rnd = new Random();
        
        string[] authors = { "Nam Cao", "Thạch Lam", "Paulo Coelho", "Fujiko F Fujio" };
        string[] imgPlaceholders = { "Lão+Hạc", "Hai+Đứa+Trẻ", "Nhà+Giả+Kim", "Doraemon" };

        for (int i = 1; i <= 15; i++)
        {
            int authorIdx = rnd.Next(authors.Length);
            danhSach.Add(new SanPhamDTO 
            { 
                MaSP = i, 
                TenSP = "Ấn bản đặc biệt kỷ niệm - Tập " + i, 
                TacGia = authors[authorIdx], 
                Gia = rnd.Next(40, 200) * 1000, 
                HinhAnh = "https://placehold.co/400x600/1C1917/FFF?text=" + imgPlaceholders[authorIdx] + "+" + i 
            });
        }

        if(danhSach.Count > 0){
            rptSachNoiBat.DataSource = danhSach;
            rptSachNoiBat.DataBind();
        } else {
            LabelNoData.Visible = true;
        }
    }
}
