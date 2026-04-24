<%@ Page Title="Tài khoản của tôi - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Account.aspx.cs" Inherits="Account" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-10 lg:py-16">
        <div class="mb-10">
            <p class="eyebrow">Tài khoản</p>
            <h1 class="mt-3 text-4xl font-bold sm:text-5xl">Thông tin khách hàng</h1>
        </div>

        <asp:Literal ID="litMessage" runat="server"></asp:Literal>

        <div class="grid gap-8 lg:grid-cols-[20rem_1fr]">
            <aside class="surface-panel p-6 sm:p-8">
                <div class="flex items-center gap-4 border-b border-[var(--line)] pb-6">
                    <div class="flex h-16 w-16 items-center justify-center rounded-full bg-[var(--primary)] text-2xl font-black text-[oklch(98%_0.012_78)]">
                        <asp:Literal ID="litAvatar" runat="server"></asp:Literal>
                    </div>
                    <div class="min-w-0">
                        <h2 class="line-clamp-1 text-xl font-black"><asp:Literal ID="litNameSide" runat="server"></asp:Literal></h2>
                        <p class="mt-1 text-sm text-[var(--muted)]">Khách hàng Premium</p>
                    </div>
                </div>
                <nav class="mt-6 space-y-2 text-sm font-black">
                    <a href="Account.aspx" class="flex rounded-2xl bg-[var(--primary-soft)] px-4 py-3 text-[var(--primary-dark)]">Hồ sơ cá nhân</a>
                    <a href="Orders.aspx" class="flex rounded-2xl px-4 py-3 text-[var(--ink-soft)] hover:bg-[var(--paper-soft)] hover:text-[var(--primary-dark)]">Đơn hàng của tôi</a>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="flex w-full rounded-2xl px-4 py-3 text-left text-red-700 hover:bg-red-50">Đăng xuất</asp:LinkButton>
                </nav>
            </aside>

            <section class="surface-panel p-6 sm:p-8 lg:p-10">
                <h2 class="text-2xl font-bold">Chỉnh sửa hồ sơ</h2>
                <div class="mt-8 grid gap-5 md:grid-cols-2">
                    <div class="md:col-span-2">
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Họ và tên</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Số điện thoại</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" ReadOnly="true" CssClass="form-control cursor-not-allowed opacity-70"></asp:TextBox>
                    </div>
                    <div class="md:col-span-2">
                        <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Địa chỉ giao hàng mặc định</label>
                        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="md:col-span-2 pt-2">
                        <asp:Button ID="btnUpdate" runat="server" Text="Cập nhật thông tin" OnClick="btnUpdate_Click" CssClass="btn-primary w-full sm:w-auto" />
                    </div>
                </div>
            </section>
        </div>
    </section>
</asp:Content>
