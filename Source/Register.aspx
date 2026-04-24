<%@ Page Title="Đăng ký - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-16 lg:py-24">
        <div class="mx-auto grid max-w-5xl gap-10 lg:grid-cols-[0.95fr_1.05fr] lg:items-center">
            <div>
                <p class="eyebrow">Thành viên Premium Books</p>
                <h1 class="mt-4 text-4xl font-bold sm:text-5xl">Tạo tài khoản để đặt sách và theo dõi đơn hàng.</h1>
                <p class="mt-5 text-lg leading-8 text-[var(--ink-soft)]">Đồ án hỗ trợ đầy đủ vai trò khách hàng: đăng ký, đăng nhập, giỏ hàng, checkout và lịch sử đơn.</p>
            </div>

            <div class="surface-panel p-6 sm:p-8 lg:p-10">
                <h2 class="text-3xl font-bold">Tạo tài khoản mới</h2>
                <div class="mt-8 grid gap-5">
                    <div>
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Họ và tên</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Nguyễn Văn A"></asp:TextBox>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="example@gmail.com"></asp:TextBox>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Số điện thoại</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="0901234567"></asp:TextBox>
                    </div>
                    <div class="grid gap-5 sm:grid-cols-2">
                        <div>
                            <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Mật khẩu</label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Tối thiểu 6 ký tự"></asp:TextBox>
                        </div>
                        <div>
                            <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Xác nhận mật khẩu</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Nhập lại mật khẩu"></asp:TextBox>
                        </div>
                    </div>
                    <asp:Button ID="btnRegister" runat="server" Text="Đăng ký tài khoản" OnClick="btnRegister_Click" CssClass="btn-primary w-full py-4" />
                    <asp:Literal ID="litError" runat="server"></asp:Literal>
                    <p class="pt-2 text-center text-sm text-[var(--ink-soft)]">Đã có tài khoản? <a href="Login.aspx" class="font-black text-[var(--primary-dark)] hover:underline">Đăng nhập</a></p>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
