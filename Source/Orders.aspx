<%@ Page Title="Đơn hàng của tôi - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="flex items-center gap-4 mb-12">
            <a href="Account.aspx" class="w-10 h-10 rounded-full bg-white border border-gray-100 flex items-center justify-center text-gray-400 hover:text-primary transition-all">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            </a>
            <h1 class="text-4xl font-bold text-gray-900 font-heading">Lịch sử đơn hàng</h1>
        </div>

        <div class="space-y-6">
            <asp:Repeater ID="rptOrders" runat="server">
                <ItemTemplate>
                    <div class="bg-white rounded-[40px] border border-gray-100 overflow-hidden shadow-sm hover:shadow-xl transition-all">
                        <div class="p-8 border-b border-gray-50 flex flex-wrap items-center justify-between gap-6">
                            <div class="flex items-center gap-8">
                                <div>
                                    <p class="text-[10px] text-gray-400 uppercase font-bold tracking-widest mb-1">Mã đơn hàng</p>
                                    <p class="text-lg font-bold text-gray-900">#<%# Eval("MaDH") %></p>
                                </div>
                                <div>
                                    <p class="text-[10px] text-gray-400 uppercase font-bold tracking-widest mb-1">Ngày đặt</p>
                                    <p class="text-sm font-medium text-gray-700"><%# Eval("NgayDat", "{0:dd/MM/yyyy HH:mm}") %></p>
                                </div>
                                <div>
                                    <p class="text-[10px] text-gray-400 uppercase font-bold tracking-widest mb-1">Tổng tiền</p>
                                    <p class="text-sm font-bold text-primary"><%# Eval("TongTien", "{0:N0}đ") %></p>
                                </div>
                            </div>
                            <div>
                                <span class="px-4 py-1.5 rounded-full text-xs font-bold uppercase <%# GetStatusClass(Eval("TrangThai")) %>">
                                    <%# GetStatusText(Eval("TrangThai")) %>
                                </span>
                            </div>
                        </div>
                        <div class="p-8 bg-gray-50/50">
                            <div class="space-y-4">
                                <asp:Repeater ID="rptOrderDetails" runat="server" DataSource='<%# Eval("Details") %>'>
                                    <ItemTemplate>
                                        <div class="flex items-center gap-4">
                                            <div class="w-12 h-16 bg-white rounded-lg overflow-hidden flex-shrink-0 border border-gray-100">
                                                <img src="<%# Eval("HinhAnh") %>" alt="" class="w-full h-full object-cover">
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <h4 class="text-sm font-bold text-gray-800 truncate"><%# Eval("TenSP") %></h4>
                                                <p class="text-xs text-gray-500 mt-1">Số lượng: <%# Eval("SoLuong") %> x <%# Eval("DonGia", "{0:N0}đ") %></p>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="mt-8 flex justify-end">
                                <a href="OrderDetail.aspx?id=<%# Eval("MaDH") %>" class="text-sm font-bold text-gray-400 hover:text-primary transition-colors flex items-center gap-1">
                                    Xem chi tiết đơn hàng
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:PlaceHolder ID="phNoOrders" runat="server" Visible="false">
                <div class="text-center py-24 bg-white rounded-[40px] border border-gray-100 shadow-sm">
                    <div class="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-6 text-gray-300">
                        <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                    </div>
                    <h3 class="text-xl font-bold text-gray-400">Bạn chưa có đơn hàng nào</h3>
                    <a href="DanhMuc.aspx" class="mt-6 inline-block text-primary font-bold hover:underline">Khám phá sách ngay</a>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>
</asp:Content>
