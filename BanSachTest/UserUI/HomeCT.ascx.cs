using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BanSachTest.UserUI
{
    public partial class HomeCT : System.Web.UI.UserControl
    {
        QuanLySachDataContext db = new QuanLySachDataContext();
        public static List<SANPHAM> listSPXuHuong = new List<SANPHAM>();
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        void LoadData()
        {
            var data = from q in db.SANPHAMs
                       where q.XuHuong == 1
                       select q;

            if(data!=null && data.Count()>0)
            {
                listSPXuHuong = data.ToList();
            }
        }
    }
}