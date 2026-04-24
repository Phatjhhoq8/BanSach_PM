<%@ Page Title="Giới thiệu - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="bg-background">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 lg:py-24">
            <div class="grid lg:grid-cols-2 gap-12 items-center">
                <div>
                    <p class="text-primary font-bold uppercase tracking-[0.24em] text-sm mb-4">Premium Books</p>
                    <h1 class="font-heading text-4xl md:text-6xl font-bold text-zinc-950 leading-tight">Không gian sách chọn lọc cho độc giả Việt.</h1>
                    <p class="mt-6 text-lg text-zinc-700 leading-relaxed">Chúng tôi xây dựng một nhà sách trực tuyến theo tinh thần biên tập kỹ lưỡng: sách hay, dữ liệu rõ ràng, trải nghiệm mua hàng mạch lạc và dịch vụ hậu mãi minh bạch.</p>
                    <div class="mt-8 flex flex-wrap gap-3">
                        <a href="DanhMuc.aspx" class="min-h-[44px] inline-flex items-center rounded-full bg-primary px-6 py-3 text-white font-bold shadow-lg shadow-amber-900/20 hover:bg-amber-800 transition-colors">Khám phá sách</a>
                        <a href="FAQ.aspx" class="min-h-[44px] inline-flex items-center rounded-full border border-amber-200 bg-white px-6 py-3 text-zinc-900 font-bold hover:border-primary transition-colors">Chính sách hỗ trợ</a>
                    </div>
                </div>
                <div class="rounded-[40px] bg-white border border-amber-100 shadow-2xl shadow-amber-900/10 p-8 lg:p-10">
                    <div class="grid grid-cols-2 gap-4">
                        <div class="rounded-3xl bg-amber-50 p-6">
                            <div class="text-3xl font-heading font-bold text-primary">1.179+</div>
                            <div class="text-sm text-zinc-600 mt-2">tựa sách đã nhập hệ thống</div>
                        </div>
                        <div class="rounded-3xl bg-zinc-950 p-6 text-white">
                            <div class="text-3xl font-heading font-bold text-amber-300">24/7</div>
                            <div class="text-sm text-zinc-300 mt-2">tiếp nhận yêu cầu hỗ trợ</div>
                        </div>
                        <div class="col-span-2 rounded-3xl border border-amber-100 p-6">
                            <h2 class="font-bold text-zinc-950 mb-3">Cam kết vận hành</h2>
                            <ul class="space-y-3 text-sm text-zinc-700 leading-relaxed">
                                <li>Thông tin sách, giá, khuyến mãi và tồn kho được quản trị tập trung.</li>
                                <li>Đơn hàng có trạng thái rõ ràng từ xác nhận đến giao hàng.</li>
                                <li>Giao diện tối ưu cho desktop và mobile, ưu tiên khả năng đọc tiếng Việt.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
