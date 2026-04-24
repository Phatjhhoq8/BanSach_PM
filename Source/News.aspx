<%@ Page Title="Tin tức sách - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="bg-background py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-6 mb-10">
                <div>
                    <p class="text-primary font-bold uppercase tracking-[0.24em] text-sm mb-4">Blog / Tin tức</p>
                    <h1 class="font-heading text-4xl md:text-5xl font-bold text-zinc-950">Gợi ý đọc sách và câu chuyện xuất bản</h1>
                </div>
                <a href="DanhMuc.aspx" class="text-primary font-bold hover:text-amber-800 transition-colors">Mua sách ngay</a>
            </div>
            <div class="grid md:grid-cols-3 gap-6">
                <a href="NewsDetail.aspx?id=1" class="group bg-white rounded-[32px] border border-amber-100 p-7 shadow-sm hover:shadow-xl transition-shadow">
                    <p class="text-xs font-bold text-primary uppercase tracking-widest">Top list</p>
                    <h2 class="mt-4 font-heading text-2xl font-bold text-zinc-950 group-hover:text-primary transition-colors">10 cuốn sách nên đọc khi bắt đầu xây thói quen đọc</h2>
                    <p class="mt-4 text-sm text-zinc-600 leading-relaxed">Danh sách cân bằng giữa tư duy, kỹ năng sống và văn học dễ tiếp cận.</p>
                </a>
                <a href="NewsDetail.aspx?id=2" class="group bg-white rounded-[32px] border border-amber-100 p-7 shadow-sm hover:shadow-xl transition-shadow">
                    <p class="text-xs font-bold text-primary uppercase tracking-widest">Review</p>
                    <h2 class="mt-4 font-heading text-2xl font-bold text-zinc-950 group-hover:text-primary transition-colors">Cách chọn sách kỹ năng sống không bị lan man</h2>
                    <p class="mt-4 text-sm text-zinc-600 leading-relaxed">Ưu tiên vấn đề bạn đang gặp, tác giả có nền tảng rõ và nội dung có bài tập thực hành.</p>
                </a>
                <a href="NewsDetail.aspx?id=3" class="group bg-white rounded-[32px] border border-amber-100 p-7 shadow-sm hover:shadow-xl transition-shadow">
                    <p class="text-xs font-bold text-primary uppercase tracking-widest">Hướng dẫn</p>
                    <h2 class="mt-4 font-heading text-2xl font-bold text-zinc-950 group-hover:text-primary transition-colors">Bảo quản sách giấy trong mùa ẩm</h2>
                    <p class="mt-4 text-sm text-zinc-600 leading-relaxed">Những thói quen nhỏ giúp sách giữ phom, không cong gáy và hạn chế ố giấy.</p>
                </a>
            </div>
        </div>
    </section>
</asp:Content>
