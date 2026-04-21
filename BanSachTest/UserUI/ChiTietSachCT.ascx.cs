using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BanSachTest.UserUI
{
    public partial class ChiTietSachCT : System.Web.UI.UserControl
    {
        QuanLySachDataContext db = new QuanLySachDataContext();
        public static SANPHAM infoSach = new SANPHAM();
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadData();
        }
        
        //Ham xu ly load Sach theo Id da chon
        void LoadData()
        {
            long idSachSelect;
            if (!long.TryParse(Request.QueryString["IdSach"], out idSachSelect))
            {
                return;
            }

            var data = from q in db.SANPHAMs
                       where q.IdSanPham == idSachSelect
                       select q;

            if (data != null && data.Count() > 0)
            {
                infoSach = data.First();
            }
        }
    }
}
