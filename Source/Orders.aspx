<%@ Page Title="Đơn hàng của tôi - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-10 lg:py-16">
        <div class="mb-10 flex flex-col justify-between gap-4 md:flex-row md:items-end">
            <div>
                <p class="eyebrow">Tài khoản</p>
                <h1 class="mt-3 text-4xl font-bold sm:text-5xl">Lịch sử đơn hàng</h1>
            </div>
            <a href="Account.aspx" class="btn-secondary self-start md:self-auto">Quay lại tài khoản</a>
        </div>

        <div class="space-y-5">
            <asp:Repeater ID="rptOrders" runat="server">
                <ItemTemplate>
                    <article class="surface-panel overflow-hidden">
                        <div class="flex flex-col justify-between gap-5 border-b border-[var(--line)] p-5 sm:p-6 lg:flex-row lg:items-center">
                            <div class="grid gap-4 sm:grid-cols-3 lg:flex lg:gap-10">
                                <div>
                                    <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Mã đơn</p>
                                    <p class="mt-1 text-lg font-black">#<%# Eval("MaDH") %></p>
                                </div>
                                <div>
                                    <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Ngày đặt</p>
                                    <p class="mt-1 text-sm font-bold text-[var(--ink-soft)]"><%# Eval("NgayDat", "{0:dd/MM/yyyy HH:mm}") %></p>
                                </div>
                                <div>
                                    <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Tổng tiền</p>
                                    <p class="mt-1 price-text text-sm"><%# Eval("TongTien", "{0:N0}đ") %></p>
                                </div>
                            </div>
                            <span class="status-pill <%# GetStatusClass(Eval("TrangThai")) %>"><%# GetStatusText(Eval("TrangThai")) %></span>
                        </div>
                        <div class="space-y-4 bg-[var(--paper)] p-5 sm:p-6">
                            <asp:Repeater ID="rptOrderDetails" runat="server" DataSource='<%# Eval("Details") %>'>
                                <ItemTemplate>
                                    <div class="flex items-center gap-4">
                                        <div class="book-cover aspect-[3/4] w-14 flex-shrink-0 rounded-xl p-1.5">
                                            <img src='<%# Eval("HinhAnh") %>' onerror="this.src='https://placehold.co/400x550/f8f1e3/3b3028?text=Book';" alt='<%# Eval("TenSP") %>' class="h-full w-full" />
                                        </div>
                                        <div class="min-w-0 flex-1">
                                            <h4 class="line-clamp-1 text-sm font-black"><%# Eval("TenSP") %></h4>
                                            <p class="mt-1 text-xs text-[var(--muted)]">Số lượng: <%# Eval("SoLuong") %> x <%# Eval("DonGia", "{0:N0}đ") %></p>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div class="flex justify-end pt-2">
                                <a href="OrderDetail.aspx?id=<%# Eval("MaDH") %>" class="text-sm font-black text-[var(--primary-dark)] hover:underline">Xem chi tiết đơn hàng</a>
                            </div>
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>

            <asp:PlaceHolder ID="phNoOrders" runat="server" Visible="false">
                <div class="surface-panel py-20 text-center">
                    <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-[var(--paper)] text-[var(--muted)]">
                        <svg class="h-10 w-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path></svg>
                    </div>
                    <h2 class="mt-6 text-2xl font-bold">Bạn chưa có đơn hàng nào</h2>
                    <p class="mt-2 text-[var(--muted)]">Khi đặt sách thành công, đơn hàng sẽ xuất hiện ở đây.</p>
                    <a href="DanhMuc.aspx" class="btn-primary mt-7">Khám phá sách ngay</a>
                </div>
            </asp:PlaceHolder>
        </div>
    </section>
</asp:Content>
