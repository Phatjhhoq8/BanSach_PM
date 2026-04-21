<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="DanhMucSanPham.aspx.cs" Inherits="BanSachTest.DanhMucSanPham" %>
<%@ Register src="UserUI/DanhMucSanPhamCT.ascx" tagname="DanhMucSanPhamCT" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:DanhMucSanPhamCT ID="DanhMucSanPhamCT1" runat="server" />
</asp:Content>
