using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_Coupons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadCoupons();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int percent;
        int quantity;
        if (string.IsNullOrWhiteSpace(txtCode.Text) || !int.TryParse(txtPercent.Text, out percent) || !int.TryParse(txtQuantity.Text, out quantity))
        {
            lblMessage.CssClass = "block text-sm text-rose-400";
            lblMessage.Text = "Vui lòng nhập đúng mã, phần trăm và số lượng.";
            return;
        }

        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand(@"
                IF EXISTS (SELECT 1 FROM dbo.KhuyenMai WHERE MaKM = @MaKM)
                    UPDATE dbo.KhuyenMai SET PhanTramGiam = @Percent, SoLuong = @Quantity WHERE MaKM = @MaKM
                ELSE
                    INSERT INTO dbo.KhuyenMai (MaKM, PhanTramGiam, SoLuong, GiaTriGiam, DieuKien) VALUES (@MaKM, @Percent, @Quantity, 0, 0)", conn);
            cmd.Parameters.AddWithValue("@MaKM", txtCode.Text.Trim().ToUpperInvariant());
            cmd.Parameters.AddWithValue("@Percent", Math.Max(0, Math.Min(100, percent)));
            cmd.Parameters.AddWithValue("@Quantity", Math.Max(0, quantity));
            conn.Open();
            cmd.ExecuteNonQuery();
        }

        lblMessage.CssClass = "block text-sm text-emerald-400";
        lblMessage.Text = "Đã lưu mã khuyến mãi.";
        LoadCoupons();
    }

    private void LoadCoupons()
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT MaKM, PhanTramGiam, SoLuong, DieuKien FROM dbo.KhuyenMai ORDER BY MaKM", conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptCoupons.DataSource = dt;
            rptCoupons.DataBind();
        }
    }
}
