<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="TinTuc.aspx.cs" Inherits="BanSachTest.TinTuc" %>
<%@ Register src="UserUI/TinTucCT.ascx" tagname="TinTucCT" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <uc1:TinTucCT ID="TinTucCT1" runat="server" />
</asp:Content>
