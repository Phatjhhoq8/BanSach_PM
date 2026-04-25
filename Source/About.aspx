<%@ Page Title="Giới thiệu - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-16 lg:py-24">
            <div class="grid lg:grid-cols-2 gap-12 items-center">
                <div>
                    <p class="eyebrow mb-4">The Book Haven</p>
                    <h1 class="font-heading text-4xl md:text-6xl font-bold leading-tight">Không gian sách chọn lọc cho độc giả Việt.</h1>
                    <p class="mt-6 text-lg text-[var(--ink-soft)] leading-relaxed">Chúng tôi xây dựng một nhà sách trực tuyến theo tinh thần biên tập kỹ lưỡng: sách hay, thông tin rõ ràng, trải nghiệm mua hàng mạch lạc và dịch vụ hậu mãi minh bạch.</p>
                    <div class="mt-8 flex flex-wrap gap-3">
                        <a href="DanhMuc.aspx" class="btn-primary">Khám phá sách</a>
                        <a href="FAQ.aspx" class="btn-secondary">Chính sách hỗ trợ</a>
                    </div>
                </div>
                <div class="surface-panel p-8 lg:p-10">
                    <div class="grid grid-cols-2 gap-4">
                        <div class="rounded-3xl bg-[var(--paper)] p-6">
                            <div class="text-3xl font-heading font-bold text-[var(--primary-dark)]">1.179+</div>
                            <div class="text-sm text-[var(--muted)] mt-2">tựa sách đã chọn lọc</div>
                        </div>
                        <div class="rounded-3xl bg-[var(--paper)] p-6">
                            <div class="text-3xl font-heading font-bold text-[var(--primary-dark)]">24/7</div>
                            <div class="text-sm text-[var(--muted)] mt-2">tiếp nhận yêu cầu hỗ trợ</div>
                        </div>
                        <div class="col-span-2 rounded-3xl border border-blue-100 p-6">
                            <h2 class="font-bold mb-3">Cam kết vận hành</h2>
                            <ul class="space-y-3 text-sm text-[var(--ink-soft)] leading-relaxed">
                                <li>Thông tin sách, giá, khuyến mãi và tồn kho được trình bày rõ ràng.</li>
                                <li>Đơn hàng có trạng thái rõ ràng từ xác nhận đến giao hàng.</li>
                                <li>Giao diện tối ưu cho desktop và mobile, ưu tiên khả năng đọc tiếng Việt.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
    </section>
</asp:Content>
