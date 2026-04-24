<%@ Page Title="Trang chủ - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <!-- HERO SECTION (Banner from nxbkimdong / Video Banner Hero requirement) -->
    <div class="relative w-full h-[65vh] min-h-[450px] overflow-hidden bg-white mt-4">
        <video autoplay loop muted playsinline class="absolute z-0 w-auto min-w-full min-h-full max-w-none transform -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2 object-cover">
            <source src="videos/cartoon.mp4" type="video/mp4" />
        </video>
        <div class="absolute inset-0 z-20 flex flex-col items-center justify-center text-center px-4">
        </div>
    </div>

    <!-- MAIN BODY SECTIONS (KIM DONG STRUCTURE) -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 space-y-20 bg-white">

        <!-- 1. SÁCH MỚI -->
        <section>
            <div class="text-center mb-8">
                <h2 class="text-[22px] font-sans font-medium text-primary uppercase tracking-widest">SÁCH MỚI PHÁT HÀNH</h2>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-x-6 gap-y-10">
                <asp:Repeater ID="rptSachNoiBat" runat="server">
                    <ItemTemplate>
                        <div class="group flex flex-col bg-white">
                            <!-- Ảnh sách -->
                            <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                                <img src='<%# Eval("DisplayImageUrl") %>' onerror="this.src='https://placehold.co/400x550/FFF/333?text=Book';" alt='<%# Eval("TenSP") %>' class="w-full h-full object-contain mix-blend-multiply drop-shadow-md group-hover:scale-105 transition-transform duration-300"/>
                                <div class='<%# string.IsNullOrEmpty(Eval("DiscountText") as string) ? "hidden" : "absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 min-w-8 px-2 flex items-center justify-center rounded-full shadow-sm" %>'><%# Eval("DiscountText") %></div>
                            </a>
                            <div class="flex flex-col flex-1 pl-1">
                                <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="text-[13px] font-bold text-gray-800 group-hover:text-primary line-clamp-2 leading-snug transition-colors mb-2"><%# Eval("TenSP") %></a>
                                <p class="text-[11px] text-gray-500 line-clamp-1 mb-2"><%# Eval("TacGia") %></p>
                                <div class="flex items-center gap-2 mt-auto">
                                    <span class="text-sm font-bold text-primary"><%# Eval("GiaText") %></span>
                                    <span class='<%# string.IsNullOrEmpty(Eval("GiaGocText") as string) ? "hidden" : "text-[11px] text-gray-400 line-through" %>'><%# Eval("GiaGocText") %></span>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="text-right mt-6">
                <a href="DanhMuc.aspx?sort=new" class="text-primary font-medium hover:underline text-sm tracking-wide">Xem thêm >></a>
            </div>
            <asp:Label ID="LabelNoData" runat="server" Text="Chưa có dữ liệu sách trong hệ thống." Visible="false" CssClass="text-gray-400 font-light italic mt-6 text-center block" />
        </section>









    </div>

    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" Runat="Server">
    <script>
        function addToCart(maSP) {
            let formData = new URLSearchParams();
            formData.append("action", "add");
            formData.append("maSP", maSP);

            fetch("CartHandler.ashx", {
                method: "POST",
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    alert("Thành công: " + data.message);
                    let countEl = document.getElementById('cartCount');
                    // data.cartCount or just increment
                    countEl.innerText = parseInt(countEl.innerText) + 1;
                } else {
                    alert("Lỗi: " + data.message);
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("Đã xảy ra lỗi mạng khi thêm vào giỏ hàng.");
            });
        }
    </script>
</asp:Content>
