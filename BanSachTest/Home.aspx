<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="BanSachTest.Home" %>
<%@ Register src="UserUI/HomeCT.ascx" tagname="HomeCT" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <uc1:HomeCT ID="HomeCT1" runat="server" />

</asp:Content>
