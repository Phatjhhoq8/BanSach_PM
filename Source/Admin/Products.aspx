<%@ Page Title="Quản lý sản phẩm - The Book Haven" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="Products.aspx.cs" Inherits="Admin_Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">
    Quản lý sản phẩm
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="mb-8 flex flex-col md:flex-row items-center justify-between gap-4">
        <div class="flex items-center gap-4 w-full md:w-auto">
            <div class="relative flex-1 md:w-80">
                <i data-lucide="search" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500"></i>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="w-full bg-slate-800 border border-slate-700 text-white pl-11 pr-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Tìm tên sách, tác giả..." AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
            </div>
            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="bg-slate-800 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
            </asp:DropDownList>
        </div>
        <a href="ProductEdit.aspx" class="w-full md:w-auto px-6 py-3 bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-xl shadow-lg shadow-blue-600/20 transition-all flex items-center justify-center gap-2">
            <i data-lucide="plus" class="w-5 h-5"></i>
            Thêm sản phẩm mới
        </a>
    </div>

    <div class="glass-card rounded-[32px] overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead>
                    <tr class="text-slate-500 text-xs uppercase tracking-wider">
                        <th class="px-8 py-4">Sản phẩm</th>
                        <th class="px-8 py-4">Giá</th>
                        <th class="px-8 py-4">Kho</th>
                        <th class="px-8 py-4">Trạng thái</th>
                        <th class="px-8 py-4 text-right">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="text-sm divide-y divide-white/5">
                    <asp:Repeater ID="rptProducts" runat="server">
                        <ItemTemplate>
                            <tr class="hover:bg-white/5 transition-colors">
                                <td class="px-8 py-4">
                                    <div class="flex items-center gap-4">
                                        <div class="w-12 h-16 bg-slate-800 rounded-lg overflow-hidden flex-shrink-0">
                                            <img src="<%# Eval("HinhAnh") %>" alt="" class="w-full h-full object-cover">
                                        </div>
                                        <div class="min-w-0">
                                            <h4 class="text-sm font-semibold text-white truncate"><%# Eval("TenSP") %></h4>
                                            <p class="text-xs text-slate-500 mt-1"><%# Eval("TacGia") %></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-8 py-4">
                                    <p class="text-white font-bold"><%# Eval("Gia", "{0:N0}đ") %></p>
                                    <p class="text-xs text-rose-400 font-medium"><%# Eval("GiaKhuyenMai", "{0:N0}đ") %></p>
                                </td>
                                <td class="px-8 py-4">
                                    <span class="text-slate-300"><%# Eval("SoLuongTon") %></span>
                                </td>
                                <td class="px-8 py-4">
                                    <span class="px-2 py-1 rounded-lg text-[10px] font-bold uppercase <%# (bool)Eval("TrangThai") ? "bg-emerald-500/10 text-emerald-500" : "bg-rose-500/10 text-rose-500" %>">
                                        <%# (bool)Eval("TrangThai") ? "Đang bán" : "Ngừng bán" %>
                                    </span>
                                </td>
                                <td class="px-8 py-4 text-right">
                                    <div class="flex items-center justify-end gap-2">
                                        <a href="ProductEdit.aspx?id=<%# Eval("MaSP") %>" class="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-slate-400 hover:text-blue-500 transition-colors">
                                            <i data-lucide="edit-3" class="w-4 h-4"></i>
                                        </a>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandArgument='<%# Eval("MaSP") %>' OnClick="btnDelete_Click" OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');" CssClass="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-slate-400 hover:text-rose-500 transition-colors">
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
        
        <div class="p-8 border-t border-white/5 flex items-center justify-between">
            <span class="text-sm text-slate-500"><asp:Literal ID="litProductSummary" runat="server">Đang tải sản phẩm...</asp:Literal></span>
            <a href="ProductEdit.aspx" class="text-sm font-bold text-adminaccent hover:underline">Thêm sách mới</a>
        </div>
    </div>
</asp:Content>
