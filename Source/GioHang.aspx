<%@ Page Title="Giỏ hàng - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="GioHang.aspx.cs" Inherits="GioHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-10 lg:py-16">
        <div class="mb-10 flex flex-col justify-between gap-5 md:flex-row md:items-end">
            <div>
                <p class="eyebrow">Giỏ hàng</p>
                <h1 class="mt-3 text-4xl font-bold sm:text-5xl">Những cuốn sách bạn đã chọn</h1>
            </div>
            <span class="self-start rounded-full bg-[var(--surface)] px-5 py-3 text-sm font-black text-[var(--ink-soft)]"><span id="cartPageCount"><asp:Literal ID="litCartCount" runat="server">0</asp:Literal></span> sản phẩm</span>
        </div>

        <div class="grid gap-8 lg:grid-cols-[1fr_24rem]">
            <div id="cartItemsWrap" class="space-y-4">
                <asp:Repeater ID="rptCartItems" runat="server">
                    <ItemTemplate>
                        <article class="surface-panel flex flex-col gap-5 p-4 sm:flex-row sm:items-center sm:p-5" data-cart-item data-product-id='<%# Eval("MaSP") %>'>
                            <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="book-cover aspect-[3/4] w-28 flex-shrink-0 sm:w-24">
                                <img src='<%# Eval("HinhAnh") %>' onerror="this.src='https://placehold.co/400x550/f8f1e3/3b3028?text=Book';" alt='<%# Eval("TenSP") %>' class="h-full w-full" loading="lazy" />
                            </a>
                            <div class="min-w-0 flex-1">
                                <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="line-clamp-2 text-lg font-black text-[var(--ink)] hover:text-[var(--primary-dark)]"><%# Eval("TenSP") %></a>
                                <p class="mt-1 text-sm font-semibold text-[var(--muted)]"><%# Eval("TacGia") %></p>
                                <div class="mt-4 flex flex-wrap items-center gap-4">
                                    <div class="flex items-center rounded-full border border-[var(--line)] bg-[var(--surface)] p-1">
                                        <button type="button" onclick="updateQty(<%# Eval("MaSP") %>, -1, this)" class="flex h-9 w-9 items-center justify-center rounded-full hover:bg-[var(--paper-soft)]" aria-label="Giảm số lượng">-</button>
                                        <span class="w-10 text-center text-sm font-black" data-qty><%# Eval("SoLuong") %></span>
                                        <button type="button" onclick="updateQty(<%# Eval("MaSP") %>, 1, this)" class="flex h-9 w-9 items-center justify-center rounded-full hover:bg-[var(--paper-soft)]" aria-label="Tăng số lượng">+</button>
                                    </div>
                                     <div class="price-text text-lg" data-line-total><%# Eval("ThanhTien", "{0:N0}đ") %></div>
                                 </div>
                             </div>
                             <button type="button" onclick="removeItem(<%# Eval("MaSP") %>, this)" class="touch-target self-start rounded-full border border-[var(--line)] px-4 py-2 text-xs font-black text-[var(--danger)] hover:bg-red-50 sm:self-center">Xóa</button>
                        </article>
                    </ItemTemplate>
                </asp:Repeater>

                    <div id="emptyCartState" runat="server" class="surface-panel py-20 text-center hidden">
                        <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-[var(--paper)] text-[var(--muted)]">
                            <svg class="h-10 w-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                        </div>
                        <h2 class="mt-6 text-2xl font-bold">Giỏ hàng đang trống</h2>
                        <p class="mt-2 text-[var(--muted)]">Hãy chọn vài cuốn sách để bắt đầu đơn hàng.</p>
                        <a href="DanhMuc.aspx" class="btn-primary mt-7">Khám phá sách</a>
                    </div>
            </div>

            <aside id="cartSummaryAside" runat="server">
                <div class="surface-panel sticky top-28 p-6 sm:p-8">
                    <h2 class="text-2xl font-bold">Tóm tắt giỏ hàng</h2>
                    <div class="mt-6 space-y-4 border-b border-[var(--line)] pb-6 text-sm">
                        <div class="flex justify-between gap-4">
                            <span class="text-[var(--muted)]">Tạm tính</span>
                            <span id="cartSubtotalValue" class="font-black"><asp:Literal ID="litSubtotal" runat="server">0đ</asp:Literal></span>
                        </div>
                        <div class="flex justify-between gap-4">
                            <span class="text-[var(--muted)]">Phí vận chuyển</span>
                            <span class="font-black">Tính ở bước thanh toán</span>
                        </div>
                    </div>
                    <div class="mt-6 flex justify-between gap-4 text-xl font-black">
                        <span>Tổng tiền</span>
                        <span id="cartTotalValue" class="price-text"><asp:Literal ID="litTotal" runat="server">0đ</asp:Literal></span>
                    </div>
                    <a id="checkoutLink" href="Checkout.aspx" class="btn-primary mt-8 w-full py-4">Tiến hành thanh toán</a>
                    <p class="mt-5 text-center text-xs font-bold uppercase tracking-[0.12em] text-[var(--muted)]">Thanh toán COD an toàn</p>
                </div>
            </aside>
        </div>
    </section>

    <script>
        function setRowLoading(row, isLoading) {
            if (!row) return;
            row.querySelectorAll('button').forEach(button => button.disabled = isLoading);
        }

        function updateCartSummary(data) {
            const pageCount = document.getElementById('cartPageCount');
            const headerCount = document.getElementById('cartCount');
            const subtotal = document.getElementById('cartSubtotalValue');
            const total = document.getElementById('cartTotalValue');
            if (pageCount) pageCount.innerText = data.cartCount || 0;
            if (headerCount) headerCount.innerText = data.cartCount || 0;
            if (subtotal && data.subtotalText) subtotal.innerText = data.subtotalText;
            if (total && data.subtotalText) total.innerText = data.subtotalText;

            if (!data.cartCount) {
                const empty = document.getElementById('emptyCartState');
                const summary = document.getElementById('cartSummaryAside');
                if (empty) empty.classList.remove('hidden');
                if (summary) summary.classList.add('hidden');
            }
        }

        function updateQty(maSP, delta, btn) {
            const row = btn.closest('[data-cart-item]');
            const qtyEl = row ? row.querySelector('[data-qty]') : null;
            const currentQty = qtyEl ? parseInt(qtyEl.innerText, 10) : 1;
            const newQty = currentQty + delta;
            if (newQty < 1) {
                removeItem(maSP, btn);
                return;
            }

            setRowLoading(row, true);
            fetch('CartHandler.ashx?action=update&maSP=' + maSP + '&qty=' + newQty)
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        if (qtyEl) qtyEl.innerText = newQty;
                        const lineTotal = row ? row.querySelector('[data-line-total]') : null;
                        if (lineTotal && data.itemTotalText) lineTotal.innerText = data.itemTotalText;
                        updateCartSummary(data);
                        AppUX.showToast(data.message || 'Đã cập nhật giỏ hàng.', 'success');
                    } else {
                        AppUX.showToast(data.message || 'Không thể cập nhật giỏ hàng.', 'error');
                    }
                    setRowLoading(row, false);
                })
                .catch(() => {
                    setRowLoading(row, false);
                    AppUX.showToast('Đã xảy ra lỗi mạng khi cập nhật giỏ hàng.', 'error');
                });
        }

        function removeItem(maSP, btn) {
            AppUX.confirm('Xóa sản phẩm này khỏi giỏ hàng?', { okText: 'Xóa sản phẩm', title: 'Xóa khỏi giỏ hàng' }).then(confirmed => {
                if (!confirmed) return;
                const row = btn ? btn.closest('[data-cart-item]') : document.querySelector('[data-product-id="' + maSP + '"]');
                setRowLoading(row, true);
                fetch('CartHandler.ashx?action=remove&maSP=' + maSP)
                    .then(r => r.json())
                    .then(data => {
                        if (data.success) {
                            if (row) row.remove();
                            updateCartSummary(data);
                            AppUX.showToast(data.message || 'Đã xóa sách khỏi giỏ hàng.', 'success');
                        } else {
                            setRowLoading(row, false);
                            AppUX.showToast(data.message || 'Không thể xóa sản phẩm.', 'error');
                        }
                    })
                    .catch(() => {
                        setRowLoading(row, false);
                        AppUX.showToast('Đã xảy ra lỗi mạng khi xóa sản phẩm.', 'error');
                    });
            });
        }
    </script>
</asp:Content>
