<%@ Page Title="Chi tiết tin tức - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="NewsDetail.aspx.cs" Inherits="NewsDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <article class="bg-background py-16">
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
            <a href="News.aspx" class="btn-secondary inline-flex">Quay lại tin tức</a>
            <p class="mt-8 text-primary font-bold uppercase tracking-[0.24em] text-sm"><asp:Literal ID="litCategory" runat="server"></asp:Literal></p>
            <h1 class="mt-4 font-heading text-4xl md:text-5xl font-bold text-zinc-950 leading-tight"><asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
            <p class="mt-6 text-lg text-zinc-700 leading-relaxed"><asp:Literal ID="litSummary" runat="server"></asp:Literal></p>
            <div class="mt-10 bg-white rounded-[32px] border border-blue-100 p-8 shadow-sm space-y-5 text-zinc-700 leading-relaxed">
                <asp:Literal ID="litContent" runat="server"></asp:Literal>
            </div>
        </div>
    </article>
</asp:Content>
