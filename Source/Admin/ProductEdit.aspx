<%@ Page Title="Chỉnh sửa sản phẩm - BanSach Premium" Language="C#" MasterPageFile="Admin.master" AutoEventWireup="true" CodeFile="ProductEdit.aspx.cs" Inherits="Admin_ProductEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" Runat="Server">
    <asp:Literal ID="litPageTitle" runat="server">Thêm sản phẩm mới</asp:Literal>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-4xl">
        <div class="flex items-center gap-4 mb-8">
            <a href="Products.aspx" class="w-10 h-10 rounded-xl bg-slate-800 flex items-center justify-center text-slate-400 hover:text-white transition-all">
                <i data-lucide="arrow-left" class="w-5 h-5"></i>
            </a>
            <h3 class="text-xl font-bold text-white">Thông tin chi tiết</h3>
        </div>
        <asp:Literal ID="litError" runat="server"></asp:Literal>

        <div class="space-y-8">
            <!-- Basic Info Section -->
            <div class="glass-card rounded-[32px] p-8">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-slate-400 mb-2">Tên sách</label>
                        <asp:TextBox ID="txtTenSP" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="VD: Đắc Nhân Tâm"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Tác giả</label>
                        <asp:TextBox ID="txtTacGia" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Dale Carnegie"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Thể loại</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none">
                        </asp:DropDownList>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-slate-400 mb-2">Mô tả sản phẩm</label>
                        <asp:TextBox ID="txtMoTa" runat="server" TextMode="MultiLine" Rows="6" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Nội dung tóm tắt của cuốn sách..."></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Price & Inventory Section -->
            <div class="glass-card rounded-[32px] p-8">
                <h4 class="text-sm font-bold text-slate-500 uppercase tracking-widest mb-6">Giá & Kho hàng</h4>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Giá bán (đ)</label>
                        <asp:TextBox ID="txtGia" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="0"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Giá khuyến mãi (đ)</label>
                        <asp:TextBox ID="txtGiaKhuyenMai" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Để trống nếu không giảm"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Số lượng tồn</label>
                        <asp:TextBox ID="txtSoLuongTon" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="100"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Media Section -->
            <div class="glass-card rounded-[32px] p-8">
                <h4 class="text-sm font-bold text-slate-500 uppercase tracking-widest mb-6">Hình ảnh đại diện</h4>
                <div class="flex items-start gap-8">
                    <div class="w-32 h-44 bg-slate-800 rounded-2xl overflow-hidden border border-slate-700 flex-shrink-0">
                        <asp:Image ID="imgPreview" runat="server" CssClass="w-full h-full object-cover" ImageUrl="https://placehold.co/400x550/FFF/333?text=Cover" />
                    </div>
                    <div class="flex-1">
                        <p class="text-xs text-slate-500 mb-4 leading-relaxed">Tải lên hình ảnh bìa sách chất lượng cao. Định dạng hỗ trợ: JPG, PNG, WebP. Kích thước đề xuất: 800x1200px.</p>
                        <div class="relative">
                            <asp:FileUpload ID="fuHinhAnh" runat="server" CssClass="hidden" onchange="this.form.submit()" />
                            <button type="button" onclick="document.getElementById('<%= fuHinhAnh.ClientID %>').click()" class="px-6 py-3 bg-slate-800 text-white text-sm font-bold rounded-xl border border-slate-700 hover:bg-slate-700 transition-all">Chọn tệp hình ảnh</button>
                            <asp:TextBox ID="txtHinhAnhUrl" runat="server" CssClass="mt-4 w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Hoặc nhập URL hình ảnh"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Additional Details -->
            <div class="glass-card rounded-[32px] p-8">
                <h4 class="text-sm font-bold text-slate-500 uppercase tracking-widest mb-6">Thông tin bổ sung</h4>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Loại bìa</label>
                        <asp:TextBox ID="txtLoaiBia" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Bìa mềm"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Nhà xuất bản</label>
                        <asp:TextBox ID="txtNhaXuatBan" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="NXB Trẻ"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Nhà cung cấp</label>
                        <asp:TextBox ID="txtNhaCungCap" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-3 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Fahasa"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-400 mb-2">Trạng thái</label>
                        <div class="flex items-center gap-6 mt-3">
                            <label class="flex items-center gap-2 cursor-pointer">
                                <asp:RadioButton ID="rbActive" runat="server" GroupName="Status" Checked="true" />
                                <span class="text-sm text-slate-300">Đang kinh doanh</span>
                            </label>
                            <label class="flex items-center gap-2 cursor-pointer">
                                <asp:RadioButton ID="rbInactive" runat="server" GroupName="Status" />
                                <span class="text-sm text-slate-300">Ngừng kinh doanh</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="flex items-center justify-end gap-4 py-10">
                <a href="Products.aspx" class="px-8 py-4 text-slate-400 font-bold hover:text-white transition-all">Hủy bỏ</a>
                <asp:Button ID="btnSave" runat="server" Text="Lưu thay đổi" OnClick="btnSave_Click" CssClass="px-10 py-4 bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-2xl shadow-xl shadow-blue-600/30 transition-all active:scale-95" />
            </div>
        </div>
    </div>
</asp:Content>
