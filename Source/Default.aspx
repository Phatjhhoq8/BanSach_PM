<%@ Page Title="Trang chủ - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page section-space">
        <div class="grid items-center gap-10 lg:grid-cols-[1.05fr_0.95fr]">
            <div class="max-w-3xl">
                <p class="eyebrow">Nhà sách editorial hiện đại</p>
                <h1 class="mt-5 text-4xl font-bold leading-tight sm:text-5xl lg:text-6xl">Chọn một cuốn sách hay, bắt đầu một khoảng lặng đáng nhớ.</h1>
                <p class="mt-6 max-w-2xl text-base leading-8 text-[var(--ink-soft)] sm:text-lg">Premium Books tập trung vào bìa sách, thông tin rõ ràng và hành trình mua nhanh gọn cho đồ án web bán sách trực tuyến.</p>
                <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                    <a href="DanhMuc.aspx" class="btn-primary">Khám phá sách</a>
                    <a href="DanhMuc.aspx?sort=new" class="btn-secondary">Xem sách mới</a>
                </div>
                <div class="mt-10 grid max-w-xl grid-cols-3 gap-4 text-sm">
                    <div>
                        <p class="font-heading text-2xl font-bold text-[var(--primary-dark)]">20+</p>
                        <p class="mt-1 text-[var(--muted)]">đầu sách gợi ý</p>
                    </div>
                    <div>
                        <p class="font-heading text-2xl font-bold text-[var(--primary-dark)]">COD</p>
                        <p class="mt-1 text-[var(--muted)]">thanh toán khi nhận</p>
                    </div>
                    <div>
                        <p class="font-heading text-2xl font-bold text-[var(--primary-dark)]">Admin</p>
                        <p class="mt-1 text-[var(--muted)]">quản lý đầy đủ</p>
                    </div>
                </div>
            </div>

            <div class="relative">
                <div class="absolute -left-6 top-12 hidden h-36 w-36 rounded-full bg-[var(--primary-soft)] lg:block"></div>
                <div class="surface-panel relative overflow-hidden p-4 sm:p-6">
                    <div class="aspect-[4/5] overflow-hidden rounded-[1.5rem] bg-[var(--paper-soft)]">
                        <video autoplay loop muted playsinline class="h-full w-full object-cover opacity-90">
                            <source src="videos/book.mp4" type="video/mp4" />
                        </video>
                    </div>
                    <div class="absolute bottom-8 left-8 right-8 rounded-3xl border border-[oklch(98%_0.012_78_/_0.72)] bg-[oklch(98%_0.012_78_/_0.88)] p-5 shadow-[var(--shadow-sm)] backdrop-blur-sm">
                        <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--primary-dark)]">Bộ sưu tập tuần này</p>
                        <p class="mt-2 font-heading text-xl font-bold">Những cuốn sách nên nằm trên bàn đọc mùa này.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="border-y border-[var(--line)] bg-[var(--surface)]">
        <div class="container-page grid gap-6 py-8 md:grid-cols-3">
            <div>
                <p class="font-extrabold text-[var(--ink)]">Dữ liệu sách có sẵn</p>
                <p class="mt-1 text-sm text-[var(--muted)]">Import tự động từ file JSON khi chạy lần đầu.</p>
            </div>
            <div>
                <p class="font-extrabold text-[var(--ink)]">Giỏ hàng theo tài khoản</p>
                <p class="mt-1 text-sm text-[var(--muted)]">Lưu trong SQL Server, không mất khi đổi trang.</p>
            </div>
            <div>
                <p class="font-extrabold text-[var(--ink)]">Quản trị riêng</p>
                <p class="mt-1 text-sm text-[var(--muted)]">Admin quản lý sách, danh mục, đơn hàng và khách hàng.</p>
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
                            <button type="button" onclick="addToCart(<%# Eval("MaSP") %>, this)" class="mt-4 rounded-full border border-[var(--line)] px-3 py-2 text-xs font-black text-[var(--primary-dark)] hover:border-[var(--primary)] hover:bg-[var(--primary-soft)]">Thêm vào giỏ</button>
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
                <h3 class="mt-3 text-xl font-bold">Tất cả sách</h3>
            </a>
            <a href="DanhMuc.aspx?sort=price_asc" class="surface-panel p-6 hover:-translate-y-1 hover:shadow-[var(--shadow-md)]">
                <p class="eyebrow">Ưu đãi</p>
                <h3 class="mt-3 text-xl font-bold">Giá tốt</h3>
            </a>
            <a href="DanhMuc.aspx?q=kinh%20tế" class="surface-panel p-6 hover:-translate-y-1 hover:shadow-[var(--shadow-md)]">
                <p class="eyebrow">Chủ đề</p>
                <h3 class="mt-3 text-xl font-bold">Kinh tế</h3>
            </a>
            <a href="DanhMuc.aspx?q=thiếu%20nhi" class="surface-panel p-6 hover:-translate-y-1 hover:shadow-[var(--shadow-md)]">
                <p class="eyebrow">Gia đình</p>
                <h3 class="mt-3 text-xl font-bold">Thiếu nhi</h3>
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
    </script>
</asp:Content>
