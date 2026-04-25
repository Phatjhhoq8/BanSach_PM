<%@ Page Title="Tin tức sách - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="News.aspx.cs" Inherits="News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-10 lg:py-16">
            <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-6 mb-10">
                <div>
                    <p class="eyebrow">Blog / Tin tức</p>
                    <h1 class="mt-3 font-heading text-4xl md:text-5xl font-bold">Gợi ý đọc sách và câu chuyện xuất bản</h1>
                </div>
                <a href="DanhMuc.aspx" class="btn-secondary self-start md:self-auto">Mua sách ngay</a>
            </div>
            <asp:Repeater ID="rptNews" runat="server">
                <HeaderTemplate><div class="grid md:grid-cols-3 gap-6"></HeaderTemplate>
                <ItemTemplate>
                    <a href='NewsDetail.aspx?id=<%# Eval("MaTin") %>' class="surface-panel group p-7 hover:-translate-y-1 hover:shadow-[var(--shadow-md)]">
                        <p class="text-xs font-bold uppercase tracking-widest text-[var(--primary-dark)]"><%# Server.HtmlEncode(Eval("ChuyenMuc").ToString()) %></p>
                        <h2 class="mt-4 font-heading text-2xl font-bold group-hover:text-[var(--primary-dark)] transition-colors"><%# Server.HtmlEncode(Eval("TieuDe").ToString()) %></h2>
                        <p class="mt-3 text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]"><%# Eval("NgayDang", "{0:dd/MM/yyyy}") %></p>
                        <p class="mt-4 text-sm text-[var(--ink-soft)] leading-relaxed"><%# Server.HtmlEncode(Eval("TomTat").ToString()) %></p>
                    </a>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
            <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
                <div class="surface-panel p-8 text-[var(--muted)]">Chưa có bài viết nào đang hiển thị.</div>
            </asp:PlaceHolder>
    </section>
</asp:Content>
