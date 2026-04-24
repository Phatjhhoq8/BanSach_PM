<%@ Page Title="Dashboard - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Admin_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">
    Dashboard Overview
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6 mb-10">
        <div class="glass-card p-6 rounded-3xl">
            <div class="flex items-center justify-between mb-4">
                <div class="w-12 h-12 bg-blue-500/10 rounded-2xl flex items-center justify-center text-blue-500">
                    <i data-lucide="dollar-sign" class="w-6 h-6"></i>
                </div>
                <span class="text-xs font-bold text-emerald-400 bg-emerald-500/10 px-2 py-1 rounded-lg">Tháng này</span>
            </div>
            <h3 class="text-slate-400 text-sm font-medium">Doanh thu tháng</h3>
            <p class="text-2xl font-bold text-white mt-1"><asp:Literal ID="litMonthlyRevenue" runat="server">0đ</asp:Literal></p>
        </div>

        <div class="glass-card p-6 rounded-3xl">
            <div class="flex items-center justify-between mb-4">
                <div class="w-12 h-12 bg-purple-500/10 rounded-2xl flex items-center justify-center text-purple-500">
                    <i data-lucide="shopping-bag" class="w-6 h-6"></i>
                </div>
                <span class="text-xs font-bold text-amber-400 bg-amber-500/10 px-2 py-1 rounded-lg">Chờ xử lý</span>
            </div>
            <h3 class="text-slate-400 text-sm font-medium">Đơn hàng chờ</h3>
            <p class="text-2xl font-bold text-white mt-1"><asp:Literal ID="litPendingOrders" runat="server">0</asp:Literal></p>
        </div>

        <div class="glass-card p-6 rounded-3xl">
            <div class="flex items-center justify-between mb-4">
                <div class="w-12 h-12 bg-amber-500/10 rounded-2xl flex items-center justify-center text-amber-500">
                    <i data-lucide="users" class="w-6 h-6"></i>
                </div>
                <span class="text-xs font-bold text-stone-300 bg-white/5 px-2 py-1 rounded-lg">Tổng</span>
            </div>
            <h3 class="text-slate-400 text-sm font-medium">Khách hàng</h3>
            <p class="text-2xl font-bold text-white mt-1"><asp:Literal ID="litCustomers" runat="server">0</asp:Literal></p>
        </div>

        <div class="glass-card p-6 rounded-3xl">
            <div class="flex items-center justify-between mb-4">
                <div class="w-12 h-12 bg-rose-500/10 rounded-2xl flex items-center justify-center text-rose-500">
                    <i data-lucide="alert-triangle" class="w-6 h-6"></i>
                </div>
                <span class="text-xs font-bold text-rose-500 bg-rose-500/10 px-2 py-1 rounded-lg">Cần nhập</span>
            </div>
            <h3 class="text-slate-400 text-sm font-medium">Sản phẩm sắp hết</h3>
            <p class="text-2xl font-bold text-white mt-1"><asp:Literal ID="litLowStock" runat="server">0</asp:Literal></p>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Recent Orders -->
        <div class="lg:col-span-2 glass-card rounded-[32px] overflow-hidden">
            <div class="p-8 border-b border-white/5 flex items-center justify-between">
                <h3 class="text-lg font-bold text-white">Đơn hàng gần đây</h3>
                <a href="Orders.aspx" class="text-blue-500 text-sm font-medium hover:underline">Xem tất cả</a>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead>
                        <tr class="text-slate-500 text-xs uppercase tracking-wider">
                            <th class="px-8 py-4">Mã đơn</th>
                            <th class="px-8 py-4">Khách hàng</th>
                            <th class="px-8 py-4">Tổng tiền</th>
                            <th class="px-8 py-4">Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm divide-y divide-white/5">
                        <asp:Repeater ID="rptRecentOrders" runat="server">
                            <ItemTemplate>
                                <tr class="hover:bg-white/5 transition-colors">
                                    <td class="px-8 py-4 text-white font-medium">#<%# Eval("MaDH") %></td>
                                    <td class="px-8 py-4 text-slate-300"><%# Eval("HoTen") %></td>
                                    <td class="px-8 py-4 text-white"><%# Eval("TongTien", "{0:N0}đ") %></td>
                                    <td class="px-8 py-4">
                                        <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase <%# GetStatusClass(Eval("TrangThai")) %>">
                                            <%# GetStatusText(Eval("TrangThai")) %>
                                        </span>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Top Products -->
        <div class="glass-card rounded-[32px] p-8">
            <h3 class="text-lg font-bold text-white mb-8">Sách bán chạy</h3>
            <div class="space-y-6">
                <asp:Repeater ID="rptTopProducts" runat="server">
                    <ItemTemplate>
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-16 bg-slate-800 rounded-lg overflow-hidden flex-shrink-0">
                                <img src="<%# Eval("HinhAnh") %>" alt="" class="w-full h-full object-cover">
                            </div>
                            <div class="flex-1 min-w-0">
                                <h4 class="text-sm font-semibold text-white truncate"><%# Eval("TenSP") %></h4>
                                <p class="text-xs text-slate-500 mt-1"><%# Eval("TacGia") %></p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm font-bold text-white"><%# Eval("SoLuongBan") %></p>
                                <p class="text-[10px] text-slate-500 uppercase font-bold">Bán</p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</asp:Content>
