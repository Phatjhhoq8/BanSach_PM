<%@ Page Title="Quản lý danh mục - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Categories.aspx.cs" Inherits="Admin_Categories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">
    Quản lý danh mục
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Category Form -->
        <div class="lg:col-span-1">
            <div class="glass-card rounded-[32px] p-8 sticky top-24">
                <h3 class="text-lg font-bold text-white mb-6">
                    <asp:Literal ID="litFormTitle" runat="server">Thêm danh mục mới</asp:Literal>
                </h3>
                <asp:HiddenField ID="hdnMaDM" runat="server" />
                <div class="space-y-6">
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Tên danh mục</label>
                        <asp:TextBox ID="txtTenDM" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="VD: Văn học Việt Nam"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Trạng thái</label>
                        <asp:CheckBox ID="chkTrangThai" runat="server" Text=" Hoạt động" Checked="true" CssClass="text-slate-300 text-sm" />
                    </div>
                    <div class="flex gap-4 pt-4">
                        <asp:Button ID="btnSave" runat="server" Text="Lưu lại" OnClick="btnSave_Click" CssClass="flex-1 bg-blue-600 hover:bg-blue-500 text-white font-bold py-3 rounded-xl transition-all" />
                        <asp:Button ID="btnCancel" runat="server" Text="Hủy" OnClick="btnCancel_Click" CssClass="px-6 bg-slate-800 text-slate-400 hover:text-white rounded-xl transition-all" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Category List -->
        <div class="lg:col-span-2">
            <div class="glass-card rounded-[32px] overflow-hidden">
                <table class="w-full text-left">
                    <thead>
                        <tr class="text-slate-500 text-xs uppercase tracking-wider">
                            <th class="px-8 py-4">ID</th>
                            <th class="px-8 py-4">Tên danh mục</th>
                            <th class="px-8 py-4">Trạng thái</th>
                            <th class="px-8 py-4 text-right">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="text-sm divide-y divide-white/5">
                        <asp:Repeater ID="rptCategories" runat="server">
                            <ItemTemplate>
                                <tr class="hover:bg-white/5 transition-colors">
                                    <td class="px-8 py-4 text-slate-500">#<%# Eval("MaDM") %></td>
                                    <td class="px-8 py-4 text-white font-medium"><%# Eval("TenDM") %></td>
                                    <td class="px-8 py-4">
                                        <span class="px-2 py-1 rounded-lg text-[10px] font-bold uppercase <%# (bool)Eval("TrangThai") ? "bg-emerald-500/10 text-emerald-500" : "bg-rose-500/10 text-rose-500" %>">
                                            <%# (bool)Eval("TrangThai") ? "Hoạt động" : "Tạm ẩn" %>
                                        </span>
                                    </td>
                                    <td class="px-8 py-4 text-right">
                                        <div class="flex items-center justify-end gap-2">
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandArgument='<%# Eval("MaDM") %>' OnClick="btnEdit_Click" CssClass="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-slate-400 hover:text-blue-500 transition-colors">
                                                <i data-lucide="edit-3" class="w-4 h-4"></i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandArgument='<%# Eval("MaDM") %>' OnClick="btnDelete_Click" OnClientClick="return confirm('Xóa danh mục này có thể ảnh hưởng đến sản phẩm liên quan. Tiếp tục?');" CssClass="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-slate-400 hover:text-rose-500 transition-colors">
                                                <i data-lucide="trash-2" class="w-4 h-4"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
