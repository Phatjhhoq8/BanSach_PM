<%@ Page Title="Chi tiết đơn hàng - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="OrderDetail.aspx.cs" Inherits="OrderDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-10 lg:py-16">
        <div class="mb-8 flex flex-col justify-between gap-4 md:flex-row md:items-end">
            <div>
                <p class="eyebrow">Chi tiết đơn hàng</p>
                <h1 class="mt-3 text-4xl font-bold sm:text-5xl">Đơn hàng #<asp:Literal ID="litOrderId" runat="server"></asp:Literal></h1>
            </div>
            <a href="Orders.aspx" class="btn-secondary self-start md:self-auto">Quay lại danh sách</a>
        </div>

        <div class="grid gap-8 lg:grid-cols-[1fr_22rem]">
            <section class="surface-panel overflow-hidden">
                <div class="border-b border-[var(--line)] p-6">
                    <h2 class="text-2xl font-bold">Sách trong đơn</h2>
                </div>
                <div class="divide-y divide-[var(--line)]">
                    <asp:Repeater ID="rptItems" runat="server">
                        <ItemTemplate>
                            <div class="flex gap-4 p-5 sm:items-center sm:p-6">
                                <div class="book-cover aspect-[3/4] w-16 flex-shrink-0 rounded-xl p-1.5">
                                    <img src='<%# Eval("HinhAnh") %>' onerror="this.src='https://placehold.co/400x550/f8f1e3/3b3028?text=Book';" alt='<%# Eval("TenSP") %>' class="h-full w-full" />
                                </div>
                                <div class="min-w-0 flex-1">
                                    <h3 class="line-clamp-2 font-black"><%# Eval("TenSP") %></h3>
                                    <p class="mt-1 text-sm text-[var(--muted)]">Số lượng: <%# Eval("SoLuong") %> x <%# Eval("DonGia", "{0:N0}đ") %></p>
                                </div>
                                <div class="price-text text-sm"><%# Eval("ThanhTien", "{0:N0}đ") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </section>

            <aside class="surface-panel p-6 sm:p-8">
                <h2 class="text-2xl font-bold">Thông tin đơn</h2>
                <dl class="mt-6 space-y-4 text-sm">
                    <div>
                        <dt class="font-black uppercase tracking-[0.12em] text-[var(--muted)]">Trạng thái</dt>
                        <dd class="mt-2"><span id="statusPill" runat="server" class="status-pill"><asp:Literal ID="litStatus" runat="server"></asp:Literal></span></dd>
                    </div>
                    <div>
                        <dt class="font-black uppercase tracking-[0.12em] text-[var(--muted)]">Ngày đặt</dt>
                        <dd class="mt-1 font-bold"><asp:Literal ID="litDate" runat="server"></asp:Literal></dd>
                    </div>
                    <div>
                        <dt class="font-black uppercase tracking-[0.12em] text-[var(--muted)]">Tổng tiền</dt>
                        <dd class="mt-1 price-text text-xl"><asp:Literal ID="litTotal" runat="server"></asp:Literal></dd>
                    </div>
                    <div>
                        <dt class="font-black uppercase tracking-[0.12em] text-[var(--muted)]">Thanh toán</dt>
                        <dd class="mt-1 font-bold"><asp:Literal ID="litPayment" runat="server"></asp:Literal></dd>
                    </div>
                    <div>
                        <dt class="font-black uppercase tracking-[0.12em] text-[var(--muted)]">Giao hàng</dt>
                        <dd class="mt-1 leading-7 text-[var(--ink-soft)]"><asp:Literal ID="litShippingInfo" runat="server"></asp:Literal></dd>
                    </div>
                </dl>
            </aside>
        </div>
    </section>
</asp:Content>
