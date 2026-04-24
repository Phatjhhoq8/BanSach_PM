<%@ Page Title="Quản lý đơn hàng - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Admin_Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">
    Quản lý đơn hàng
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="mb-8 flex items-center justify-between gap-4">
        <div class="flex items-center gap-4">
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="bg-slate-800 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                <asp:ListItem Value="-1">Tất cả trạng thái</asp:ListItem>
                <asp:ListItem Value="0">Chờ xác nhận</asp:ListItem>
                <asp:ListItem Value="1">Đang xử lý</asp:ListItem>
                <asp:ListItem Value="2">Đang giao hàng</asp:ListItem>
                <asp:ListItem Value="3">Hoàn thành</asp:ListItem>
                <asp:ListItem Value="4">Đã hủy</asp:ListItem>
            </asp:DropDownList>
        </div>
    </div>

    <div class="glass-card rounded-[32px] overflow-hidden">
        <table class="w-full text-left">
            <thead>
                <tr class="text-slate-500 text-xs uppercase tracking-wider">
                    <th class="px-8 py-4">Mã đơn</th>
                    <th class="px-8 py-4">Khách hàng</th>
                    <th class="px-8 py-4">Ngày đặt</th>
                    <th class="px-8 py-4">Tổng tiền</th>
                    <th class="px-8 py-4">Trạng thái</th>
                    <th class="px-8 py-4 text-right">Thao tác</th>
                </tr>
            </thead>
            <tbody class="text-sm divide-y divide-white/5">
                <asp:Repeater ID="rptOrders" runat="server">
                    <ItemTemplate>
                        <tr class="hover:bg-white/5 transition-colors">
                            <td class="px-8 py-4 text-white font-medium">#<%# Eval("MaDH") %></td>
                            <td class="px-8 py-4">
                                <p class="text-white font-semibold"><%# Eval("HoTen") %></p>
                                <p class="text-xs text-slate-500"><%# Eval("SoDienThoaiGiao") %></p>
                            </td>
                            <td class="px-8 py-4 text-slate-400"><%# Eval("NgayDat", "{0:dd/MM/yyyy HH:mm}") %></td>
                            <td class="px-8 py-4 text-white font-bold"><%# Eval("TongTien", "{0:N0}đ") %></td>
                            <td class="px-8 py-4">
                                <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase <%# GetStatusClass(Eval("TrangThai")) %>">
                                    <%# GetStatusText(Eval("TrangThai")) %>
                                </span>
                            </td>
                            <td class="px-8 py-4 text-right">
                                <div class="flex items-center justify-end gap-2">
                                    <asp:DropDownList ID="ddlUpdateStatus" runat="server" CssClass="bg-slate-900 text-xs border border-slate-700 text-slate-400 px-2 py-1 rounded-lg" onchange='<%# "updateOrderStatus(" + Eval("MaDH") + ", this.value)" %>'>
                                        <asp:ListItem Value="0">Chờ xác nhận</asp:ListItem>
                                        <asp:ListItem Value="1">Đang xử lý</asp:ListItem>
                                        <asp:ListItem Value="2">Đang giao hàng</asp:ListItem>
                                        <asp:ListItem Value="3">Hoàn thành</asp:ListItem>
                                        <asp:ListItem Value="4">Đã hủy</asp:ListItem>
                                    </asp:DropDownList>
                                    <a href="OrderDetail.aspx?id=<%# Eval("MaDH") %>" class="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-slate-400 hover:text-white transition-colors">
                                        <i data-lucide="eye" class="w-4 h-4"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>

    <script>
        function updateOrderStatus(id, status) {
            if (!confirm('Cập nhật trạng thái đơn hàng này?')) return;
            // Typically use an AJAX handler or a hidden button to trigger postback
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'Orders.aspx?action=update&id=' + id + '&status=' + status;
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</asp:Content>
