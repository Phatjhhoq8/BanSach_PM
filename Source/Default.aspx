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

        <!-- 2. SÁCH BÁN CHẠY -->
        <section>
            <div class="text-center mb-8">
                <h2 class="text-[22px] font-sans font-medium text-primary uppercase tracking-widest">SÁCH BÁN CHẠY</h2>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-5 gap-x-6 gap-y-10">
                <!-- Mockup Books -->
                <div class="group flex flex-col bg-white">
                    <a href="#" class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                        <img src="https://placehold.co/400x550/FFF/333?text=Hào+Kiệt" class="w-full h-full object-contain mix-blend-multiply drop-shadow-md group-hover:scale-105 transition-transform duration-300"/>
                        <div class="absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 w-8 flex items-center justify-center rounded-full shadow-sm">-20%</div>
                    </a>
                    <div class="flex flex-col flex-1 pl-1">
                        <a href="#" class="text-[13px] font-bold text-gray-800 group-hover:text-primary line-clamp-2 leading-snug transition-colors mb-2">Boxset Hào kiệt đất phương Nam (20 cuốn)</a>
                        <div class="flex items-center gap-2 mt-auto">
                            <span class="text-sm font-bold text-primary">448.000đ</span>
                            <span class="text-[11px] text-gray-400 line-through">560.000đ</span>
                        </div>
                    </div>
                </div>
                <!-- Mockup 2 -->
                <div class="group flex flex-col bg-white">
                    <a href="#" class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                        <img src="https://placehold.co/400x550/FFF/333?text=Truyện+Ngắn" class="w-full h-full object-contain mix-blend-multiply drop-shadow-md group-hover:scale-105 transition-transform duration-300"/>
                        <div class="absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 w-8 flex items-center justify-center rounded-full shadow-sm">-20%</div>
                    </a>
                    <div class="flex flex-col flex-1 pl-1">
                        <a href="#" class="text-[13px] font-bold text-gray-800 group-hover:text-primary line-clamp-2 leading-snug transition-colors mb-2">65 truyện ngắn hay dành cho thiếu nhi</a>
                        <div class="flex items-center gap-2 mt-auto">
                            <span class="text-sm font-bold text-primary">440.000đ</span>
                            <span class="text-[11px] text-gray-400 line-through">550.000đ</span>
                        </div>
                    </div>
                </div>
                <div class="group flex flex-col bg-white">
                    <a href="#" class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                        <img src="https://placehold.co/400x550/FFF/333?text=Dị+Nhân" class="w-full h-full object-contain mix-blend-multiply drop-shadow-md group-hover:scale-105 transition-transform duration-300"/>
                        <div class="absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 w-8 flex items-center justify-center rounded-full shadow-sm">-20%</div>
                    </a>
                    <div class="flex flex-col flex-1 pl-1">
                        <a href="#" class="text-[13px] font-bold text-gray-800 group-hover:text-primary line-clamp-2 leading-snug transition-colors mb-2">Nam Hải dị nhân liệt truyện</a>
                        <div class="flex items-center gap-2 mt-auto">
                            <span class="text-sm font-bold text-primary">400.000đ</span>
                            <span class="text-[11px] text-gray-400 line-through">500.000đ</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-right mt-6">
                <a href="DanhMuc.aspx?sort=bestseller" class="text-primary font-medium hover:underline text-sm tracking-wide">Xem thêm >></a>
            </div>
        </section>

        <!-- SUB BANNER 1 -->
        <a href="#" class="block w-full rounded overflow-hidden relative cursor-pointer hover:opacity-95 transition-opacity">
            <img src="img/banner/section_banner_1.jpg" alt="Từ cuốn sách nhỏ đến thế giới lớn" class="w-full h-auto object-contain bg-gray-50"/>
        </a>

        <!-- 3. TỦ SÁCH THANH NIÊN -->
        <section>
            <div class="text-center mb-8">
                <h2 class="text-[22px] font-sans font-medium text-primary uppercase tracking-widest">TỦ SÁCH THANH NIÊN</h2>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-5 gap-x-6 gap-y-10">
                <div class="group flex flex-col bg-white">
                    <a href="#" class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                        <img src="https://placehold.co/400x550/FFF/333?text=Dấu+chân+người+lính" class="w-full h-full object-contain mix-blend-multiply drop-shadow-md group-hover:scale-105 transition-transform duration-300"/>
                        <div class="absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 w-8 flex items-center justify-center rounded-full shadow-sm">-20%</div>
                    </a>
                    <div class="flex flex-col flex-1 pl-1">
                        <a href="#" class="text-[13px] font-bold text-gray-800 group-hover:text-primary line-clamp-2 leading-snug transition-colors mb-2">Dấu chân người lính</a>
                        <div class="flex items-center gap-2 mt-auto">
                            <span class="text-sm font-bold text-primary">132.000đ</span>
                            <span class="text-[11px] text-gray-400 line-through">165.000đ</span>
                        </div>
                    </div>
                </div>
                <div class="group flex flex-col bg-white">
                    <a href="#" class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                        <img src="https://placehold.co/400x550/FFF/333?text=Garibaldi" class="w-full h-full object-contain mix-blend-multiply drop-shadow-md group-hover:scale-105 transition-transform duration-300"/>
                        <div class="absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 w-8 flex items-center justify-center rounded-full shadow-sm">-20%</div>
                    </a>
                    <div class="flex flex-col flex-1 pl-1">
                        <a href="#" class="text-[13px] font-bold text-gray-800 group-hover:text-primary line-clamp-2 leading-snug transition-colors mb-2">Garibaldi, người anh hùng áo đỏ</a>
                        <div class="flex items-center gap-2 mt-auto">
                            <span class="text-sm font-bold text-primary">52.000đ</span>
                            <span class="text-[11px] text-gray-400 line-through">65.000đ</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-right mt-6">
                <a href="DanhMuc.aspx?tl=thanhnien" class="text-primary font-medium hover:underline text-sm tracking-wide">Xem thêm >></a>
            </div>
        </section>

        <!-- SUB BANNER 2 -->
        <a href="#" class="block w-full rounded overflow-hidden relative cursor-pointer hover:opacity-95 transition-opacity">
            <img src="img/banner/section_banner_2.jpg" alt="Manga Comic" class="w-full h-auto object-contain bg-gray-50"/>
        </a>

        <!-- 4. MANGA - COMIC -->
        <section>
            <div class="text-center mb-8">
                <h2 class="text-[22px] font-sans font-medium text-primary uppercase tracking-widest">MANGA - COMIC</h2>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-5 gap-x-6 gap-y-10">
                <div class="group flex flex-col bg-white">
                    <a href="#" class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                        <img src="https://placehold.co/400x550/FFF/333?text=One+Piece" class="w-full h-full object-contain mix-blend-multiply drop-shadow-md group-hover:scale-105 transition-transform duration-300"/>
                        <div class="absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 w-8 flex items-center justify-center rounded-full shadow-sm">-20%</div>
                    </a>
                    <div class="flex flex-col flex-1 pl-1">
                        <a href="#" class="text-[13px] font-bold text-gray-800 group-hover:text-primary line-clamp-2 leading-snug transition-colors mb-2">Combo Hồ sơ One Piece (Tặng Bìa áo)</a>
                        <div class="flex items-center gap-2 mt-auto">
                            <span class="text-sm font-bold text-primary">120.000đ</span>
                            <span class="text-[11px] text-gray-400 line-through">150.000đ</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-right mt-6">
                <a href="DanhMuc.aspx?tl=manga" class="text-primary font-medium hover:underline text-sm tracking-wide">Xem thêm >></a>
            </div>
        </section>

        <!-- SUB BANNER 3 -->
        <a href="#" class="block w-full rounded overflow-hidden relative cursor-pointer hover:opacity-95 transition-opacity">
            <img src="img/banner/section_banner_3.jpg" alt="Wings Books" class="w-full h-auto object-contain bg-gray-50"/>
        </a>
        
        <!-- 5. WINGS BOOKS -->
        <section>
            <div class="text-center mb-8">
                <h2 class="text-[22px] font-sans font-medium text-primary uppercase tracking-widest">WINGS BOOKS</h2>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-5 gap-x-6 gap-y-10">
                <div class="group flex flex-col bg-white">
                    <a href="#" class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                        <img src="https://placehold.co/400x550/FFF/333?text=Phù+Thủy+Kiki" class="w-full h-full object-contain mix-blend-multiply drop-shadow-md group-hover:scale-105 transition-transform duration-300"/>
                        <div class="absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 w-8 flex items-center justify-center rounded-full shadow-sm">-20%</div>
                    </a>
                    <div class="flex flex-col flex-1 pl-1">
                        <a href="#" class="text-[13px] font-bold text-gray-800 group-hover:text-primary line-clamp-2 leading-snug transition-colors mb-2">Dịch vụ giao hàng của phù thủy Kiki</a>
                        <div class="flex items-center gap-2 mt-auto">
                            <span class="text-sm font-bold text-[#c31425]">75.000đ</span>
                            <span class="text-[11px] text-gray-400 line-through">95.000đ</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-right mt-6">
                <a href="DanhMuc.aspx?tl=wingsbooks" class="text-[#c31425] font-medium hover:underline text-sm tracking-wide">Xem thêm >></a>
            </div>
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
