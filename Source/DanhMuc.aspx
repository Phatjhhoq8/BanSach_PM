<%@ Page Title="Danh mục sách - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="DanhMuc.aspx.cs" Inherits="DanhMuc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style>
        .catalog-hero {
            position: relative;
            overflow: hidden;
        }

        .catalog-hero::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, oklch(100% 0 0 / 0.88), oklch(100% 0 0 / 0.72) 42%, oklch(100% 0 0 / 0.35));
        }

        .catalog-hero > * {
            position: relative;
            z-index: 1;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="catalog-hero border-b border-[var(--line)] bg-[var(--surface)]">
        <video autoplay loop muted playsinline poster="img/banner/section_banner_2.jpg" data-motion-video class="absolute inset-0 h-full w-full object-cover">
            <source src="videos/book.mp4" type="video/mp4" />
        </video>
        <div class="container-page py-12 lg:py-16">
            <p class="eyebrow">Bộ sưu tập</p>
            <div class="mt-4 flex flex-col justify-between gap-6 lg:flex-row lg:items-end">
                <div>
                    <h1 class="text-4xl font-bold sm:text-5xl"><asp:Literal ID="litTitle" runat="server">Tất cả tác phẩm</asp:Literal></h1>
                    <p class="mt-4 max-w-2xl text-[var(--ink-soft)]">Duyệt sách theo thể loại, mức giá và từ khóa. Giao diện ưu tiên bìa sách và thông tin mua nhanh.</p>
                </div>
                <div class="rounded-3xl bg-[var(--paper)] px-5 py-4 text-sm font-bold text-[var(--ink-soft)]">
                    <asp:Literal ID="litResultSummary" runat="server">Đang tải dữ liệu...</asp:Literal>
                </div>
            </div>
        </div>
    </section>

    <section class="container-page py-10 lg:py-14">
        <div class="grid gap-8 lg:grid-cols-[17rem_1fr]">
            <aside class="space-y-5 lg:sticky lg:top-28 lg:self-start">
                <details class="surface-panel p-5" open data-catalog-filter>
                    <summary class="cursor-pointer list-none text-sm font-black uppercase tracking-[0.12em] text-[var(--primary-dark)]">Danh mục</summary>
                    <ul class="mt-5 space-y-2 text-sm font-bold">
                        <li><a href='<%= GetAllProductsUrl() %>' class='<%= IsAllCategoryActive() ? "flex rounded-2xl border border-[var(--primary)] bg-white px-4 py-3 text-[var(--primary-dark)] shadow-sm" : "flex rounded-2xl px-4 py-3 text-[var(--ink-soft)] hover:bg-[var(--paper-soft)] hover:text-[var(--primary-dark)]" %>'>Tất cả sản phẩm</a></li>
                        <asp:Repeater ID="rptCategories" runat="server">
                            <ItemTemplate>
                                <li><a href='<%# GetCategoryUrl(Eval("MaDM")) %>' class='<%# GetCategoryLinkClass(Eval("MaDM")) %>'><%# Eval("TenDM") %></a></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </details>

                <details class="surface-panel p-5" open data-catalog-filter>
                    <summary class="cursor-pointer list-none text-sm font-black uppercase tracking-[0.12em] text-[var(--primary-dark)]">Khoảng giá</summary>
                    <div class="mt-5 space-y-2 text-sm font-bold">
                        <a href='<%= GetPriceUrl("") %>' class='<%= GetPriceFilterClass("") %>'>Tất cả mức giá</a>
                        <a href='<%= GetPriceUrl("under100") %>' class='<%= GetPriceFilterClass("under100") %>'>Dưới 100.000đ</a>
                        <a href='<%= GetPriceUrl("100-200") %>' class='<%= GetPriceFilterClass("100-200") %>'>100.000đ - 200.000đ</a>
                        <a href='<%= GetPriceUrl("200-500") %>' class='<%= GetPriceFilterClass("200-500") %>'>200.000đ - 500.000đ</a>
                        <a href='<%= GetPriceUrl("over500") %>' class='<%= GetPriceFilterClass("over500") %>'>Trên 500.000đ</a>
                    </div>
                </details>
            </aside>

            <div class="min-w-0">
                <div class="surface-panel mb-5 flex flex-col gap-4 p-4 md:flex-row md:items-center md:justify-between">
                    <div class="flex flex-1 flex-col gap-3 sm:flex-row">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control rounded-full text-sm" placeholder="Tìm tên sách hoặc tác giả..."></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Tìm" OnClick="btnSearch_Click" CssClass="btn-primary min-w-24 text-sm" />
                    </div>
                    <div class="flex flex-col gap-3 sm:flex-row sm:items-center">
                        <span class="text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Sắp xếp</span>
                        <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-control min-w-44 rounded-full text-sm" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                            <asp:ListItem Value="new">Mới nhất</asp:ListItem>
                            <asp:ListItem Value="price_asc">Giá tăng dần</asp:ListItem>
                            <asp:ListItem Value="price_desc">Giá giảm dần</asp:ListItem>
                            <asp:ListItem Value="name_asc">Tên A-Z</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <asp:Literal ID="litActiveFilters" runat="server"></asp:Literal>

                <div class="grid grid-cols-2 gap-x-4 gap-y-10 sm:grid-cols-3 xl:grid-cols-4 xl:gap-x-7">
                    <asp:Repeater ID="rptSach" runat="server">
                        <ItemTemplate>
                            <article class="book-card group">
                                <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="book-cover aspect-[3/4]">
                                    <img src='<%# Eval("DisplayImageUrl") %>' onerror="this.src='https://placehold.co/400x550/f8f1e3/3b3028?text=Book';" alt='<%# Eval("TenSP") %>' class="h-full w-full" loading="lazy" />
                                    <span class='<%# string.IsNullOrEmpty(Eval("DiscountText") as string) ? "hidden" : "badge-sale absolute right-3 top-3" %>'><%# Eval("DiscountText") %></span>
                                </a>
                                <div class="mt-4 flex flex-1 flex-col">
                                    <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="line-clamp-2 text-sm font-black leading-6 text-[var(--ink)] hover:text-[var(--primary-dark)]"><%# Eval("TenSP") %></a>
                                    <p class="mt-1 line-clamp-1 text-xs font-semibold text-[var(--muted)]"><%# Eval("TacGia") %></p>
                                    <div class="mt-3 flex flex-wrap items-center gap-2">
                                        <span class="price-text text-sm"><%# Eval("GiaText") %></span>
                                        <span class='<%# string.IsNullOrEmpty(Eval("GiaGocText") as string) ? "hidden" : "text-xs text-[var(--muted)] line-through" %>'><%# Eval("GiaGocText") %></span>
                                    </div>
                                    <div class="mt-4 flex gap-2">
                                        <button type="button" onclick="addToCart(<%# Eval("MaSP") %>, this)" class="product-card-action touch-target flex-1 rounded-full border border-[var(--line)] px-4 py-2 text-xs font-black hover:border-[var(--primary)] hover:bg-[var(--primary-soft)]">Thêm vào giỏ</button>
                                        <button type="button" onclick="toggleWishlist(<%# Eval("MaSP") %>, this)" class="wishlist-action touch-target rounded-full border border-[var(--line)] px-4 py-2 text-sm font-black hover:border-rose-300 hover:bg-rose-50" aria-label='<%# Eval("WishlistButtonLabel") %>' aria-pressed='<%# Eval("WishlistPressed") %>'><%# Eval("WishlistSymbol") %></button>
                                    </div>
                                </div>
                            </article>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <asp:Label ID="LabelNoData" runat="server" Text="Không tìm thấy sách phù hợp. Hãy thử từ khóa hoặc bộ lọc khác." Visible="false" CssClass="block rounded-3xl border border-dashed border-[var(--line)] bg-[var(--surface)] p-10 text-center text-[var(--muted)]" />
                <asp:PlaceHolder ID="phPagination" runat="server" Visible="false">
                    <nav class="mt-12 flex flex-wrap items-center justify-center gap-2" aria-label="Phân trang sản phẩm">
                        <a href='<%= GetPrevPageUrl() %>' class='<%= HasPrevPage() ? "flex h-10 items-center justify-center rounded-full border border-[var(--line)] bg-[var(--surface)] px-4 text-sm font-black text-[var(--ink-soft)] hover:border-[var(--primary)] hover:text-[var(--primary-dark)]" : "pointer-events-none flex h-10 items-center justify-center rounded-full border border-[var(--line)] bg-[var(--paper)] px-4 text-sm font-black text-[var(--muted)] opacity-50" %>'>Trước</a>
                        <asp:Repeater ID="rptPagination" runat="server">
                            <ItemTemplate>
                                <a href='<%# BuildPageUrl(Container.DataItem) %>' class='<%# GetPageLinkClass(Container.DataItem) %>'><%# Container.DataItem %></a>
                            </ItemTemplate>
                        </asp:Repeater>
                        <a href='<%= GetNextPageUrl() %>' class='<%= HasNextPage() ? "flex h-10 items-center justify-center rounded-full border border-[var(--line)] bg-[var(--surface)] px-4 text-sm font-black text-[var(--ink-soft)] hover:border-[var(--primary)] hover:text-[var(--primary-dark)]" : "pointer-events-none flex h-10 items-center justify-center rounded-full border border-[var(--line)] bg-[var(--paper)] px-4 text-sm font-black text-[var(--muted)] opacity-50" %>'>Sau</a>
                    </nav>
                </asp:PlaceHolder>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" Runat="Server">
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            if (window.matchMedia && window.matchMedia('(max-width: 1023px)').matches) {
                document.querySelectorAll('[data-catalog-filter]').forEach(panel => panel.removeAttribute('open'));
            }
        });

        function addToCart(maSP, btn) {
            const originalText = btn.innerText;
            btn.disabled = true;
            btn.innerText = 'Đang thêm...';

            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('maSP', maSP);

            fetch('CartHandler.ashx', { method: 'POST', body: formData })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const countEl = document.getElementById('cartCount');
                        if (countEl) countEl.innerText = data.cartCount;
                        btn.innerText = 'Đã thêm';
                        AppUX.showToast(data.message || 'Đã thêm sách vào giỏ hàng.', 'success');
                        setTimeout(() => { btn.innerText = originalText; btn.disabled = false; }, 1200);
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

        function toggleWishlist(maSP, btn) {
            const originalText = btn.innerText;
            btn.disabled = true;
            const formData = new URLSearchParams();
            formData.append('action', 'toggle');
            formData.append('maSP', maSP);
            fetch('WishlistHandler.ashx', { method: 'POST', body: formData })
                .then(response => response.json())
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
