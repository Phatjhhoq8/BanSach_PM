<%@ Page Title="Đặt hàng thành công - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Success.aspx.cs" Inherits="Success" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-16 lg:py-24">
        <div class="mx-auto max-w-3xl text-center">
            <div class="mx-auto flex h-24 w-24 items-center justify-center rounded-full bg-[oklch(92%_0.08_145)] text-[var(--success)] shadow-[var(--shadow-sm)]">
                <svg class="h-12 w-12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
            </div>
            <p class="eyebrow mt-10">Đặt hàng thành công</p>
            <h1 class="mt-4 text-4xl font-bold sm:text-5xl">Cảm ơn bạn đã đặt sách.</h1>
            <p class="mx-auto mt-5 max-w-2xl text-lg leading-8 text-[var(--ink-soft)]">Đơn hàng <span class="font-black text-[var(--ink)]">#<asp:Literal ID="litOrderId" runat="server"></asp:Literal></span> đã được tiếp nhận và đang chờ quản trị viên xác nhận.</p>

            <div class="surface-panel mt-10 p-6 text-left sm:p-8">
                <h2 class="text-2xl font-bold">Các bước tiếp theo</h2>
                <div class="mt-6 grid gap-4">
                    <div class="flex gap-4 rounded-3xl bg-[var(--paper)] p-4">
                        <span class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-[var(--primary-soft)] text-sm font-black text-[var(--primary-dark)]">1</span>
                        <p class="text-sm leading-7 text-[var(--ink-soft)]">Nhà sách sẽ kiểm tra tồn kho và xác nhận đơn.</p>
                    </div>
                    <div class="flex gap-4 rounded-3xl bg-[var(--paper)] p-4">
                        <span class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-[var(--primary-soft)] text-sm font-black text-[var(--primary-dark)]">2</span>
                        <p class="text-sm leading-7 text-[var(--ink-soft)]">Shipper giao sách theo địa chỉ bạn đã cung cấp, thanh toán COD khi nhận.</p>
                    </div>
                    <div class="flex gap-4 rounded-3xl bg-[var(--paper)] p-4">
                        <span class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-[var(--primary-soft)] text-sm font-black text-[var(--primary-dark)]">3</span>
                        <p class="text-sm leading-7 text-[var(--ink-soft)]">Bạn có thể theo dõi trạng thái trong mục đơn hàng của tôi.</p>
                    </div>
                </div>
            </div>

            <div class="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
                <a href="Default.aspx" class="btn-primary w-full sm:w-auto">Tiếp tục mua sắm</a>
                <a href="Orders.aspx" class="btn-secondary w-full sm:w-auto">Xem đơn hàng</a>
            </div>
        </div>
    </section>
</asp:Content>
