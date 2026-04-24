<%@ Page Title="Quản lý khách hàng - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Customers.aspx.cs" Inherits="Admin_Customers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Quản lý khách hàng</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="glass-card rounded-[32px] overflow-hidden">
        <table class="w-full text-left">
            <thead><tr class="text-slate-500 text-xs uppercase tracking-wider"><th class="px-8 py-4">Khách hàng</th><th class="px-8 py-4">Liên hệ</th><th class="px-8 py-4">Ngày đăng ký</th><th class="px-8 py-4 text-right">Đơn hàng</th><th class="px-8 py-4 text-right">Tổng chi tiêu</th></tr></thead>
            <tbody class="text-sm divide-y divide-white/5">
                <asp:Repeater ID="rptCustomers" runat="server">
                    <ItemTemplate>
                        <tr class="hover:bg-white/5 transition-colors">
                            <td class="px-8 py-4"><p class="text-white font-semibold"><%# Eval("HoTen") %></p><p class="text-xs text-slate-500">#<%# Eval("MaKH") %></p></td>
                            <td class="px-8 py-4 text-slate-400"><%# Eval("Email") %><br /><span class="text-xs"><%# Eval("SoDienThoai") %></span></td>
                            <td class="px-8 py-4 text-slate-400"><%# Eval("NgayDangKy", "{0:dd/MM/yyyy}") %></td>
                            <td class="px-8 py-4 text-right text-white font-bold"><%# Eval("SoDon") %></td>
                            <td class="px-8 py-4 text-right text-emerald-400 font-bold"><%# Eval("TongChiTieu", "{0:N0}đ") %></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>
</asp:Content>
