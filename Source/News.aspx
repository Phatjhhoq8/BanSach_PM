<%@ Page Title="Tin tức sách - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="News.aspx.cs" Inherits="News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="bg-background py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-6 mb-10">
                <div>
                    <p class="text-primary font-bold uppercase tracking-[0.24em] text-sm mb-4">Blog / Tin tức</p>
                    <h1 class="font-heading text-4xl md:text-5xl font-bold text-zinc-950">Gợi ý đọc sách và câu chuyện xuất bản</h1>
                </div>
                <a href="DanhMuc.aspx" class="btn-secondary self-start md:self-auto">Mua sách ngay</a>
            </div>
            <asp:Repeater ID="rptNews" runat="server">
                <HeaderTemplate><div class="grid md:grid-cols-3 gap-6"></HeaderTemplate>
                <ItemTemplate>
                    <a href='NewsDetail.aspx?id=<%# Eval("MaTin") %>' class="group bg-white rounded-[32px] border border-amber-100 p-7 shadow-sm hover:shadow-xl transition-shadow">
                        <p class="text-xs font-bold text-primary uppercase tracking-widest"><%# Server.HtmlEncode(Eval("ChuyenMuc").ToString()) %></p>
                        <h2 class="mt-4 font-heading text-2xl font-bold text-zinc-950 group-hover:text-primary transition-colors"><%# Server.HtmlEncode(Eval("TieuDe").ToString()) %></h2>
                        <p class="mt-4 text-sm text-zinc-600 leading-relaxed"><%# Server.HtmlEncode(Eval("TomTat").ToString()) %></p>
                    </a>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
            <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
                <div class="rounded-[32px] border border-amber-100 bg-white p-8 text-zinc-600">Chưa có bài viết nào đang hiển thị.</div>
            </asp:PlaceHolder>
        </div>
    </section>
</asp:Content>
