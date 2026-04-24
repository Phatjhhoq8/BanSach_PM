<%@ Page Title="Chi tiết đơn hàng - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="OrderDetail.aspx.cs" Inherits="Admin_OrderDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Chi tiết đơn hàng #<asp:Literal ID="litOrderId" runat="server" /></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:PlaceHolder ID="phNotFound" runat="server" Visible="false"><div class="glass-card rounded-[32px] p-10 text-center text-slate-300">Không tìm thấy đơn hàng.</div></asp:PlaceHolder>
    <asp:PlaceHolder ID="phContent" runat="server" Visible="false">
        <div class="grid lg:grid-cols-3 gap-8">
            <div class="lg:col-span-2 glass-card rounded-[32px] p-6">
                <h2 class="font-bold text-white mb-5">Sản phẩm</h2>
                <div class="space-y-4"><asp:Repeater ID="rptItems" runat="server"><ItemTemplate><div class="flex gap-4 border-b border-white/5 pb-4 last:border-0"><img src='<%# Eval("HinhAnh") %>' alt='' class="w-14 h-20 rounded-lg object-cover bg-slate-800" /><div class="flex-1"><p class="text-white font-semibold"><%# Eval("TenSP") %></p><p class="text-xs text-slate-500">SL: <%# Eval("SoLuong") %> x <%# Eval("DonGia", "{0:N0}đ") %></p></div><span class="text-emerald-400 font-bold"><%# Eval("ThanhTien", "{0:N0}đ") %></span></div></ItemTemplate></asp:Repeater></div>
            </div>
            <aside class="glass-card rounded-[32px] p-6 h-fit">
                <h2 class="font-bold text-white mb-5">Khách hàng & giao hàng</h2>
                <div class="space-y-4 text-sm text-slate-300"><p><span class="block text-slate-500 uppercase text-xs">Khách hàng</span><asp:Literal ID="litCustomer" runat="server" /></p><p><span class="block text-slate-500 uppercase text-xs">Ngày đặt</span><asp:Literal ID="litDate" runat="server" /></p><p><span class="block text-slate-500 uppercase text-xs">Trạng thái</span><asp:Literal ID="litStatus" runat="server" /></p><p><span class="block text-slate-500 uppercase text-xs">Địa chỉ</span><asp:Literal ID="litAddress" runat="server" /></p><p><span class="block text-slate-500 uppercase text-xs">Số điện thoại</span><asp:Literal ID="litPhone" runat="server" /></p></div>
                <div class="border-t border-white/10 mt-6 pt-6 flex justify-between text-lg font-bold"><span class="text-white">Tổng</span><span class="text-emerald-400"><asp:Literal ID="litTotal" runat="server" /></span></div>
            </aside>
        </div>
    </asp:PlaceHolder>
</asp:Content>
