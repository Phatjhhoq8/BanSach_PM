<%@ Page Title="Chi tiết sách - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="ChiTiet.aspx.cs" Inherits="ChiTiet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style>
        .detail-cover {
            background: oklch(100% 0 0);
            border: 1px solid var(--line);
            border-radius: 2rem;
            min-height: 32rem;
            box-shadow: var(--shadow-sm);
        }

        .detail-cover-frame {
            align-items: center;
            background: oklch(100% 0 0);
            border-radius: 1rem;
            display: inline-flex;
            justify-content: center;
            max-width: 100%;
            padding: 1rem;
        }

        .book-main-image {
            background-position: center;
            background-repeat: no-repeat;
            background-size: contain;
            height: min(72vw, 32rem);
            max-height: 34rem;
            width: min(74vw, 23rem);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:HiddenField ID="hdnMaSP" runat="server" />
    <section class="container-page py-8 lg:py-12">
        <nav class="flex flex-wrap items-center gap-2 text-sm font-bold text-[var(--muted)]">
            <a href="Default.aspx" class="hover:text-[var(--primary-dark)]">Trang chủ</a>
            <span>/</span>
            <a href="DanhMuc.aspx" class="hover:text-[var(--primary-dark)]">Danh mục</a>
            <span>/</span>
            <span class="line-clamp-1 max-w-xl text-[var(--ink-soft)]"><asp:Literal ID="litBreadcrumb" runat="server">Chi tiết sản phẩm</asp:Literal></span>
        </nav>

        <div class="mt-8 grid gap-10 lg:grid-cols-[0.92fr_1.08fr] lg:items-start">
            <div class="detail-cover flex items-center justify-center p-8">
                <div class="detail-cover-frame">
                    <div class="book-main-image" id="bookFront" runat="server">
                        <div class="sr-only"><asp:Literal ID="litTitleCover" runat="server"></asp:Literal><asp:Literal ID="litTitleCoverShine" runat="server"></asp:Literal></div>
                    </div>
                </div>
            </div>

            <div class="surface-panel p-6 sm:p-8 lg:p-10">
                <p class="eyebrow">Thông tin sách</p>
                <h1 class="mt-4 text-3xl font-bold leading-tight sm:text-4xl lg:text-5xl"><asp:Literal ID="litTenSP" runat="server"></asp:Literal></h1>
                <p class="mt-4 text-lg font-bold text-[var(--ink-soft)]">Tác giả: <span class="text-[var(--primary-dark)]"><asp:Literal ID="litTacGia" runat="server"></asp:Literal></span></p>

                <div class="my-8 flex flex-wrap items-center gap-4 border-y border-[var(--line)] py-6">
                    <div class="price-text text-3xl"><asp:Literal ID="litGia" runat="server"></asp:Literal></div>
                    <div class="text-lg text-[var(--muted)] line-through" id="oldPriceContainer" runat="server"><asp:Literal ID="litGiaGoc" runat="server"></asp:Literal></div>
                    <span class="badge-sale" id="discountBadge" runat="server"><asp:Literal ID="litDiscount" runat="server"></asp:Literal></span>
                </div>

                <p class="max-w-3xl text-base leading-8 text-[var(--ink-soft)]"><asp:Literal ID="litMoTa" runat="server"></asp:Literal></p>

                <div class="mt-8 grid gap-4 sm:grid-cols-2">
                    <div class="rounded-3xl bg-[var(--paper)] p-5">
                        <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Tình trạng</p>
                        <p class="mt-2 font-extrabold text-[var(--ink)]"><asp:Literal ID="litStock" runat="server">Đang cập nhật</asp:Literal></p>
                    </div>
                    <div class="rounded-3xl bg-[var(--paper)] p-5">
                        <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Đánh giá</p>
                        <p class="mt-2 font-extrabold text-[var(--ink)]"><asp:Literal ID="litRating" runat="server">Chưa có đánh giá</asp:Literal></p>
                    </div>
                </div>

                <asp:PlaceHolder ID="phAvailable" runat="server">
                    <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                        <div class="flex h-14 w-full items-center justify-between rounded-full border border-[var(--line)] bg-[var(--surface)] px-2 sm:w-36">
                            <button type="button" onclick="changeQty(-1)" class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-[var(--paper-soft)]" aria-label="Giảm số lượng">-</button>
                            <input id="qtyInput" type="number" min="1" max="<%= ProductStock %>" value="1" class="w-12 bg-transparent text-center font-black outline-none" />
                            <button type="button" onclick="changeQty(1)" class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-[var(--paper-soft)]" aria-label="Tăng số lượng">+</button>
                        </div>
                        <button type="button" onclick="addToCart(this, false)" class="btn-secondary flex-1 py-4 text-base">Thêm vào giỏ</button>
                        <button type="button" onclick="buyNow(this)" class="btn-primary flex-1 py-4 text-base">Mua ngay</button>
                        <button id="btnWishlist" runat="server" type="button" onclick="toggleWishlist(this)" class="rounded-full border border-[var(--line)] px-6 py-4 text-base font-black text-rose-600 hover:border-rose-300 hover:bg-rose-50" aria-label="Thêm vào yêu thích" aria-pressed="false">♡</button>
                    </div>
                    <p class="mt-3 text-sm font-bold text-[var(--muted)]"><asp:Literal ID="litStockHint" runat="server"></asp:Literal></p>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="phOutOfStock" runat="server" Visible="false">
                    <div class="mt-8 rounded-3xl border border-[var(--line)] bg-[var(--paper)] p-5 font-bold text-[var(--muted)]">Sách này đang tạm hết hàng, vui lòng quay lại sau.</div>
                </asp:PlaceHolder>
            </div>
        </div>

        <div class="mt-10 grid grid-cols-2 gap-4 md:grid-cols-4">
            <div class="surface-panel p-5 text-center">
                <span class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Loại bìa</span>
                <p class="mt-2 font-extrabold"><asp:Literal ID="litCoverType" runat="server">Đang cập nhật</asp:Literal></p>
            </div>
            <div class="surface-panel p-5 text-center">
                <span class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Nhà cung cấp</span>
                <p class="mt-2 font-extrabold"><asp:Literal ID="litSupplier" runat="server">Fahasa</asp:Literal></p>
            </div>
            <div class="surface-panel p-5 text-center">
                <span class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Nhà xuất bản</span>
                <p class="mt-2 font-extrabold"><asp:Literal ID="litPublisher" runat="server">Đang cập nhật</asp:Literal></p>
            </div>
            <div class="surface-panel p-5 text-center">
                <span class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Thanh toán</span>
                <p class="mt-2 font-extrabold">COD</p>
            </div>
        </div>

        <div class="mt-10 grid gap-4 md:grid-cols-3">
            <div class="surface-panel p-5">
                <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Giao hàng</p>
                <p class="mt-2 text-sm font-bold leading-7 text-[var(--ink-soft)]">COD toàn quốc, phí vận chuyển hiển thị ở bước thanh toán.</p>
            </div>
            <div class="surface-panel p-5">
                <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Hỗ trợ</p>
                <p class="mt-2 text-sm font-bold leading-7 text-[var(--ink-soft)]">Có thể theo dõi trạng thái đơn và liên hệ nhà sách sau khi đặt.</p>
            </div>
            <div class="surface-panel p-5">
                <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Đổi trả</p>
                <p class="mt-2 text-sm font-bold leading-7 text-[var(--ink-soft)]">Hỗ trợ xử lý khi sách lỗi in ấn hoặc giao sai sản phẩm.</p>
            </div>
        </div>

        <asp:PlaceHolder ID="phRelated" runat="server" Visible="false">
            <section class="mt-14">
                <div class="mb-7 flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
                    <div>
                        <p class="eyebrow">Gợi ý tiếp theo</p>
                        <h2 class="mt-2 text-3xl font-bold">Có thể bạn cũng thích</h2>
                    </div>
                    <a href="DanhMuc.aspx" class="btn-secondary self-start sm:self-auto">Xem thêm sách</a>
                </div>
                <div class="grid grid-cols-2 gap-x-4 gap-y-10 sm:grid-cols-3 lg:grid-cols-5 lg:gap-x-7">
                    <asp:Repeater ID="rptRelated" runat="server">
                        <ItemTemplate>
                            <article class="book-card group">
                                <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="book-cover aspect-[3/4]">
                                    <img src='<%# Eval("DisplayImageUrl") %>' onerror="this.src='https://placehold.co/400x550/f8f1e3/3b3028?text=Book';" alt='<%# Eval("TenSP") %>' class="h-full w-full" loading="lazy" />
                                </a>
                                <div class="mt-4">
                                    <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="line-clamp-2 text-sm font-black leading-6 text-[var(--ink)] hover:text-[var(--primary-dark)]"><%# Eval("TenSP") %></a>
                                    <p class="mt-1 line-clamp-1 text-xs font-semibold text-[var(--muted)]"><%# Eval("TacGia") %></p>
                                    <p class="price-text mt-3 text-sm"><%# Eval("GiaText") %></p>
                                </div>
                            </article>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </section>
        </asp:PlaceHolder>
    </section>

    <script>
        function changeQty(delta) {
            const input = document.getElementById('qtyInput');
            if (!input) return;
            const current = parseInt(input.value || '1', 10);
            const max = parseInt(input.getAttribute('max') || '1', 10);
            const next = Math.min(max, Math.max(1, current + delta));
            input.value = next;
            if (delta > 0 && next === current && max > 0) {
                AppUX.showToast('Chỉ còn ' + max + ' cuốn trong kho.', 'info');
            }
        }

        function buyNow(btn) {
            addToCart(btn, true);
        }

        function addToCart(btn, goCheckout) {
            const id = document.getElementById('<%= hdnMaSP.ClientID %>').value;
            const qtyInput = document.getElementById('qtyInput');
            const max = parseInt(qtyInput ? qtyInput.getAttribute('max') || '1' : '1', 10);
            const qty = Math.min(max, Math.max(1, parseInt(qtyInput ? qtyInput.value || '1' : '1', 10)));
            const originalText = btn.innerText;

            btn.disabled = true;
            btn.innerText = goCheckout ? 'Đang chuyển...' : 'Đang thêm...';

            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('maSP', id);
            formData.append('qty', qty);

            fetch('CartHandler.ashx', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        const countEl = document.getElementById('cartCount');
                        if (countEl) countEl.innerText = data.cartCount;
                        AppUX.showToast(data.message || 'Đã thêm sách vào giỏ hàng.', 'success');
                        if (goCheckout) {
                            window.location.href = 'Checkout.aspx';
                            return;
                        }
                        btn.innerText = 'Đã thêm vào giỏ hàng';
                        setTimeout(() => {
                            btn.innerText = originalText;
                            btn.disabled = false;
                        }, 1400);
                    } else if (data.code === 'auth_required') {
                        AppUX.showToast('Đăng nhập để thêm sách vào giỏ hàng.', 'info');
                        setTimeout(() => { window.location.href = 'Login.aspx?ReturnUrl=' + encodeURIComponent(window.location.pathname + window.location.search); }, 500);
                    } else {
                        AppUX.showToast(data.message || 'Không thể thêm sách vào giỏ hàng.', 'error');
                        btn.innerText = originalText;
                        btn.disabled = false;
                    }
                })
                .catch(() => {
                    AppUX.showToast('Đã xảy ra lỗi mạng khi thêm vào giỏ hàng.', 'error');
                    btn.innerText = originalText;
                    btn.disabled = false;
                });
        }

        function toggleWishlist(btn) {
            const id = document.getElementById('<%= hdnMaSP.ClientID %>').value;
            const originalText = btn.innerText;
            btn.disabled = true;
            const formData = new URLSearchParams();
            formData.append('action', 'toggle');
            formData.append('maSP', id);
            fetch('WishlistHandler.ashx', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        btn.innerText = data.code === 'added' ? '♥' : '♡';
                        btn.setAttribute('aria-pressed', data.code === 'added' ? 'true' : 'false');
                        btn.setAttribute('aria-label', data.code === 'added' ? 'Bỏ khỏi yêu thích' : 'Thêm vào yêu thích');
                        AppUX.showToast(data.message || 'Đã cập nhật danh sách yêu thích.', 'success');
                    } else if (data.code === 'auth_required') {
                        AppUX.showToast('Đăng nhập để lưu sách yêu thích.', 'info');
                        setTimeout(() => { window.location.href = 'Login.aspx?ReturnUrl=' + encodeURIComponent(window.location.pathname + window.location.search); }, 500);
                    } else {
                        AppUX.showToast(data.message || 'Không thể xử lý yêu thích.', 'error');
                        btn.innerText = originalText;
                    }
                    btn.disabled = false;
                })
                .catch(() => { AppUX.showToast('Đã xảy ra lỗi mạng.', 'error'); btn.innerText = originalText; btn.disabled = false; });
        }
    </script>
</asp:Content>
