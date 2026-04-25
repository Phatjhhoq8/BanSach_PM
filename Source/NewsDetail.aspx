<%@ Page Title="Chi tiết tin tức - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="NewsDetail.aspx.cs" Inherits="NewsDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <article class="container-page py-10 lg:py-16">
        <div class="mx-auto max-w-3xl">
            <a href="News.aspx" class="btn-secondary inline-flex">Quay lại tin tức</a>
            <p class="eyebrow mt-8"><asp:Literal ID="litCategory" runat="server"></asp:Literal></p>
            <h1 class="mt-4 font-heading text-4xl md:text-5xl font-bold leading-tight"><asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
            <p class="mt-3 text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]"><asp:Literal ID="litDate" runat="server"></asp:Literal></p>
            <p class="mt-6 text-lg text-[var(--ink-soft)] leading-relaxed"><asp:Literal ID="litSummary" runat="server"></asp:Literal></p>
            <div class="surface-panel mt-10 space-y-5 p-8 leading-relaxed text-[var(--ink-soft)]">
                <asp:Literal ID="litContent" runat="server"></asp:Literal>
            </div>
        </div>
    </article>
</asp:Content>
