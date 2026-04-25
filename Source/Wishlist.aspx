<%@ Page Title="Danh sách yêu thích - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Wishlist.aspx.cs" Inherits="Wishlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-10 lg:py-16">
        <div class="mb-10 flex flex-col justify-between gap-4 md:flex-row md:items-end">
            <div>
                <p class="eyebrow">Tài khoản</p>
                <h1 class="mt-3 text-4xl font-bold sm:text-5xl">Danh sách yêu thích</h1>
                <p class="mt-4 max-w-2xl text-[var(--ink-soft)]">Lưu lại những cuốn sách muốn theo dõi và thêm nhanh vào giỏ khi sẵn sàng đặt mua.</p>
            </div>
            <a href="DanhMuc.aspx?sort=new" class="btn-secondary self-start md:self-auto">Xem sách mới</a>
        </div>

        <div id="emptyWishlistState" runat="server" class="surface-panel py-20 text-center hidden">
            <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-[var(--paper)] text-rose-600">
                <span class="text-4xl">♡</span>
            </div>
            <h2 class="mt-6 text-2xl font-bold">Bạn chưa lưu sách yêu thích</h2>
            <p class="mx-auto mt-2 max-w-xl text-[var(--muted)]">Quay lại danh mục, bấm biểu tượng trái tim ở cuốn sách bạn muốn theo dõi.</p>
            <div class="mt-7 flex flex-col justify-center gap-3 sm:flex-row">
                <a href="DanhMuc.aspx" class="btn-primary">Khám phá sách</a>
                <a href="DanhMuc.aspx?sort=new" class="btn-secondary">Xem sách mới</a>
            </div>
        </div>

        <div id="wishlistGrid" runat="server" class="grid grid-cols-2 gap-x-4 gap-y-10 sm:grid-cols-3 lg:grid-cols-5 lg:gap-x-7">
            <asp:Repeater ID="rptWishlist" runat="server">
                <ItemTemplate>
                    <article class="book-card group" data-wishlist-card data-product-id='<%# Eval("MaSP") %>'>
                        <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="book-cover aspect-[3/4]">
                            <img src='<%# Eval("DisplayImageUrl") %>' onerror="this.src='https://placehold.co/400x550/f8f1e3/3b3028?text=Book';" alt='<%# Eval("TenSP") %>' class="h-full w-full" loading="lazy" />
                        </a>
                        <div class="mt-4 flex flex-1 flex-col">
                            <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="line-clamp-2 text-sm font-black leading-6 text-[var(--ink)] hover:text-[var(--primary-dark)]"><%# Eval("TenSP") %></a>
                            <p class="mt-1 line-clamp-1 text-xs font-semibold text-[var(--muted)]"><%# Eval("TacGia") %></p>
                            <p class="mt-2 text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]"><%# Eval("StockText") %></p>
                            <div class="mt-3 flex flex-wrap items-center gap-2">
                                <span class="price-text text-sm"><%# Eval("GiaHienThiText") %></span>
                                <span class='<%# Eval("OldPriceClass") %>'><%# Eval("GiaGocText") %></span>
                            </div>
                            <div class="mt-4 grid gap-2">
                                <button type="button" onclick="addWishlistItemToCart(<%# Eval("MaSP") %>, this)" class="product-card-action touch-target rounded-full border border-[var(--line)] px-4 py-2 text-xs font-black hover:border-[var(--primary)] hover:bg-[var(--primary-soft)]">Thêm vào giỏ</button>
                                <button type="button" onclick="removeWishlist(<%# Eval("MaSP") %>, this)" class="touch-target rounded-full border border-rose-100 px-4 py-2 text-xs font-black text-rose-600 hover:bg-rose-50">Xóa yêu thích</button>
                            </div>
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>

    <script>
        function updateWishlistEmptyState() {
            const grid = document.getElementById('wishlistGrid');
            const empty = document.getElementById('emptyWishlistState');
            const hasCards = grid && grid.querySelector('[data-wishlist-card]');
            if (!hasCards) {
                if (grid) grid.classList.add('hidden');
                if (empty) empty.classList.remove('hidden');
            }
        }

        function addWishlistItemToCart(maSP, btn) {
            const originalText = btn.innerText;
            btn.disabled = true;
            btn.innerText = 'Đang thêm...';
            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('maSP', maSP);
            fetch('CartHandler.ashx', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        const countEl = document.getElementById('cartCount');
                        if (countEl) countEl.innerText = data.cartCount;
                        AppUX.showToast(data.message || 'Đã thêm sách vào giỏ hàng.', 'success');
                        btn.innerText = 'Đã thêm';
                        setTimeout(() => { btn.innerText = originalText; btn.disabled = false; }, 1100);
                    } else {
                        AppUX.showToast(data.message || 'Không thể thêm sách vào giỏ hàng.', 'error');
                        btn.innerText = originalText;
                        btn.disabled = false;
                    }
                })
                .catch(() => { AppUX.showToast('Đã xảy ra lỗi mạng.', 'error'); btn.innerText = originalText; btn.disabled = false; });
        }

        function removeWishlist(maSP, btn) {
            AppUX.confirm('Xóa sách này khỏi danh sách yêu thích?', { title: 'Xóa yêu thích', okText: 'Xóa' }).then(confirmed => {
                if (!confirmed) return;
                btn.disabled = true;
                const formData = new URLSearchParams();
                formData.append('action', 'remove');
                formData.append('maSP', maSP);
                fetch('WishlistHandler.ashx', { method: 'POST', body: formData })
                    .then(r => r.json())
                    .then(data => {
                        if (data.success) {
                            const card = btn.closest('[data-wishlist-card]');
                            if (card) card.remove();
                            updateWishlistEmptyState();
                            AppUX.showToast(data.message || 'Đã xóa khỏi danh sách yêu thích.', 'success');
                        } else {
                            AppUX.showToast(data.message || 'Không thể xóa yêu thích.', 'error');
                            btn.disabled = false;
                        }
                    })
                    .catch(() => { AppUX.showToast('Đã xảy ra lỗi mạng.', 'error'); btn.disabled = false; });
            });
        }
    </script>
</asp:Content>
