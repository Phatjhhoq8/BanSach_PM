<%@ Page Title="Quản lý tin tức - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Quản lý tin tức</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="glass-card rounded-[32px] p-8">
        <div class="flex items-center justify-between gap-4 mb-6">
            <div><h2 class="text-xl font-bold text-white">Bài viết đang hiển thị</h2><p class="text-sm text-slate-500 mt-1">Module nội dung client đã có trang News/NewsDetail, sẵn sàng nối CSDL khi cần biên tập động.</p></div>
            <a href="../News.aspx" target="_blank" class="min-h-[44px] inline-flex items-center rounded-xl bg-blue-600 px-4 py-2 text-white font-bold hover:bg-blue-500 transition-colors">Xem trang tin</a>
        </div>
        <div class="grid md:grid-cols-3 gap-4">
            <div class="rounded-2xl bg-slate-900 border border-slate-800 p-5"><p class="text-xs text-blue-400 font-bold uppercase">Top list</p><h3 class="text-white font-bold mt-3">10 cuốn sách nên đọc</h3></div>
            <div class="rounded-2xl bg-slate-900 border border-slate-800 p-5"><p class="text-xs text-blue-400 font-bold uppercase">Review</p><h3 class="text-white font-bold mt-3">Chọn sách kỹ năng sống</h3></div>
            <div class="rounded-2xl bg-slate-900 border border-slate-800 p-5"><p class="text-xs text-blue-400 font-bold uppercase">Hướng dẫn</p><h3 class="text-white font-bold mt-3">Bảo quản sách giấy</h3></div>
        </div>
    </div>
</asp:Content>
