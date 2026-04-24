using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI.WebControls;

public partial class Admin_Coupons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCoupons();
        }
    }

    private void LoadCoupons()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT MaKM, PhanTramGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, SoLuong, DieuKien FROM dbo.KhuyenMai ORDER BY NgayKetThuc DESC, MaKM", conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptCoupons.DataSource = dt;
            rptCoupons.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string code = txtCode.Text.Trim().ToUpperInvariant();
        int percent;
        int quantity;
        int days;
        decimal amount;
        decimal condition;

        if (string.IsNullOrWhiteSpace(code))
        {
            ShowMessage("Vui lòng nhập mã ưu đãi.", false);
            return;
        }

        if (!int.TryParse(txtPercent.Text.Trim(), out percent) || percent < 0 || percent > 100)
        {
            ShowMessage("% giảm phải nằm trong khoảng 0-100.", false);
            return;
        }

        if (!TryParseMoney(txtAmount.Text, out amount) || amount < 0)
        {
            ShowMessage("Giá trị giảm tiền chưa hợp lệ.", false);
            return;
        }

        if (!int.TryParse(txtQuantity.Text.Trim(), out quantity) || quantity < 0)
        {
            ShowMessage("Số lượng mã chưa hợp lệ.", false);
            return;
        }

        if (!TryParseMoney(txtCondition.Text, out condition) || condition < 0)
        {
            ShowMessage("Điều kiện đơn hàng chưa hợp lệ.", false);
            return;
        }

        if (!int.TryParse(txtDays.Text.Trim(), out days) || days <= 0)
        {
            days = 30;
        }

        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            string oldCode = hdnOldCode.Value;
            string sql;
            if (string.IsNullOrWhiteSpace(oldCode))
            {
                sql = @"INSERT INTO dbo.KhuyenMai (MaKM, PhanTramGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, SoLuong, DieuKien)
                        VALUES (@Code, @Percent, @Amount, GETDATE(), DATEADD(DAY, @Days, GETDATE()), @Quantity, @Condition)";
            }
            else
            {
                sql = @"UPDATE dbo.KhuyenMai SET MaKM=@Code, PhanTramGiam=@Percent, GiaTriGiam=@Amount, NgayKetThuc=DATEADD(DAY, @Days, GETDATE()), SoLuong=@Quantity, DieuKien=@Condition WHERE MaKM=@OldCode";
            }

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Code", code);
            cmd.Parameters.AddWithValue("@OldCode", oldCode);
            cmd.Parameters.AddWithValue("@Percent", percent);
            cmd.Parameters.AddWithValue("@Amount", amount);
            cmd.Parameters.AddWithValue("@Days", days);
            cmd.Parameters.AddWithValue("@Quantity", quantity);
            cmd.Parameters.AddWithValue("@Condition", condition);

            try
            {
                cmd.ExecuteNonQuery();
                ResetForm();
                LoadCoupons();
                ShowMessage("Đã lưu mã ưu đãi.", true);
            }
            catch
            {
                ShowMessage("Không thể lưu mã. Có thể mã đã tồn tại hoặc đang được đơn hàng sử dụng.", false);
            }
        }
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        string code = ((LinkButton)sender).CommandArgument;
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.KhuyenMai WHERE MaKM = @Code", conn);
            cmd.Parameters.AddWithValue("@Code", code);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                hdnOldCode.Value = reader["MaKM"].ToString();
                txtCode.Text = reader["MaKM"].ToString();
                txtPercent.Text = reader["PhanTramGiam"].ToString();
                txtAmount.Text = Convert.ToDecimal(reader["GiaTriGiam"]).ToString("N0", CultureInfo.GetCultureInfo("vi-VN"));
                txtQuantity.Text = reader["SoLuong"].ToString();
                txtCondition.Text = Convert.ToDecimal(reader["DieuKien"]).ToString("N0", CultureInfo.GetCultureInfo("vi-VN"));
                txtDays.Text = "30";
                litFormTitle.Text = "Chỉnh sửa mã " + HttpUtility.HtmlEncode(code);
            }
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        string code = ((LinkButton)sender).CommandArgument;
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand("DELETE FROM dbo.KhuyenMai WHERE MaKM = @Code", conn);
            cmd.Parameters.AddWithValue("@Code", code);
            conn.Open();
            try
            {
                cmd.ExecuteNonQuery();
                LoadCoupons();
                ShowMessage("Đã xóa mã ưu đãi.", true);
            }
            catch
            {
                ShowMessage("Không thể xóa mã đã được sử dụng trong đơn hàng.", false);
            }
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void ResetForm()
    {
        hdnOldCode.Value = string.Empty;
        txtCode.Text = string.Empty;
        txtPercent.Text = "0";
        txtAmount.Text = "0";
        txtQuantity.Text = "100";
        txtCondition.Text = "0";
        txtDays.Text = "30";
        litFormTitle.Text = "Thêm mã ưu đãi";
    }

    private bool TryParseMoney(string raw, out decimal value)
    {
        value = 0;
        if (string.IsNullOrWhiteSpace(raw)) return false;
        string normalized = raw.Replace(".", "").Replace(",", "").Replace(" ", "").Trim();
        return decimal.TryParse(normalized, NumberStyles.Number, CultureInfo.InvariantCulture, out value);
    }

    private void ShowMessage(string message, bool success)
    {
        string cls = success ? "text-emerald-400" : "text-rose-400";
        litMessage.Text = "<p class='mt-4 text-sm font-bold " + cls + "'>" + HttpUtility.HtmlEncode(message) + "</p>";
    }
}
