<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ChiTietSach.aspx.cs" Inherits="BanSachTest.ChiTietSach" %>
<%@ Register src="UserUI/ChiTietSachCT.ascx" tagname="ChiTietSachCT" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:ChiTietSachCT ID="ChiTietSachCT1" runat="server" />
</asp:Content>
