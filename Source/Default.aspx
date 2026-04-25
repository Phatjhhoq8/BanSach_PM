<%@ Page Title="Trang chủ - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="relative mt-4 h-[65vh] min-h-[450px] w-full overflow-hidden rounded-[2rem] border border-[var(--line)] bg-[var(--surface)] shadow-[var(--shadow-md)]">
        <video autoplay loop muted playsinline class="absolute left-1/2 top-1/2 z-0 min-h-full min-w-full max-w-none -translate-x-1/2 -translate-y-1/2 object-cover">
            <source src="videos/cartoon.mp4" type="video/mp4" />
        </video>
        <div class="absolute inset-0 z-10 bg-[radial-gradient(circle_at_18%_28%,oklch(34%_0.14_286_/_0.34),transparent_22%),radial-gradient(circle_at_82%_20%,oklch(32%_0.12_230_/_0.28),transparent_24%),linear-gradient(90deg,oklch(6%_0.01_278_/_0.88),oklch(8%_0.014_278_/_0.54)_46%,oklch(6%_0.012_278_/_0.24))]"></div>
        <div class="absolute inset-0 z-10 opacity-70" style="background-image:radial-gradient(circle at 12% 18%, rgba(255,255,255,0.82) 0 1px, transparent 1.3px),radial-gradient(circle at 71% 24%, rgba(255,255,255,0.74) 0 1px, transparent 1.35px),radial-gradient(circle at 36% 74%, rgba(255,255,255,0.6) 0 1.15px, transparent 1.45px),radial-gradient(circle at 86% 62%, rgba(255,255,255,0.68) 0 0.95px, transparent 1.2px),radial-gradient(circle at 56% 10%, rgba(255,255,255,0.72) 0 0.9px, transparent 1.2px);"></div>
        <div class="container-page relative z-20 flex h-full items-center">
            <div class="max-w-2xl text-[oklch(99%_0.004_78)]">
                <p class="text-xs font-black uppercase tracking-[0.22em] text-[var(--accent)]">The Book Haven</p>
                <h1 class="mt-5 font-heading text-4xl font-bold leading-tight text-[oklch(99%_0.004_78)] sm:text-5xl lg:text-6xl"><asp:Literal ID="litHeroCaption" runat="server"></asp:Literal></h1>
                <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                    <a href="DanhMuc.aspx" class="inline-flex min-h-12 items-center justify-center rounded-full bg-[var(--primary)] px-7 py-3 text-sm font-black text-[oklch(8%_0.01_278)] shadow-[0_18px_42px_oklch(28%_0.13_284_/_0.45)] hover:bg-[var(--accent)]">Khám phá sách</a>
                    <a href="DanhMuc.aspx?sort=new" class="inline-flex min-h-12 items-center justify-center rounded-full border border-[oklch(100%_0_0_/_0.35)] bg-[oklch(16%_0.028_278_/_0.42)] px-7 py-3 text-sm font-black text-[oklch(99%_0.004_78)] hover:bg-[oklch(100%_0_0_/_0.12)]">Xem sách mới</a>
                </div>
                <div class="mt-9 grid max-w-sm grid-cols-2 gap-4 text-sm">
                    <div>
                        <p class="font-heading text-2xl font-bold text-[oklch(99%_0.004_78)]">20+</p>
                        <p class="mt-1 text-[oklch(84%_0.02_272)]">đầu sách gợi ý</p>
                    </div>
                    <div>
                        <p class="font-heading text-2xl font-bold text-[oklch(99%_0.004_78)]">COD</p>
                        <p class="mt-1 text-[oklch(84%_0.02_272)]">thanh toán khi nhận</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="container-page section-space">
        <div class="mb-9 flex flex-col justify-between gap-5 md:flex-row md:items-end">
            <div>
                <p class="eyebrow">Sách mới phát hành</p>
                <h2 class="mt-3 text-3xl font-bold sm:text-4xl">Kệ sách đang được quan tâm</h2>
            </div>
            <a href="DanhMuc.aspx?sort=new" class="btn-secondary self-start md:self-auto">Xem tất cả</a>
        </div>

        <div class="grid grid-cols-2 gap-x-4 gap-y-10 sm:grid-cols-3 lg:grid-cols-5 lg:gap-x-7">
            <asp:Repeater ID="rptSachNoiBat" runat="server">
                <ItemTemplate>
                    <article class="book-card group">
                        <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="book-cover aspect-[3/4]">
                            <img src='<%# Eval("DisplayImageUrl") %>' onerror="this.src='https://placehold.co/400x550/f8f1e3/3b3028?text=Book';" alt='<%# Eval("TenSP") %>' class="h-full w-full" />
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
                                <button type="button" onclick="addToCart(<%# Eval("MaSP") %>, this)" class="flex-1 rounded-full border border-[var(--line)] px-3 py-2 text-xs font-black text-[var(--primary-dark)] hover:border-[var(--primary)] hover:bg-[var(--primary-soft)]">Thêm vào giỏ</button>
                                <button type="button" onclick="toggleWishlist(<%# Eval("MaSP") %>, this)" class="rounded-full border border-[var(--line)] px-3 py-2 text-xs font-black text-rose-600 hover:border-rose-300 hover:bg-rose-50">♡</button>
                            </div>
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:Label ID="LabelNoData" runat="server" Text="Chưa có dữ liệu sách trong hệ thống." Visible="false" CssClass="mt-10 block rounded-3xl border border-dashed border-[var(--line)] bg-[var(--surface)] p-8 text-center text-[var(--muted)]" />
    </section>

    <section class="container-page pb-16 lg:pb-24">
        <div class="grid gap-5 md:grid-cols-4">
            <a href="DanhMuc.aspx" class="surface-panel p-6 hover:-translate-y-1 hover:shadow-[var(--shadow-md)]">
                <p class="eyebrow">Tổng hợp</p>
                <h3 class="mt-3 font-sans text-xl font-black">Tất cả sách</h3>
            </a>
            <a href="DanhMuc.aspx?sort=price_asc" class="surface-panel p-6 hover:-translate-y-1 hover:shadow-[var(--shadow-md)]">
                <p class="eyebrow">Ưu đãi</p>
                <h3 class="mt-3 font-sans text-xl font-black">Giá tốt</h3>
            </a>
            <a href="DanhMuc.aspx?q=kinh%20tế" class="surface-panel p-6 hover:-translate-y-1 hover:shadow-[var(--shadow-md)]">
                <p class="eyebrow">Chủ đề</p>
                <h3 class="mt-3 font-sans text-xl font-black">Kinh tế</h3>
            </a>
            <a href="DanhMuc.aspx?q=thiếu%20nhi" class="surface-panel p-6 hover:-translate-y-1 hover:shadow-[var(--shadow-md)]">
                <p class="eyebrow">Gia đình</p>
                <h3 class="mt-3 font-sans text-xl font-black">Thiếu nhi</h3>
            </a>
        </div>
    </section>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" Runat="Server">
    <script>
        function addToCart(maSP, btn) {
            const originalText = btn ? btn.innerText : '';
            if (btn) {
                btn.disabled = true;
                btn.innerText = 'Đang thêm...';
            }

            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('maSP', maSP);

            fetch('CartHandler.ashx', { method: 'POST', body: formData })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const countEl = document.getElementById('cartCount');
                        if (countEl) countEl.innerText = data.cartCount;
                        if (btn) btn.innerText = 'Đã thêm';
                        setTimeout(() => {
                            if (btn) {
                                btn.innerText = originalText;
                                btn.disabled = false;
                            }
                        }, 1200);
                    } else if (data.code === 'auth_required') {
                        window.location.href = 'Login.aspx?ReturnUrl=' + encodeURIComponent('Default.aspx');
                    } else {
                        alert(data.message || 'Không thể thêm sách vào giỏ hàng.');
                        if (btn) {
                            btn.innerText = originalText;
                            btn.disabled = false;
                        }
                    }
                })
                .catch(() => {
                    alert('Đã xảy ra lỗi mạng khi thêm vào giỏ hàng.');
                    if (btn) {
                        btn.innerText = originalText;
                        btn.disabled = false;
                    }
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
                    } else if (data.code === 'auth_required') {
                        window.location.href = 'Login.aspx?ReturnUrl=' + encodeURIComponent('Default.aspx');
                    } else {
                        alert(data.message || 'Không thể xử lý yêu thích.');
                        btn.innerText = originalText;
                    }
                    btn.disabled = false;
                })
                .catch(() => { alert('Đã xảy ra lỗi mạng.'); btn.innerText = originalText; btn.disabled = false; });
        }
    </script>
</asp:Content>
