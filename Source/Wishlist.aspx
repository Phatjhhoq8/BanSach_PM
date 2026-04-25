<%@ Page Title="Danh sách yêu thích - Nhà Sách Premium" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Wishlist.aspx.cs" Inherits="Wishlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="flex items-end justify-between gap-4 mb-10">
            <div>
                <p class="text-primary font-bold uppercase tracking-[0.24em] text-sm mb-3">Tài khoản</p>
                <h1 class="font-heading text-4xl font-bold text-zinc-950">Danh sách yêu thích</h1>
            </div>
            <a href="DanhMuc.aspx" class="text-primary font-bold hover:text-amber-800 transition-colors">Tiếp tục khám phá</a>
        </div>
        <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
            <div class="bg-white rounded-[32px] border border-amber-100 p-12 text-center text-zinc-600">Bạn chưa lưu sản phẩm yêu thích nào. Hãy quay lại danh mục và chọn sách muốn theo dõi.</div>
        </asp:PlaceHolder>
        <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-6">
            <asp:Repeater ID="rptWishlist" runat="server">
                <ItemTemplate>
                    <article class="group bg-white rounded-3xl border border-amber-100 p-4 hover:shadow-xl transition-shadow">
                        <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>'>
                            <img src='<%# Eval("HinhAnh") %>' alt='<%# Eval("TenSP") %>' class="w-full aspect-[3/4] object-contain rounded-2xl bg-amber-50" loading="lazy" />
                            <h2 class="mt-4 text-sm font-bold text-zinc-900 line-clamp-2 group-hover:text-primary transition-colors"><%# Eval("TenSP") %></h2>
                        </a>
                        <p class="mt-2 text-sm font-bold text-primary"><%# Eval("GiaHienThi", "{0:N0}đ") %></p>
                        <button type="button" onclick="removeWishlist(<%# Eval("MaSP") %>, this)" class="mt-3 w-full rounded-full border border-rose-100 px-3 py-2 text-xs font-black text-rose-600 hover:bg-rose-50">Xóa yêu thích</button>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    <script>
        function removeWishlist(maSP, btn) {
            btn.disabled = true;
            const formData = new URLSearchParams();
            formData.append('action', 'remove');
            formData.append('maSP', maSP);
            fetch('WishlistHandler.ashx', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    if (data.success) window.location.reload();
                    else alert(data.message || 'Không thể xóa yêu thích.');
                    btn.disabled = false;
                })
                .catch(() => { alert('Đã xảy ra lỗi mạng.'); btn.disabled = false; });
        }
    </script>
</asp:Content>
