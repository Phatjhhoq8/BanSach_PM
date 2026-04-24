<%@ Page Title="Giỏ hàng - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="GioHang.aspx.cs" Inherits="GioHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <h1 class="text-4xl font-bold text-gray-900 font-heading mb-12 flex items-center gap-4">
            Giỏ hàng của bạn
            <span class="text-sm font-sans font-medium text-gray-400 bg-gray-100 px-3 py-1 rounded-full"><asp:Literal ID="litCartCount" runat="server">0</asp:Literal> sản phẩm</span>
        </h1>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
            <!-- Cart Items -->
            <div class="lg:col-span-2 space-y-6">
                <asp:Repeater ID="rptCartItems" runat="server">
                    <ItemTemplate>
                        <div class="flex items-center gap-6 p-6 bg-white rounded-3xl border border-gray-100 hover:shadow-xl transition-all group">
                            <div class="w-24 h-36 bg-gray-50 rounded-2xl overflow-hidden flex-shrink-0 shadow-sm group-hover:scale-105 transition-transform">
                                <img src="<%# Eval("HinhAnh") %>" alt="" class="w-full h-full object-cover">
                            </div>
                            <div class="flex-1 min-w-0">
                                <h3 class="text-lg font-bold text-gray-800 truncate"><%# Eval("TenSP") %></h3>
                                <p class="text-sm text-gray-400 mt-1"><%# Eval("TacGia") %></p>
                                <div class="mt-4 flex items-center gap-6">
                                    <div class="flex items-center bg-gray-100 rounded-full p-1">
                                        <button type="button" onclick="updateQty(<%# Eval("MaSP") %>, -1)" class="w-8 h-8 flex items-center justify-center text-gray-500 hover:text-primary transition-colors">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"></path></svg>
                                        </button>
                                        <span class="w-10 text-center text-sm font-bold text-gray-700"><%# Eval("SoLuong") %></span>
                                        <button type="button" onclick="updateQty(<%# Eval("MaSP") %>, 1)" class="w-8 h-8 flex items-center justify-center text-gray-500 hover:text-primary transition-colors">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                                        </button>
                                    </div>
                                    <div class="text-primary font-bold text-lg"><%# Eval("ThanhTien", "{0:N0}đ") %></div>
                                </div>
                            </div>
                            <button type="button" onclick="removeItem(<%# Eval("MaSP") %>)" class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center text-gray-300 hover:bg-rose-50 hover:text-rose-500 transition-all">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                            </button>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:PlaceHolder ID="phEmptyCart" runat="server" Visible="false">
                    <div class="text-center py-20 bg-white rounded-[40px] border border-dashed border-gray-200">
                        <div class="w-24 h-24 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-6">
                            <svg class="w-12 h-12 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                        </div>
                        <h2 class="text-xl font-bold text-gray-400">Giỏ hàng của bạn đang trống</h2>
                        <a href="DanhMuc.aspx" class="mt-6 inline-block text-primary font-bold hover:underline">Quay lại cửa hàng</a>
                    </div>
                </asp:PlaceHolder>
            </div>

            <!-- Summary -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-[40px] p-10 shadow-2xl border border-gray-100 sticky top-32">
                    <h2 class="text-2xl font-bold text-gray-900 font-heading mb-8">Tổng cộng</h2>
                    <div class="space-y-4 border-b border-gray-100 pb-8 mb-8">
                        <div class="flex justify-between text-gray-500">
                            <span>Tạm tính</span>
                            <span class="font-bold text-gray-900"><asp:Literal ID="litSubtotal" runat="server">0đ</asp:Literal></span>
                        </div>
                        <div class="flex justify-between text-gray-500">
                            <span>Phí vận chuyển</span>
                            <span class="font-bold text-gray-900">Tính khi thanh toán</span>
                        </div>
                    </div>
                    <div class="flex justify-between text-xl font-bold text-gray-900 mb-10">
                        <span>Tổng tiền</span>
                        <span class="text-primary"><asp:Literal ID="litTotal" runat="server">0đ</asp:Literal></span>
                    </div>
                    <a href="Checkout.aspx" class="block w-full py-5 bg-primary hover:bg-secondary text-white text-center font-bold rounded-2xl shadow-xl shadow-primary/30 transition-all active:scale-95">
                        Tiến hành thanh toán
                    </a>
                    <div class="mt-6 flex items-center justify-center gap-4 text-xs text-gray-400 uppercase tracking-widest font-bold">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                        Thanh toán an toàn
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function updateQty(maSP, delta) {
            // This is a simplified client logic, usually we'd call CartHandler.ashx
            const currentQty = parseInt(event.target.parentElement.querySelector('span').innerText);
            const newQty = currentQty + delta;
            if (newQty < 1) return;

            fetch(`CartHandler.ashx?action=update&maSP=${maSP}&qty=${newQty}`)
                .then(r => r.json())
                .then(data => {
                    if (data.success) location.reload();
                });
        }

        function removeItem(maSP) {
            if (!confirm('Xóa sản phẩm này khỏi giỏ hàng?')) return;
            fetch(`CartHandler.ashx?action=remove&maSP=${maSP}`)
                .then(r => r.json())
                .then(data => {
                    if (data.success) location.reload();
                });
        }
    </script>
</asp:Content>
