<%@ Page Title="Quản lý tin tức - The Book Haven" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="News.aspx.cs" Inherits="Admin_News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">Quản lý tin tức</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="grid gap-8 xl:grid-cols-[0.95fr_1.35fr]">
        <section class="glass-card rounded-[32px] p-8">
            <h2 class="mb-5 text-xl font-bold text-white"><asp:Literal ID="litFormTitle" runat="server">Thêm bài viết</asp:Literal></h2>
            <asp:HiddenField ID="hdnId" runat="server" />
            <asp:Literal ID="litMessage" runat="server"></asp:Literal>
            <div class="space-y-4">
                <asp:TextBox ID="txtTitle" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="Tiêu đề"></asp:TextBox>
                <asp:TextBox ID="txtCategory" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" placeholder="Chuyên mục"></asp:TextBox>
                <asp:TextBox ID="txtSummary" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" TextMode="MultiLine" Rows="3" placeholder="Tóm tắt"></asp:TextBox>
                <asp:TextBox ID="txtContent" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-3" TextMode="MultiLine" Rows="8" placeholder="Nội dung"></asp:TextBox>
                <label class="flex items-center gap-3 text-sm font-bold text-slate-300"><asp:CheckBox ID="chkActive" runat="server" Checked="true" /> Hiển thị ngoài website</label>
                <div class="flex gap-3">
                    <asp:Button ID="btnSave" runat="server" Text="Lưu bài viết" OnClick="btnSave_Click" CssClass="flex-1 rounded-xl bg-adminaccent px-5 py-3 font-black text-adminbg hover:opacity-90" />
                    <asp:Button ID="btnCancel" runat="server" Text="Hủy" OnClick="btnCancel_Click" CssClass="rounded-xl bg-adminpanel px-5 py-3 font-bold text-slate-300 hover:text-white" />
                </div>
            </div>
        </section>

        <section class="glass-card rounded-[32px] p-8">
            <div class="mb-5 flex items-center justify-between gap-4">
                <h2 class="text-xl font-bold text-white">Danh sách bài viết</h2>
                <a href="../News.aspx" target="_blank" class="rounded-xl bg-blue-600 px-4 py-2 text-sm font-bold text-white hover:bg-blue-500">Xem trang tin</a>
            </div>
            <asp:Repeater ID="rptNews" runat="server">
                <HeaderTemplate><div class="space-y-3"></HeaderTemplate>
                <ItemTemplate>
                    <div class="rounded-2xl border border-slate-800 bg-slate-900 p-5">
                        <div class="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
                            <div>
                                <p class="text-xs font-black uppercase tracking-widest text-adminaccent"><%# Server.HtmlEncode(Eval("ChuyenMuc").ToString()) %></p>
                                <h3 class="mt-2 font-bold text-white"><%# Server.HtmlEncode(Eval("TieuDe").ToString()) %></h3>
                                <p class="mt-2 text-sm text-slate-400"><%# Server.HtmlEncode(Eval("TomTat").ToString()) %></p>
                                <p class="mt-2 text-xs font-bold <%# Convert.ToBoolean(Eval("TrangThai")) ? "text-emerald-400" : "text-rose-400" %>"><%# Convert.ToBoolean(Eval("TrangThai")) ? "Đang hiển thị" : "Đang ẩn" %></p>
                            </div>
                            <div class="flex shrink-0 gap-2">
                                <asp:LinkButton ID="btnEdit" runat="server" CommandArgument='<%# Eval("MaTin") %>' OnClick="btnEdit_Click" CssClass="rounded-lg bg-adminbg px-3 py-2 text-xs font-bold text-adminaccent">Sửa</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandArgument='<%# Eval("MaTin") %>' OnClick="btnDelete_Click" OnClientClick="return confirm('Xóa bài viết này?');" CssClass="rounded-lg bg-adminbg px-3 py-2 text-xs font-bold text-rose-400">Xóa</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate></div></FooterTemplate>
            </asp:Repeater>
        </section>
    </div>
</asp:Content>
