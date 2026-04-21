<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="GioiThieu.aspx.cs" Inherits="BanSachTest.GioiThieu" %>
<%@ Register src="UserUI/GioiThieuGT.ascx" tagname="GioiThieuGT" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:GioiThieuGT ID="GioiThieuGT1" runat="server" />
</asp:Content>
