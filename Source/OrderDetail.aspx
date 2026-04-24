<%@ Page Title="Chi tiết đơn hàng - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="OrderDetail.aspx.cs" Inherits="OrderDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="flex items-center justify-between gap-4 mb-10">
            <div>
                <a href="Orders.aspx" class="text-primary font-bold hover:text-amber-800 transition-colors">Quay lại đơn hàng</a>
                <h1 class="font-heading text-4xl font-bold text-zinc-950 mt-4">Đơn hàng #<asp:Literal ID="litOrderId" runat="server" /></h1>
            </div>
            <span class="px-4 py-2 rounded-full text-xs font-bold uppercase bg-amber-100 text-primary"><asp:Literal ID="litStatus" runat="server" /></span>
        </div>

        <asp:PlaceHolder ID="phNotFound" runat="server" Visible="false">
            <div class="bg-white rounded-[32px] border border-amber-100 p-10 text-center text-zinc-600">Không tìm thấy đơn hàng hoặc bạn không có quyền xem đơn hàng này.</div>
        </asp:PlaceHolder>

        <asp:PlaceHolder ID="phContent" runat="server" Visible="false">
            <div class="grid lg:grid-cols-3 gap-8">
                <div class="lg:col-span-2 bg-white rounded-[32px] border border-amber-100 p-6 shadow-sm">
                    <h2 class="font-bold text-xl text-zinc-950 mb-6">Sản phẩm trong đơn</h2>
                    <div class="space-y-4">
                        <asp:Repeater ID="rptItems" runat="server">
                            <ItemTemplate>
                                <div class="flex gap-4 border-b border-amber-50 pb-4 last:border-0">
                                    <img src='<%# Eval("HinhAnh") %>' alt='<%# Eval("TenSP") %>' class="w-16 h-24 rounded-xl object-cover bg-amber-50" loading="lazy" />
                                    <div class="flex-1 min-w-0">
                                        <h3 class="font-bold text-zinc-900"><%# Eval("TenSP") %></h3>
                                        <p class="text-sm text-zinc-500 mt-1">Số lượng: <%# Eval("SoLuong") %> x <%# Eval("DonGia", "{0:N0}đ") %></p>
                                    </div>
                                    <div class="font-bold text-primary"><%# Eval("ThanhTien", "{0:N0}đ") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
                <aside class="bg-zinc-950 text-white rounded-[32px] p-8 shadow-xl h-fit">
                    <h2 class="font-heading text-2xl font-bold mb-6">Thông tin giao hàng</h2>
                    <div class="space-y-4 text-sm text-zinc-300">
                        <p><span class="block text-zinc-500 uppercase text-xs font-bold">Ngày đặt</span><asp:Literal ID="litDate" runat="server" /></p>
                        <p><span class="block text-zinc-500 uppercase text-xs font-bold">Địa chỉ</span><asp:Literal ID="litAddress" runat="server" /></p>
                        <p><span class="block text-zinc-500 uppercase text-xs font-bold">Số điện thoại</span><asp:Literal ID="litPhone" runat="server" /></p>
                        <p><span class="block text-zinc-500 uppercase text-xs font-bold">Thanh toán</span><asp:Literal ID="litPayment" runat="server" /></p>
                    </div>
                    <div class="border-t border-white/10 mt-8 pt-6 flex justify-between text-lg font-bold">
                        <span>Tổng tiền</span>
                        <span class="text-amber-300"><asp:Literal ID="litTotal" runat="server" /></span>
                    </div>
                </aside>
            </div>
        </asp:PlaceHolder>
    </div>
</asp:Content>
