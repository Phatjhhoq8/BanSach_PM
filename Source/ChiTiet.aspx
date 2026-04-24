<%@ Page Title="Chi tiết sách - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="ChiTiet.aspx.cs" Inherits="ChiTiet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style>
        .detail-cover {
            background: linear-gradient(150deg, var(--paper-soft), oklch(88% 0.034 74));
            border: 1px solid var(--line);
            border-radius: 2rem;
            min-height: 32rem;
        }

        .book-main-image {
            background-position: center;
            background-repeat: no-repeat;
            background-size: contain;
            filter: drop-shadow(0 30px 48px oklch(24% 0.028 58 / 0.24));
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
                <div class="book-main-image" id="bookFront" runat="server">
                    <div class="sr-only"><asp:Literal ID="litTitleCover" runat="server"></asp:Literal><asp:Literal ID="litTitleCoverShine" runat="server"></asp:Literal></div>
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
                            <input id="qtyInput" type="number" min="1" value="1" class="w-12 bg-transparent text-center font-black outline-none" />
                            <button type="button" onclick="changeQty(1)" class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-[var(--paper-soft)]" aria-label="Tăng số lượng">+</button>
                        </div>
                        <button type="button" onclick="addToCart(this)" class="btn-primary flex-1 py-4 text-base">Thêm vào giỏ hàng</button>
                    </div>
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
    </section>

    <script>
        function changeQty(delta) {
            const input = document.getElementById('qtyInput');
            if (!input) return;
            const current = parseInt(input.value || '1', 10);
            input.value = Math.max(1, current + delta);
        }

        function addToCart(btn) {
            const id = document.getElementById('<%= hdnMaSP.ClientID %>').value;
            const qtyInput = document.getElementById('qtyInput');
            const qty = Math.max(1, parseInt(qtyInput ? qtyInput.value || '1' : '1', 10));
            const originalText = btn.innerText;

            btn.disabled = true;
            btn.innerText = 'Đang thêm...';

            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('maSP', id);
            formData.append('qty', qty);

            fetch('CartHandler.ashx', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        btn.innerText = 'Đã thêm vào giỏ hàng';
                        const countEl = document.getElementById('cartCount');
                        if (countEl) countEl.innerText = data.cartCount;
                        setTimeout(() => {
                            btn.innerText = originalText;
                            btn.disabled = false;
                        }, 1400);
                    } else if (data.code === 'auth_required') {
                        window.location.href = 'Login.aspx?ReturnUrl=' + encodeURIComponent(window.location.pathname + window.location.search);
                    } else {
                        alert(data.message || 'Không thể thêm sách vào giỏ hàng.');
                        btn.innerText = originalText;
                        btn.disabled = false;
                    }
                })
                .catch(() => {
                    alert('Đã xảy ra lỗi mạng khi thêm vào giỏ hàng.');
                    btn.innerText = originalText;
                    btn.disabled = false;
                });
        }
    </script>
</asp:Content>
