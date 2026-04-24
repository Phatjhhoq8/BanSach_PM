<%@ Page Title="Quản lý khách hàng - Premium Admin" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Customers.aspx.cs" Inherits="Admin_Customers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">
    Quản lý khách hàng
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="mb-8 flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div class="relative w-full md:max-w-md">
            <i data-lucide="search" class="absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-500"></i>
            <asp:TextBox ID="txtSearch" runat="server" CssClass="admin-input w-full rounded-xl py-3 pl-11 pr-4" placeholder="Tìm tên, email, số điện thoại..." AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
        </div>
        <span class="text-sm text-slate-500"><asp:Literal ID="litSummary" runat="server">Đang tải khách hàng...</asp:Literal></span>
    </div>

    <div class="glass-card overflow-hidden rounded-[32px]">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm">
                <thead>
                    <tr class="text-xs uppercase tracking-wider text-slate-500">
                        <th class="px-8 py-4">Khách hàng</th>
                        <th class="px-8 py-4">Liên hệ</th>
                        <th class="px-8 py-4">Đơn hàng</th>
                        <th class="px-8 py-4">Tổng chi tiêu</th>
                        <th class="px-8 py-4">Ngày đăng ký</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-white/5">
                    <asp:Repeater ID="rptCustomers" runat="server">
                        <ItemTemplate>
                            <tr class="hover:bg-white/5">
                                <td class="px-8 py-4">
                                    <p class="font-bold text-white"><%# Eval("HoTen") %></p>
                                    <p class="mt-1 text-xs text-slate-500">#<%# Eval("MaKH") %></p>
                                </td>
                                <td class="px-8 py-4 text-slate-300">
                                    <p><%# Eval("Email") %></p>
                                    <p class="mt-1 text-xs text-slate-500"><%# Eval("SoDienThoai") %></p>
                                </td>
                                <td class="px-8 py-4 text-slate-300"><%# Eval("SoDon") %></td>
                                <td class="px-8 py-4 font-black text-white"><%# Eval("TongChiTieu", "{0:N0}đ") %></td>
                                <td class="px-8 py-4 text-slate-400"><%# Eval("NgayDangKy", "{0:dd/MM/yyyy}") %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
