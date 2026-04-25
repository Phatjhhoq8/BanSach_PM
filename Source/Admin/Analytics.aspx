<%@ Page Title="Analytics - The Book Haven" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Analytics.aspx.cs" Inherits="Admin_Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Phân tích kinh doanh</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="grid md:grid-cols-4 gap-6 mb-8">
        <div class="glass-card rounded-3xl p-6"><p class="text-slate-500 text-xs uppercase font-bold">Doanh thu</p><div class="text-2xl font-bold text-white mt-2"><asp:Literal ID="litRevenue" runat="server" /></div></div>
        <div class="glass-card rounded-3xl p-6"><p class="text-slate-500 text-xs uppercase font-bold">Đơn hàng</p><div class="text-2xl font-bold text-white mt-2"><asp:Literal ID="litOrders" runat="server" /></div></div>
        <div class="glass-card rounded-3xl p-6"><p class="text-slate-500 text-xs uppercase font-bold">Khách hàng</p><div class="text-2xl font-bold text-white mt-2"><asp:Literal ID="litCustomers" runat="server" /></div></div>
        <div class="glass-card rounded-3xl p-6"><p class="text-slate-500 text-xs uppercase font-bold">Sản phẩm</p><div class="text-2xl font-bold text-white mt-2"><asp:Literal ID="litProducts" runat="server" /></div></div>
    </div>
    <div class="grid lg:grid-cols-2 gap-8">
        <div class="glass-card rounded-[32px] p-6"><h2 class="font-bold text-white mb-5">Sản phẩm bán chạy</h2><div class="space-y-4"><asp:Repeater ID="rptTopProducts" runat="server"><ItemTemplate><div class="flex justify-between gap-4"><span class="text-slate-300 truncate"><%# Eval("TenSP") %></span><span class="text-emerald-400 font-bold"><%# Eval("SoLuongBan") %></span></div></ItemTemplate></asp:Repeater></div></div>
        <div class="glass-card rounded-[32px] p-6"><h2 class="font-bold text-white mb-5">Trạng thái đơn hàng</h2><div class="space-y-4"><asp:Repeater ID="rptStatus" runat="server"><ItemTemplate><div class="flex justify-between gap-4"><span class="text-slate-300"><%# Eval("TenTrangThai") %></span><span class="text-blue-400 font-bold"><%# Eval("SoLuong") %></span></div></ItemTemplate></asp:Repeater></div></div>
    </div>
</asp:Content>
