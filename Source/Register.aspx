<%@ Page Title="Đăng ký - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-16 lg:py-24">
        <div class="mx-auto grid max-w-5xl gap-10 lg:grid-cols-[0.95fr_1.05fr] lg:items-center">
            <div>
                <p class="eyebrow">Thành viên The Book Haven</p>
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
                            <div class="relative">
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control pr-20" placeholder="Tối thiểu 6 ký tự"></asp:TextBox>
                                <button type="button" onclick="togglePassword('<%= txtPassword.ClientID %>', this)" class="absolute right-3 top-1/2 -translate-y-1/2 rounded-full px-3 py-1 text-xs font-black text-[var(--primary-dark)] hover:bg-[var(--paper-soft)]">Hiện</button>
                            </div>
                            <p class="mt-2 text-xs font-bold text-[var(--muted)]">Dùng ít nhất 6 ký tự, nên kết hợp chữ và số.</p>
                        </div>
                        <div>
                            <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Xác nhận mật khẩu</label>
                            <div class="relative">
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control pr-20" placeholder="Nhập lại mật khẩu"></asp:TextBox>
                                <button type="button" onclick="togglePassword('<%= txtConfirmPassword.ClientID %>', this)" class="absolute right-3 top-1/2 -translate-y-1/2 rounded-full px-3 py-1 text-xs font-black text-[var(--primary-dark)] hover:bg-[var(--paper-soft)]">Hiện</button>
                            </div>
                        </div>
                    </div>
                    <asp:Button ID="btnRegister" runat="server" Text="Đăng ký tài khoản" OnClick="btnRegister_Click" CssClass="btn-primary w-full py-4" />
                    <asp:Literal ID="litError" runat="server"></asp:Literal>
                    <p class="pt-2 text-center text-sm text-[var(--ink-soft)]">Đã có tài khoản? <a id="lnkLogin" runat="server" href="Login.aspx" class="font-black text-[var(--primary-dark)] hover:underline">Đăng nhập</a></p>
                </div>
            </div>
        </div>
    </section>
    <script>
        function togglePassword(inputId, btn) {
            const input = document.getElementById(inputId);
            if (!input) return;
            const visible = input.type === 'text';
            input.type = visible ? 'password' : 'text';
            btn.innerText = visible ? 'Hiện' : 'Ẩn';
        }
    </script>
</asp:Content>
