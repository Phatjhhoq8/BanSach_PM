<%@ Page Title="Chi tiết đơn hàng - Premium Admin" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="OrderDetail.aspx.cs" Inherits="Admin_OrderDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">
    Chi tiết đơn hàng
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="mb-8 flex items-center justify-between gap-4">
        <a href="Orders.aspx" class="rounded-2xl bg-adminpanel px-4 py-3 text-sm font-bold text-stone-300 hover:text-white">Quay lại đơn hàng</a>
        <span class="rounded-full bg-adminaccent px-4 py-2 text-sm font-black text-adminbg">#<asp:Literal ID="litOrderId" runat="server"></asp:Literal></span>
    </div>

    <div class="grid gap-8 xl:grid-cols-[1fr_24rem]">
        <div class="glass-card overflow-hidden rounded-[32px]">
            <div class="border-b border-white/5 p-8">
                <h2 class="text-xl font-black text-white">Sản phẩm trong đơn</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead class="text-xs uppercase tracking-wider text-slate-500">
                        <tr>
                            <th class="px-8 py-4">Sách</th>
                            <th class="px-8 py-4">Số lượng</th>
                            <th class="px-8 py-4">Đơn giá</th>
                            <th class="px-8 py-4 text-right">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-white/5">
                        <asp:Repeater ID="rptItems" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="px-8 py-4">
                                        <div class="flex items-center gap-4">
                                            <img src='<%# Eval("HinhAnh") %>' alt='' class="h-16 w-12 rounded-lg object-cover" />
                                            <div>
                                                <p class="font-bold text-white"><%# Eval("TenSP") %></p>
                                                <p class="mt-1 text-xs text-slate-500">Mã SP: <%# Eval("MaSP") %></p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-4 text-slate-300"><%# Eval("SoLuong") %></td>
                                    <td class="px-8 py-4 text-slate-300"><%# Eval("DonGia", "{0:N0}đ") %></td>
                                    <td class="px-8 py-4 text-right font-black text-white"><%# Eval("ThanhTien", "{0:N0}đ") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <aside class="space-y-6">
            <div class="glass-card rounded-[32px] p-8">
                <h2 class="text-xl font-black text-white">Thông tin khách hàng</h2>
                <div class="mt-6 space-y-4 text-sm">
                    <p><span class="text-slate-500">Khách hàng:</span> <span class="font-bold text-white"><asp:Literal ID="litCustomer" runat="server"></asp:Literal></span></p>
                    <p><span class="text-slate-500">Điện thoại:</span> <span class="font-bold text-white"><asp:Literal ID="litPhone" runat="server"></asp:Literal></span></p>
                    <p class="leading-7"><span class="text-slate-500">Địa chỉ:</span><br/><asp:Literal ID="litAddress" runat="server"></asp:Literal></p>
                    <p class="leading-7"><span class="text-slate-500">Ghi chú:</span><br/><asp:Literal ID="litNote" runat="server"></asp:Literal></p>
                </div>
            </div>
            <div class="glass-card rounded-[32px] p-8">
                <h2 class="text-xl font-black text-white">Trạng thái</h2>
                <p class="mt-4 text-sm text-slate-400">Ngày đặt: <asp:Literal ID="litDate" runat="server"></asp:Literal></p>
                <p class="mt-2 text-2xl font-black text-white"><asp:Literal ID="litTotal" runat="server"></asp:Literal></p>
                <div class="mt-5 space-y-2 rounded-2xl bg-adminbg p-4 text-sm text-slate-300">
                    <div class="flex justify-between gap-3"><span>Tạm tính</span><strong class="text-white"><asp:Literal ID="litSubtotal" runat="server"></asp:Literal></strong></div>
                    <div class="flex justify-between gap-3"><span>Vận chuyển</span><strong class="text-white"><asp:Literal ID="litShippingFee" runat="server"></asp:Literal></strong></div>
                    <div class="flex justify-between gap-3"><span>Giảm giá</span><strong class="text-emerald-400"><asp:Literal ID="litDiscount" runat="server"></asp:Literal></strong></div>
                    <div class="flex justify-between gap-3"><span>Mã ưu đãi</span><strong class="text-white"><asp:Literal ID="litCoupon" runat="server"></asp:Literal></strong></div>
                </div>
                <div class="mt-6">
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3">
                        <asp:ListItem Value="0">Chờ xác nhận</asp:ListItem>
                        <asp:ListItem Value="1">Đang xử lý</asp:ListItem>
                        <asp:ListItem Value="2">Đang giao hàng</asp:ListItem>
                        <asp:ListItem Value="3">Hoàn thành</asp:ListItem>
                        <asp:ListItem Value="4">Đã hủy</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnUpdate" runat="server" Text="Cập nhật trạng thái" OnClick="btnUpdate_Click" CssClass="mt-4 w-full rounded-xl bg-adminaccent px-5 py-3 font-black text-adminbg hover:opacity-90" />
                    <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                </div>
            </div>
        </aside>
    </div>
</asp:Content>
