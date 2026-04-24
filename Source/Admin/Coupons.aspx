<%@ Page Title="Quản lý khuyến mãi - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Coupons.aspx.cs" Inherits="Admin_Coupons" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Quản lý khuyến mãi</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="grid lg:grid-cols-3 gap-8">
        <div class="glass-card rounded-[32px] p-6 h-fit">
            <h2 class="text-white font-bold text-lg mb-5">Tạo mã giảm giá</h2>
            <div class="space-y-4">
                <asp:TextBox ID="txtCode" runat="server" CssClass="w-full bg-slate-900 border border-slate-700 rounded-xl px-4 py-3 text-white focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Mã: SUMMER10"></asp:TextBox>
                <asp:TextBox ID="txtPercent" runat="server" CssClass="w-full bg-slate-900 border border-slate-700 rounded-xl px-4 py-3 text-white focus:ring-2 focus:ring-blue-500 outline-none" placeholder="% giảm"></asp:TextBox>
                <asp:TextBox ID="txtQuantity" runat="server" CssClass="w-full bg-slate-900 border border-slate-700 rounded-xl px-4 py-3 text-white focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Số lượng"></asp:TextBox>
                <asp:Button ID="btnSave" runat="server" Text="Lưu mã" OnClick="btnSave_Click" CssClass="w-full min-h-[44px] bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-xl transition-colors" />
                <asp:Label ID="lblMessage" runat="server" CssClass="block text-sm text-emerald-400"></asp:Label>
            </div>
        </div>
        <div class="lg:col-span-2 glass-card rounded-[32px] overflow-hidden">
            <table class="w-full text-left"><thead><tr class="text-slate-500 text-xs uppercase tracking-wider"><th class="px-6 py-4">Mã</th><th class="px-6 py-4">% giảm</th><th class="px-6 py-4">Số lượng</th><th class="px-6 py-4">Điều kiện</th></tr></thead>
                <tbody class="text-sm divide-y divide-white/5"><asp:Repeater ID="rptCoupons" runat="server"><ItemTemplate><tr class="hover:bg-white/5"><td class="px-6 py-4 text-white font-bold"><%# Eval("MaKM") %></td><td class="px-6 py-4 text-emerald-400"><%# Eval("PhanTramGiam") %>%</td><td class="px-6 py-4 text-slate-300"><%# Eval("SoLuong") %></td><td class="px-6 py-4 text-slate-400"><%# Eval("DieuKien", "{0:N0}đ") %></td></tr></ItemTemplate></asp:Repeater></tbody>
            </table>
        </div>
    </div>
</asp:Content>
