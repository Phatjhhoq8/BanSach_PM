using System;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

public partial class Admin_Settings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadSettings();
    }

    private void LoadSettings()
    {
        txtStoreName.Text = DatabaseInitializer.GetSetting("StoreName", "Premium Books");
        txtHotline.Text = DatabaseInitializer.GetSetting("Hotline", "1900 123456");
        txtEmail.Text = DatabaseInitializer.GetSetting("SupportEmail", "cskh@premiumbooks.vn");
        txtAddress.Text = DatabaseInitializer.GetSetting("StoreAddress", "");
        txtShippingFee.Text = DatabaseInitializer.GetDecimalSetting("ShippingFee", 30000m).ToString("N0", CultureInfo.GetCultureInfo("vi-VN"));
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        decimal shipping;
        string normalizedShipping = txtShippingFee.Text.Replace(".", "").Replace(",", "").Replace(" ", "").Trim();
        if (!decimal.TryParse(normalizedShipping, NumberStyles.Number, CultureInfo.InvariantCulture, out shipping) || shipping < 0)
        {
            ShowMessage("Phí vận chuyển chưa hợp lệ.", false);
            return;
        }

        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            conn.Open();
            SaveSetting(conn, "StoreName", txtStoreName.Text.Trim(), "Tên cửa hàng hiển thị");
            SaveSetting(conn, "Hotline", txtHotline.Text.Trim(), "Hotline hỗ trợ");
            SaveSetting(conn, "SupportEmail", txtEmail.Text.Trim(), "Email hỗ trợ khách hàng");
            SaveSetting(conn, "StoreAddress", txtAddress.Text.Trim(), "Địa chỉ cửa hàng");
            SaveSetting(conn, "ShippingFee", shipping.ToString(CultureInfo.InvariantCulture), "Phí vận chuyển mặc định");
        }

        LoadSettings();
        ShowMessage("Đã lưu cấu hình hệ thống.", true);
    }

    private void SaveSetting(SqlConnection conn, string key, string value, string description)
    {
        SqlCommand cmd = new SqlCommand(@"
            IF EXISTS (SELECT 1 FROM dbo.CaiDat WHERE [Key] = @Key)
                UPDATE dbo.CaiDat SET [Value] = @Value, MoTa = @Description WHERE [Key] = @Key
            ELSE
                INSERT INTO dbo.CaiDat ([Key], [Value], MoTa) VALUES (@Key, @Value, @Description)", conn);
        cmd.Parameters.AddWithValue("@Key", key);
        cmd.Parameters.AddWithValue("@Value", value);
        cmd.Parameters.AddWithValue("@Description", description);
        cmd.ExecuteNonQuery();
    }

    private void ShowMessage(string message, bool success)
    {
        litMessage.Text = "<p class='mb-4 text-sm font-bold " + (success ? "text-emerald-400" : "text-rose-400") + "'>" + HttpUtility.HtmlEncode(message) + "</p>";
    }
}
