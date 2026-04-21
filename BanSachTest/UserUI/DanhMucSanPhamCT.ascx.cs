using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BanSachTest.UserUI
{
    public partial class DanhMucSanPhamCT : System.Web.UI.UserControl
    {
        QuanLySachDataContext db = new QuanLySachDataContext();
        public static List<SANPHAM> listSPDM = new List<SANPHAM>();
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        void LoadData()
        {
            long idDM;
            if (!long.TryParse(Request.QueryString["IdDanhMuc"], out idDM))
            {
                return;
            }

            var data = from q in db.SANPHAMs
                       where q.IdDanhMucSach == idDM
                       select q;

            if (data != null && data.Count() > 0)
            {
                listSPDM = data.ToList();
            }

            var dataDM = from q in db.DANHMUCSPs
                         where q.IdDanhMuc == idDM
                         select q;

            if (dataDM != null && dataDM.Count() > 0)
            {
                lblTenDanhMuc.Text = dataDM.First().TenDanhMuc;
            }
        }
    }
}
