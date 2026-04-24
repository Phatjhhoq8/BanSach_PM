<%@ Page Title="Thanh toán - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <h1 class="text-4xl font-bold text-gray-900 font-heading mb-12">Hoàn tất đặt hàng</h1>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-16">
            <!-- Delivery Info -->
            <div class="space-y-10">
                <div>
                    <h2 class="text-2xl font-bold text-gray-900 font-heading mb-6 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-full bg-primary text-white text-sm flex items-center justify-center">1</span>
                        Thông tin giao hàng
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 bg-white p-8 rounded-[40px] border border-gray-100 shadow-sm">
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Họ tên người nhận</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary outline-none" placeholder="Nguyễn Văn A"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Số điện thoại</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary outline-none" placeholder="0901234567"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Email (nhận thông báo)</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary outline-none" placeholder="example@gmail.com"></asp:TextBox>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Địa chỉ giao hàng</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary outline-none" placeholder="Số nhà, tên đường, phường/xã..."></asp:TextBox>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Ghi chú thêm</label>
                            <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Rows="3" CssClass="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary outline-none" placeholder="Lời nhắn cho nhà sách hoặc shipper..."></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div>
                    <h2 class="text-2xl font-bold text-gray-900 font-heading mb-6 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-full bg-primary text-white text-sm flex items-center justify-center">2</span>
                        Phương thức thanh toán
                    </h2>
                    <div class="space-y-4">
                        <label class="flex items-center gap-4 p-6 bg-white rounded-3xl border border-gray-100 cursor-pointer hover:border-primary transition-all">
                            <asp:RadioButton ID="rbCOD" runat="server" GroupName="Payment" Checked="true" />
                            <div class="flex-1">
                                <span class="block font-bold text-gray-800">Thanh toán khi nhận hàng (COD)</span>
                                <span class="text-xs text-gray-400">Bạn sẽ thanh toán bằng tiền mặt cho shipper khi nhận được hàng.</span>
                            </div>
                            <svg class="w-8 h-8 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                        </label>
                        <label class="flex items-center gap-4 p-6 bg-white rounded-3xl border border-gray-100 cursor-pointer hover:border-primary transition-all opacity-50">
                            <asp:RadioButton ID="rbBank" runat="server" GroupName="Payment" Enabled="false" />
                            <div class="flex-1">
                                <span class="block font-bold text-gray-800">Chuyển khoản ngân hàng</span>
                                <span class="text-xs text-gray-400">Hệ thống đang bảo trì phương thức này.</span>
                            </div>
                            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path></svg>
                        </label>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="lg:col-span-1">
                <div class="bg-gray-900 rounded-[40px] p-10 text-white shadow-2xl sticky top-32">
                    <h2 class="text-2xl font-bold font-heading mb-8">Tóm tắt đơn hàng</h2>
                    <div class="space-y-6 max-h-[300px] overflow-y-auto mb-8 pr-4 custom-scrollbar">
                        <asp:Repeater ID="rptSummaryItems" runat="server">
                            <ItemTemplate>
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-16 bg-white/10 rounded-lg overflow-hidden flex-shrink-0">
                                        <img src="<%# Eval("HinhAnh") %>" alt="" class="w-full h-full object-cover">
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <h4 class="text-sm font-bold truncate"><%# Eval("TenSP") %></h4>
                                        <p class="text-xs text-gray-400 mt-1">SL: <%# Eval("SoLuong") %> x <%# Eval("DonGia", "{0:N0}đ") %></p>
                                    </div>
                                    <div class="text-sm font-bold"><%# Eval("ThanhTien", "{0:N0}đ") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="space-y-4 border-t border-white/10 pt-8 mb-8">
                        <div class="flex justify-between text-gray-400 text-sm">
                            <span>Tạm tính</span>
                            <span class="text-white"><asp:Literal ID="litSubtotal" runat="server">0đ</asp:Literal></span>
                        </div>
                        <div class="flex justify-between text-gray-400 text-sm">
                            <span>Vận chuyển (Đồng giá)</span>
                            <span class="text-white">30.000đ</span>
                        </div>
                        <div class="flex justify-between text-xl font-bold pt-4">
                            <span>Tổng thanh toán</span>
                            <span class="text-primary"><asp:Literal ID="litTotal" runat="server">0đ</asp:Literal></span>
                        </div>
                    </div>

                    <asp:Button ID="btnOrder" runat="server" Text="Xác nhận đặt hàng" OnClick="btnOrder_Click" CssClass="w-full py-5 bg-primary hover:bg-sky-400 text-white text-center font-bold rounded-2xl transition-all shadow-xl shadow-primary/20 active:scale-95" />
                    <p class="text-[10px] text-gray-500 text-center mt-6 uppercase tracking-widest leading-relaxed">Bằng cách nhấn đặt hàng, bạn đồng ý với các điều khoản dịch vụ của chúng tôi.</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
