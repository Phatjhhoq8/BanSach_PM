<%@ Page Title="Hỗ trợ khách hàng - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="FAQ.aspx.cs" Inherits="FAQ" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-10 lg:py-16">
        <div class="mx-auto max-w-5xl">
            <p class="eyebrow">Chăm sóc khách hàng</p>
            <h1 class="mt-3 font-heading text-4xl md:text-5xl font-bold mb-8">FAQ, vận chuyển và chính sách mua hàng</h1>
            <div class="surface-panel mb-6 p-4">
                <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]" for="faqSearch">Tìm nhanh câu hỏi</label>
                <input id="faqSearch" type="search" class="form-control rounded-full text-sm" placeholder="Nhập vận chuyển, thanh toán, đổi trả..." oninput="filterFaq(this.value)" />
            </div>
            <asp:Repeater ID="rptFaq" runat="server">
                <HeaderTemplate><div class="grid gap-5"></HeaderTemplate>
                <ItemTemplate>
                    <details class="surface-panel p-6" data-faq-item data-search-text='<%# GetSearchText(Eval("Nhom"), Eval("CauHoi"), Eval("TraLoi")) %>'>
                        <summary class="cursor-pointer list-none">
                            <p class="text-xs font-black uppercase tracking-[0.12em] text-[var(--primary-dark)]"><%# Server.HtmlEncode(Eval("Nhom").ToString()) %></p>
                            <h2 class="mt-2 font-bold text-lg"><%# Server.HtmlEncode(Eval("CauHoi").ToString()) %></h2>
                        </summary>
                        <p class="mt-4 text-[var(--ink-soft)] leading-relaxed"><%# Server.HtmlEncode(Eval("TraLoi").ToString()) %></p>
                    </details>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
            <p id="faqNoResult" class="mt-6 hidden rounded-3xl border border-dashed border-[var(--line)] bg-[var(--surface)] p-6 text-center text-[var(--muted)]">Không tìm thấy câu hỏi phù hợp.</p>
        </div>
    </section>
    <script>
        function filterFaq(value) {
            const keyword = (value || '').trim().toLowerCase();
            let visibleCount = 0;
            document.querySelectorAll('[data-faq-item]').forEach(item => {
                const haystack = item.getAttribute('data-search-text') || '';
                const visible = !keyword || haystack.indexOf(keyword) >= 0;
                item.classList.toggle('hidden', !visible);
                if (visible) visibleCount += 1;
            });
            const empty = document.getElementById('faqNoResult');
            if (empty) empty.classList.toggle('hidden', visibleCount !== 0);
        }
    </script>
</asp:Content>
