<%@ Page Title="Đăng ký - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="min-h-[80vh] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-[40px] shadow-2xl border border-gray-100">
            <div class="text-center">
                <h2 class="text-3xl font-extrabold text-gray-900 font-heading">Tạo tài khoản mới</h2>
                <p class="mt-2 text-sm text-gray-600">Trở thành thành viên của Premium Books ngay hôm nay</p>
            </div>
            <div class="mt-8 space-y-6">
                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Họ và tên</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary focus:border-primary outline-none transition-all" placeholder="Nguyễn Văn A"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary focus:border-primary outline-none transition-all" placeholder="example@gmail.com"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Số điện thoại</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary focus:border-primary outline-none transition-all" placeholder="0901234567"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Mật khẩu</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary focus:border-primary outline-none transition-all" placeholder="••••••••"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Xác nhận mật khẩu</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-primary focus:border-primary outline-none transition-all" placeholder="••••••••"></asp:TextBox>
                    </div>
                </div>

                <div>
                    <asp:Button ID="btnRegister" runat="server" Text="Đăng ký tài khoản" OnClick="btnRegister_Click" CssClass="w-full flex justify-center py-4 px-4 border border-transparent text-sm font-bold rounded-2xl text-white bg-primary hover:bg-secondary focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary transition-all active:scale-95" />
                </div>
                
                <asp:Literal ID="litError" runat="server"></asp:Literal>

                <div class="text-center pt-4">
                    <p class="text-sm text-gray-600">
                        Đã có tài khoản? 
                        <a href="Login.aspx" class="font-bold text-primary hover:text-secondary">Đăng nhập ngay</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
