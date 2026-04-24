<%@ Page Title="Danh mục sách - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="DanhMuc.aspx.cs" Inherits="DanhMuc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="border-b border-[var(--line)] bg-[var(--surface)]">
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
            <aside class="space-y-5">
                <details class="surface-panel p-5" open>
                    <summary class="cursor-pointer list-none text-sm font-black uppercase tracking-[0.12em] text-[var(--primary-dark)]">Danh mục</summary>
                    <ul class="mt-5 space-y-2 text-sm font-bold">
                        <li><a href="DanhMuc.aspx" class='<%= IsAllCategoryActive() ? "flex rounded-2xl bg-[var(--primary-soft)] px-4 py-3 text-[var(--primary-dark)]" : "flex rounded-2xl px-4 py-3 text-[var(--ink-soft)] hover:bg-[var(--paper-soft)] hover:text-[var(--primary-dark)]" %>'>Tất cả sản phẩm</a></li>
                        <asp:Repeater ID="rptCategories" runat="server">
                            <ItemTemplate>
                                <li><a href='DanhMuc.aspx?cat=<%# Eval("MaDM") %>' class='<%# GetCategoryLinkClass(Eval("MaDM")) %>'><%# Eval("TenDM") %></a></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </details>

                <details class="surface-panel p-5" open>
                    <summary class="cursor-pointer list-none text-sm font-black uppercase tracking-[0.12em] text-[var(--primary-dark)]">Khoảng giá</summary>
                    <div class="mt-5 space-y-2 text-sm font-bold">
                        <a href="DanhMuc.aspx" class='<%= GetPriceFilterClass("") %>'>Tất cả mức giá</a>
                        <a href="DanhMuc.aspx?price=under100" class='<%= GetPriceFilterClass("under100") %>'>Dưới 100.000đ</a>
                        <a href="DanhMuc.aspx?price=100-200" class='<%= GetPriceFilterClass("100-200") %>'>100.000đ - 200.000đ</a>
                        <a href="DanhMuc.aspx?price=200-500" class='<%= GetPriceFilterClass("200-500") %>'>200.000đ - 500.000đ</a>
                        <a href="DanhMuc.aspx?price=over500" class='<%= GetPriceFilterClass("over500") %>'>Trên 500.000đ</a>
                    </div>
                </details>
            </aside>

            <div class="min-w-0">
                <div class="surface-panel mb-8 flex flex-col gap-4 p-4 md:flex-row md:items-center md:justify-between">
                    <div class="flex-1">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control rounded-full text-sm" placeholder="Tìm tên sách hoặc tác giả..." AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
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

                <div class="grid grid-cols-2 gap-x-4 gap-y-10 sm:grid-cols-3 xl:grid-cols-4 xl:gap-x-7">
                    <asp:Repeater ID="rptSach" runat="server">
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
                <asp:Label ID="LabelNoData" runat="server" Text="Không tìm thấy sách phù hợp. Hãy thử từ khóa hoặc bộ lọc khác." Visible="false" CssClass="block rounded-3xl border border-dashed border-[var(--line)] bg-[var(--surface)] p-10 text-center text-[var(--muted)]" />
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" Runat="Server">
    <script>
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
                        setTimeout(() => { btn.innerText = originalText; btn.disabled = false; }, 1200);
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
