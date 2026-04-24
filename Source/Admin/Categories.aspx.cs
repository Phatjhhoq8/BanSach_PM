using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Admin_Categories : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategories();
        }
    }

    private void LoadCategories()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT MaDM, TenDM, TrangThai FROM dbo.DanhMuc ORDER BY MaDM DESC";
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "";
            if (string.IsNullOrEmpty(hdnMaDM.Value))
            {
                sql = "INSERT INTO dbo.DanhMuc (TenDM, TrangThai) VALUES (@Ten, @Status)";
            }
            else
            {
                sql = "UPDATE dbo.DanhMuc SET TenDM = @Ten, TrangThai = @Status WHERE MaDM = @Id";
            }

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Ten", txtTenDM.Text.Trim());
            cmd.Parameters.AddWithValue("@Status", chkTrangThai.Checked);
            if (!string.IsNullOrEmpty(hdnMaDM.Value))
            {
                cmd.Parameters.AddWithValue("@Id", hdnMaDM.Value);
            }

            conn.Open();
            cmd.ExecuteNonQuery();
        }
        ResetForm();
        LoadCategories();
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
        LoadCategoryToForm(id);
    }

    private void LoadCategoryToForm(int id)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT * FROM dbo.DanhMuc WHERE MaDM = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                hdnMaDM.Value = reader["MaDM"].ToString();
                txtTenDM.Text = reader["TenDM"].ToString();
                chkTrangThai.Checked = Convert.ToBoolean(reader["TrangThai"]);
                litFormTitle.Text = "Chỉnh sửa danh mục #" + id;
                btnSave.Text = "Cập nhật";
            }
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
        DeleteCategory(id);
        LoadCategories();
    }

    private void DeleteCategory(int id)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "UPDATE dbo.DanhMuc SET TrangThai = 0 WHERE MaDM = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void ResetForm()
    {
        hdnMaDM.Value = "";
        txtTenDM.Text = "";
        chkTrangThai.Checked = true;
        litFormTitle.Text = "Thêm danh mục mới";
        btnSave.Text = "Lưu lại";
    }
}
