using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;

public partial class Admin_Faq : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadFaq();
    }

    private void LoadFaq()
    {
        DatabaseInitializer.EnsureInitialized();
        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT MaFAQ, CauHoi, TraLoi, Nhom, ThuTu, TrangThai FROM dbo.FAQ ORDER BY ThuTu, MaFAQ", conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptFaq.DataSource = dt;
            rptFaq.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int order;
        if (string.IsNullOrWhiteSpace(txtQuestion.Text) || string.IsNullOrWhiteSpace(txtAnswer.Text))
        {
            ShowMessage("Vui lòng nhập câu hỏi và câu trả lời.", false);
            return;
        }
        if (!int.TryParse(txtOrder.Text.Trim(), out order)) order = 0;

        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            string sql = string.IsNullOrWhiteSpace(hdnId.Value)
                ? "INSERT INTO dbo.FAQ (CauHoi, TraLoi, Nhom, ThuTu, TrangThai) VALUES (@Q, @A, @Group, @Order, @Active)"
                : "UPDATE dbo.FAQ SET CauHoi=@Q, TraLoi=@A, Nhom=@Group, ThuTu=@Order, TrangThai=@Active WHERE MaFAQ=@Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Q", txtQuestion.Text.Trim());
            cmd.Parameters.AddWithValue("@A", txtAnswer.Text.Trim());
            cmd.Parameters.AddWithValue("@Group", txtGroup.Text.Trim());
            cmd.Parameters.AddWithValue("@Order", order);
            cmd.Parameters.AddWithValue("@Active", chkActive.Checked);
            if (!string.IsNullOrWhiteSpace(hdnId.Value)) cmd.Parameters.AddWithValue("@Id", hdnId.Value);
            conn.Open();
            cmd.ExecuteNonQuery();
        }

        ResetForm();
        LoadFaq();
        ShowMessage("Đã lưu FAQ.", true);
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        string id = ((LinkButton)sender).CommandArgument;
        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.FAQ WHERE MaFAQ=@Id", conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                hdnId.Value = id;
                txtQuestion.Text = reader["CauHoi"].ToString();
                txtAnswer.Text = reader["TraLoi"].ToString();
                txtGroup.Text = reader["Nhom"].ToString();
                txtOrder.Text = reader["ThuTu"].ToString();
                chkActive.Checked = Convert.ToBoolean(reader["TrangThai"]);
                litFormTitle.Text = "Chỉnh sửa FAQ #" + id;
            }
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        string id = ((LinkButton)sender).CommandArgument;
        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            SqlCommand cmd = new SqlCommand("DELETE FROM dbo.FAQ WHERE MaFAQ=@Id", conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
        LoadFaq();
    }

    protected void btnCancel_Click(object sender, EventArgs e) { ResetForm(); }

    private void ResetForm()
    {
        hdnId.Value = string.Empty;
        txtQuestion.Text = string.Empty;
        txtAnswer.Text = string.Empty;
        txtGroup.Text = string.Empty;
        txtOrder.Text = "0";
        chkActive.Checked = true;
        litFormTitle.Text = "Thêm FAQ";
    }

    private void ShowMessage(string message, bool success)
    {
        litMessage.Text = "<p class='mb-4 text-sm font-bold " + (success ? "text-emerald-400" : "text-rose-400") + "'>" + HttpUtility.HtmlEncode(message) + "</p>";
    }
}
