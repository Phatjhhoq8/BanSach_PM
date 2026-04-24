<%@ Page Title="Đăng nhập - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="min-h-[80vh] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-[40px] shadow-2xl border border-gray-100">
            <div class="text-center">
                <h2 class="text-3xl font-extrabold text-gray-900 font-heading">Chào mừng trở lại</h2>
                <p class="mt-2 text-sm text-gray-600">Đăng nhập để tiếp tục mua sắm tại Premium Books</p>
            </div>
            <div class="mt-8 space-y-6">
                <div class="space-y-4">
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700">Email của bạn</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary focus:border-primary transition-all outline-none" placeholder="example@gmail.com"></asp:TextBox>
                    </div>
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700">Mật khẩu</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary focus:border-primary transition-all outline-none" placeholder="••••••••"></asp:TextBox>
                    </div>
                </div>

                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input id="remember-me" name="remember-me" type="checkbox" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded">
                        <label for="remember-me" class="ml-2 block text-sm text-gray-900">Ghi nhớ tôi</label>
                    </div>
                    <div class="text-sm">
                        <a href="#" class="font-medium text-primary hover:text-secondary">Quên mật khẩu?</a>
                    </div>
                </div>

                <div>
                    <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" OnClick="btnLogin_Click" CssClass="group relative w-full flex justify-center py-4 px-4 border border-transparent text-sm font-bold rounded-2xl text-white bg-primary hover:bg-secondary focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary transition-all active:scale-95" />
                </div>
                
                <asp:Literal ID="litError" runat="server"></asp:Literal>

                <div class="text-center pt-4">
                    <p class="text-sm text-gray-600">
                        Chưa có tài khoản? 
                        <a href="Register.aspx" class="font-bold text-primary hover:text-secondary">Đăng ký ngay</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
