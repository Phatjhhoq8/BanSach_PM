<%@ Page Title="Quản lý FAQ - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Quản lý FAQ / CSKH</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="glass-card rounded-[32px] p-8">
        <div class="flex items-center justify-between gap-4 mb-6">
            <div><h2 class="text-xl font-bold text-white">Chính sách hỗ trợ khách hàng</h2><p class="text-sm text-slate-500 mt-1">Các nội dung FAQ đang được xuất ra trang hỗ trợ khách hàng.</p></div>
            <a href="../FAQ.aspx" target="_blank" class="min-h-[44px] inline-flex items-center rounded-xl bg-blue-600 px-4 py-2 text-white font-bold hover:bg-blue-500 transition-colors">Xem FAQ</a>
        </div>
        <div class="space-y-4">
            <div class="rounded-2xl bg-slate-900 border border-slate-800 p-5"><h3 class="text-white font-bold">Đổi trả và hoàn tiền</h3><p class="text-slate-400 text-sm mt-2">Hỗ trợ trong 7 ngày cho sách lỗi, giao sai hoặc hư hỏng.</p></div>
            <div class="rounded-2xl bg-slate-900 border border-slate-800 p-5"><h3 class="text-white font-bold">Vận chuyển</h3><p class="text-slate-400 text-sm mt-2">Phí vận chuyển mặc định 30.000đ.</p></div>
            <div class="rounded-2xl bg-slate-900 border border-slate-800 p-5"><h3 class="text-white font-bold">Thanh toán</h3><p class="text-slate-400 text-sm mt-2">COD đang bật, chuyển khoản ở trạng thái bảo trì.</p></div>
        </div>
    </div>
</asp:Content>
