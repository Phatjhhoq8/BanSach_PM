<%@ Page Title="Tài khoản của tôi - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="Account.aspx.cs" Inherits="Account" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <h1 class="text-4xl font-bold text-gray-900 font-heading mb-12">Thông tin tài khoản</h1>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
            <!-- Sidebar Navigation -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-[40px] border border-gray-100 p-8 shadow-sm">
                    <div class="flex items-center gap-4 mb-10 pb-10 border-b border-gray-50">
                        <div class="w-16 h-16 bg-primary rounded-full flex items-center justify-center text-white text-2xl font-bold">
                            <asp:Literal ID="litAvatar" runat="server"></asp:Literal>
                        </div>
                        <div>
                            <h2 class="text-xl font-bold text-gray-900"><asp:Literal ID="litNameSide" runat="server"></asp:Literal></h2>
                            <p class="text-sm text-gray-400">Thành viên thân thiết</p>
                        </div>
                    </div>
                    <nav class="space-y-2">
                        <a href="Account.aspx" class="flex items-center gap-4 px-6 py-4 bg-gray-50 text-primary rounded-2xl font-bold">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                            Hồ sơ cá nhân
                        </a>
                        <a href="Orders.aspx" class="flex items-center gap-4 px-6 py-4 text-gray-500 hover:bg-gray-50 hover:text-primary rounded-2xl font-bold transition-all">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                            Đơn hàng của tôi
                        </a>
                        <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="flex items-center gap-4 px-6 py-4 text-rose-500 hover:bg-rose-50 rounded-2xl font-bold transition-all">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                            Đăng xuất
                        </asp:LinkButton>
                    </nav>
                </div>
            </div>

            <!-- Profile Form -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-[40px] border border-gray-100 p-10 shadow-sm">
                    <h3 class="text-2xl font-bold text-gray-900 font-heading mb-8">Chỉnh sửa hồ sơ</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Họ và tên</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="w-full px-6 py-4 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary outline-none transition-all"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Số điện thoại</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="w-full px-6 py-4 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary outline-none transition-all"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" ReadOnly="true" CssClass="w-full px-6 py-4 bg-gray-100 border border-gray-200 rounded-2xl text-gray-400 cursor-not-allowed outline-none"></asp:TextBox>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Địa chỉ giao hàng mặc định</label>
                            <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="w-full px-6 py-4 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary outline-none transition-all"></asp:TextBox>
                        </div>
                        <div class="md:col-span-2 pt-6">
                            <asp:Button ID="btnUpdate" runat="server" Text="Cập nhật thông tin" OnClick="btnUpdate_Click" CssClass="px-12 py-4 bg-primary hover:bg-secondary text-white font-bold rounded-2xl shadow-xl shadow-primary/20 transition-all active:scale-95" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
