using System;
using System.Collections.Generic;
using System.Linq;

public partial class ChiTiet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string id = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                LoadChiTiet(id);
            }
            else
            {
                // Mặc định load một sản phẩm mẫu nếu không có ID
                LoadChiTiet("1");
            }
        }
    }

    private void LoadChiTiet(string id)
    {
        // Giả lập dữ liệu từ CSDL (Sẽ thay bằng LINQ to SQL)
        // var db = new BanSachDataContext();
        // var sp = db.SanPhams.FirstOrDefault(s => s.MaSP.ToString() == id);

        // Demo Data
        var sampleData = new Dictionary<string, dynamic>
        {
            { "TenSP", "Dế Mèn Phiêu Lưu Ký (Ấn bản Premium)" },
            { "TacGia", "Tô Hoài" },
            { "Gia", 120000 },
            { "HinhAnh", "demen.png" },
            { "MoTa", "Phiên bản kỷ niệm đặc biệt với thiết kế bìa nhũ vàng trên nền vải Canvas xanh thẫm. Câu chuyện về chú Dế Mèn kiêu căng, bồng bột đã trải qua bao sóng gió để trưởng thành, nay được tái hiện trong một diện mạo đẳng cấp quốc tế." }
        };

        litTenSP.Text = sampleData["TenSP"];
        litTacGia.Text = sampleData["TacGia"];
        litGia.Text = string.Format("{0:N0}đ", sampleData["Gia"]);
        litMoTa.Text = sampleData["MoTa"];
        litBreadcrumb.Text = sampleData["TenSP"];
        
        // Cập nhật text cho bìa sách 3D
        litTitleCover.Text = sampleData["TenSP"];
        litTitleCoverShine.Text = sampleData["TenSP"];
        
        // Cập nhật ảnh cho hiệu ứng 3D
        bookFront.Style["background-image"] = "url('img/books/" + sampleData["HinhAnh"] + "')";
    }
}
