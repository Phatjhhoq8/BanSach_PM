using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BanSachTest
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        QuanLySachDataContext db = new QuanLySachDataContext();
        public static List<DANHMUCSP> listDM = new List<DANHMUCSP>();
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        void LoadData()
        {
            var data = from q in db.DANHMUCSPs
                       where q.HienThi == 1
                       orderby q.ViTri ascending
                       select q;

            if (data != null && data.Count() > 0)
            {
                listDM = data.ToList();
            }
        }
    }
}