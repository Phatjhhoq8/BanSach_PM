<%@ Page Title="Cấu hình hệ thống - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Cấu hình hệ thống</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="grid lg:grid-cols-2 gap-8">
        <section class="glass-card rounded-[32px] p-8">
            <h2 class="text-xl font-bold text-white mb-6">Thanh toán</h2>
            <div class="space-y-4 text-sm text-slate-300">
                <div class="flex items-center justify-between border-b border-white/5 pb-4"><span>COD</span><span class="px-3 py-1 rounded-full bg-emerald-500/10 text-emerald-400 font-bold">Đang bật</span></div>
                <div class="flex items-center justify-between border-b border-white/5 pb-4"><span>Chuyển khoản ngân hàng</span><span class="px-3 py-1 rounded-full bg-amber-500/10 text-amber-400 font-bold">Bảo trì</span></div>
            </div>
        </section>
        <section class="glass-card rounded-[32px] p-8">
            <h2 class="text-xl font-bold text-white mb-6">Vận chuyển</h2>
            <p class="text-slate-300 leading-relaxed">Phí vận chuyển mặc định: <strong class="text-white">30.000đ</strong>. Các đơn vị vận chuyển có thể được cấu hình thêm khi tích hợp đối tác.</p>
        </section>
    </div>
</asp:Content>
