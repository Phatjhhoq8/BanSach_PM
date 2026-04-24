<%@ Page Title="Đăng nhập - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-16 lg:py-24">
        <div class="mx-auto grid max-w-5xl gap-10 lg:grid-cols-[0.95fr_1.05fr] lg:items-center">
            <div>
                <p class="eyebrow">Tài khoản khách hàng</p>
                <h1 class="mt-4 text-4xl font-bold sm:text-5xl">Đăng nhập để tiếp tục hành trình đọc.</h1>
                <p class="mt-5 text-lg leading-8 text-[var(--ink-soft)]">Tài khoản giúp lưu giỏ hàng trong SQL Server, đặt hàng và theo dõi trạng thái đơn sách.</p>
            </div>

            <div class="surface-panel p-6 sm:p-8 lg:p-10">
                <h2 class="text-3xl font-bold">Chào mừng trở lại</h2>
                <p class="mt-2 text-sm text-[var(--muted)]">Đăng nhập bằng email đã đăng ký.</p>
                <div class="mt-8 space-y-5">
                    <div>
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="user@gmail.com"></asp:TextBox>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Mật khẩu</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="••••••••"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" OnClick="btnLogin_Click" CssClass="btn-primary w-full py-4" />
                    <asp:Literal ID="litError" runat="server"></asp:Literal>
                    <p class="pt-2 text-center text-sm text-[var(--ink-soft)]">Chưa có tài khoản? <a href="Register.aspx" class="font-black text-[var(--primary-dark)] hover:underline">Đăng ký ngay</a></p>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
