<%@ Page Title="Đặt hàng thành công - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="Success.aspx.cs" Inherits="Success" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-3xl mx-auto px-4 py-24 text-center">
        <div class="w-24 h-24 bg-emerald-100 text-emerald-500 rounded-full flex items-center justify-center mx-auto mb-10 shadow-lg shadow-emerald-500/10">
            <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
        </div>
        <h1 class="text-4xl font-bold text-gray-900 font-heading mb-4">Cảm ơn bạn đã đặt hàng!</h1>
        <p class="text-gray-500 text-lg mb-10">Đơn hàng <span class="font-bold text-gray-900">#<asp:Literal ID="litOrderId" runat="server"></asp:Literal></span> của bạn đã được tiếp nhận và đang trong quá trình xử lý.</p>
        
        <div class="bg-white p-8 rounded-[40px] border border-gray-100 shadow-sm mb-12 text-left space-y-6">
            <h3 class="font-bold text-gray-900 flex items-center gap-2">
                <svg class="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                Thông tin tiếp theo
            </h3>
            <ul class="space-y-4 text-sm text-gray-600">
                <li class="flex items-start gap-3">
                    <span class="w-5 h-5 rounded-full bg-gray-100 text-[10px] flex items-center justify-center font-bold mt-0.5">1</span>
                    Chúng tôi đã gửi email xác nhận chi tiết đơn hàng đến bạn.
                </li>
                <li class="flex items-start gap-3">
                    <span class="w-5 h-5 rounded-full bg-gray-100 text-[10px] flex items-center justify-center font-bold mt-0.5">2</span>
                    Nhân viên sẽ gọi điện xác nhận trong vòng 24h tới.
                </li>
                <li class="flex items-start gap-3">
                    <span class="w-5 h-5 rounded-full bg-gray-100 text-[10px] flex items-center justify-center font-bold mt-0.5">3</span>
                    Bạn có thể theo dõi trạng thái đơn hàng trong mục "Đơn hàng của tôi".
                </li>
            </ul>
        </div>

        <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
            <a href="Default.aspx" class="w-full sm:w-auto px-10 py-4 bg-primary hover:bg-secondary text-white font-bold rounded-2xl transition-all shadow-xl shadow-primary/20">
                Tiếp tục mua sắm
            </a>
            <a href="Orders.aspx" class="w-full sm:w-auto px-10 py-4 bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold rounded-2xl transition-all">
                Xem đơn hàng
            </a>
        </div>
    </div>
</asp:Content>
