<%@ Page Title="Cấu hình hệ thống - The Book Haven" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Admin_Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Cấu hình hệ thống</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="grid gap-8 lg:grid-cols-[1.1fr_0.9fr]">
        <section class="glass-card rounded-[32px] p-8">
            <h2 class="mb-6 text-xl font-bold text-white">Thông tin cửa hàng</h2>
            <asp:Literal ID="litMessage" runat="server"></asp:Literal>
            <div class="space-y-4">
                <asp:TextBox ID="txtStoreName" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="Tên cửa hàng"></asp:TextBox>
                <asp:TextBox ID="txtHotline" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="Hotline"></asp:TextBox>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="Email hỗ trợ"></asp:TextBox>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="Địa chỉ"></asp:TextBox>
                <asp:TextBox ID="txtShippingFee" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="Phí vận chuyển"></asp:TextBox>
                <asp:Button ID="btnSave" runat="server" Text="Lưu cấu hình" OnClick="btnSave_Click" CssClass="rounded-xl bg-adminaccent px-6 py-3 font-black text-adminbg hover:opacity-90" />
            </div>
        </section>

        <section class="glass-card rounded-[32px] p-8">
            <h2 class="mb-6 text-xl font-bold text-white">Thanh toán & vận chuyển</h2>
            <div class="space-y-4 text-sm text-slate-300">
                <div class="flex items-center justify-between border-b border-white/5 pb-4"><span>COD</span><span class="rounded-full bg-emerald-500/10 px-3 py-1 font-bold text-emerald-400">Đang bật</span></div>
                <div class="flex items-center justify-between border-b border-white/5 pb-4"><span>Chuyển khoản ngân hàng</span><span class="rounded-full bg-blue-500/10 px-3 py-1 font-bold text-blue-400">Bảo trì</span></div>
                <p class="leading-relaxed">Phí vận chuyển được lưu trong database và dùng trực tiếp ở trang checkout.</p>
            </div>
        </section>
    </div>
</asp:Content>
