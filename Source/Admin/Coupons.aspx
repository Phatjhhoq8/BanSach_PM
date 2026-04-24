<%@ Page Title="Mã ưu đãi - Premium Admin" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Coupons.aspx.cs" Inherits="Admin_Coupons" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">
    Mã ưu đãi
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="grid gap-8 xl:grid-cols-[24rem_1fr]">
        <aside class="glass-card rounded-[32px] p-8 xl:sticky xl:top-24 xl:self-start">
            <h2 class="text-xl font-black text-white"><asp:Literal ID="litFormTitle" runat="server">Thêm mã ưu đãi</asp:Literal></h2>
            <asp:HiddenField ID="hdnOldCode" runat="server" />
            <asp:Literal ID="litMessage" runat="server"></asp:Literal>
            <div class="mt-6 space-y-5">
                <div>
                    <label class="mb-2 block text-sm font-bold text-slate-400">Mã ưu đãi</label>
                    <asp:TextBox ID="txtCode" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="SALE10"></asp:TextBox>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="mb-2 block text-sm font-bold text-slate-400">% giảm</label>
                        <asp:TextBox ID="txtPercent" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="10"></asp:TextBox>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-bold text-slate-400">Giảm tiền</label>
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="30000"></asp:TextBox>
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="mb-2 block text-sm font-bold text-slate-400">Số lượng</label>
                        <asp:TextBox ID="txtQuantity" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="100"></asp:TextBox>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-bold text-slate-400">Điều kiện</label>
                        <asp:TextBox ID="txtCondition" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="0"></asp:TextBox>
                    </div>
                </div>
                <div>
                    <label class="mb-2 block text-sm font-bold text-slate-400">Hiệu lực thêm (ngày)</label>
                    <asp:TextBox ID="txtDays" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="30"></asp:TextBox>
                </div>
                <div class="flex gap-3">
                    <asp:Button ID="btnSave" runat="server" Text="Lưu mã" OnClick="btnSave_Click" CssClass="flex-1 rounded-xl bg-adminaccent px-5 py-3 font-black text-adminbg hover:opacity-90" />
                    <asp:Button ID="btnCancel" runat="server" Text="Hủy" OnClick="btnCancel_Click" CssClass="rounded-xl bg-adminpanel px-5 py-3 font-bold text-slate-300 hover:text-white" />
                </div>
            </div>
        </aside>

        <section class="glass-card overflow-hidden rounded-[32px]">
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead class="text-xs uppercase tracking-wider text-slate-500">
                        <tr>
                            <th class="px-8 py-4">Mã</th>
                            <th class="px-8 py-4">Giảm</th>
                            <th class="px-8 py-4">Hiệu lực</th>
                            <th class="px-8 py-4">Số lượng</th>
                            <th class="px-8 py-4 text-right">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-white/5">
                        <asp:Repeater ID="rptCoupons" runat="server">
                            <ItemTemplate>
                                <tr class="hover:bg-white/5">
                                    <td class="px-8 py-4 font-black text-white"><%# Eval("MaKM") %></td>
                                    <td class="px-8 py-4 text-slate-300"><%# Eval("PhanTramGiam") %>% + <%# Eval("GiaTriGiam", "{0:N0}đ") %></td>
                                    <td class="px-8 py-4 text-slate-400"><%# Eval("NgayBatDau", "{0:dd/MM/yyyy}") %> - <%# Eval("NgayKetThuc", "{0:dd/MM/yyyy}") %></td>
                                    <td class="px-8 py-4 text-slate-300"><%# Eval("SoLuong") %></td>
                                    <td class="px-8 py-4 text-right">
                                        <div class="flex justify-end gap-2">
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandArgument='<%# Eval("MaKM") %>' OnClick="btnEdit_Click" CssClass="rounded-lg bg-adminbg px-3 py-2 text-xs font-bold text-adminaccent">Sửa</asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandArgument='<%# Eval("MaKM") %>' OnClick="btnDelete_Click" OnClientClick="return confirm('Xóa mã ưu đãi này?');" CssClass="rounded-lg bg-adminbg px-3 py-2 text-xs font-bold text-rose-400">Xóa</asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</asp:Content>
