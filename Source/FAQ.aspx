<%@ Page Title="Hỗ trợ khách hàng - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="FAQ.aspx.cs" Inherits="FAQ" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="bg-background py-16">
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
            <p class="text-primary font-bold uppercase tracking-[0.24em] text-sm mb-4">Chăm sóc khách hàng</p>
            <h1 class="font-heading text-4xl md:text-5xl font-bold text-zinc-950 mb-8">FAQ, vận chuyển và chính sách mua hàng</h1>
            <asp:Repeater ID="rptFaq" runat="server">
                <HeaderTemplate><div class="grid gap-5"></HeaderTemplate>
                <ItemTemplate>
                    <article class="bg-white rounded-3xl border border-amber-100 p-6 shadow-sm">
                        <p class="text-xs font-black uppercase tracking-[0.12em] text-primary"><%# Server.HtmlEncode(Eval("Nhom").ToString()) %></p>
                        <h2 class="mt-2 font-bold text-lg text-zinc-950"><%# Server.HtmlEncode(Eval("CauHoi").ToString()) %></h2>
                        <p class="mt-2 text-zinc-700 leading-relaxed"><%# Server.HtmlEncode(Eval("TraLoi").ToString()) %></p>
                    </article>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
        </div>
    </section>
</asp:Content>
