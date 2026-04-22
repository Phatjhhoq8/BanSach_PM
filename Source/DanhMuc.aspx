<%@ Page Title="Danh mục sách - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="DanhMuc.aspx.cs" Inherits="DanhMuc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <!-- DYNAMIC HERO HEADER SECTION -->
    <div class="relative w-full h-[50vh] min-h-[400px] overflow-hidden bg-white">
        <!-- ASP Literal gán URL để play Video động theo logic C# -->
        <video autoplay loop muted playsinline class="absolute z-0 w-auto min-w-full min-h-full max-w-none transform -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2 object-cover opacity-100">
            <source src="<%= VideoBgUrl %>" type="video/mp4" />
        </video>
        <div class="absolute inset-0 bg-black/10 z-10"></div>
        
        <!-- Xóa các nhân vật lơ lửng theo yêu cầu -->

        <div class="absolute inset-0 z-20 flex flex-col items-center justify-center text-center px-4">
            <p class="text-accent uppercase tracking-[0.2em] font-semibold text-sm mb-2">Bộ sưu tập</p>
            <h1 class="text-4xl md:text-6xl font-bold font-heading text-white mb-6 tracking-tight drop-shadow-md">
                <asp:Literal ID="litTitle" runat="server">Tất Cả Tác Phẩm</asp:Literal>
            </h1>
        </div>
    </div>

    <!-- MAIN COLLECTION SECTION -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 flex flex-col md:flex-row gap-8 bg-white">
        <!-- SIDEBAR BỘ LỌC (KIM DONG STRUCTURE) -->
        <div class="w-full md:w-[260px] flex-shrink-0 space-y-6">
            <!-- Block 1 -->
            <div class="border border-gray-200">
                <div class="bg-primary text-white font-bold text-sm p-3 uppercase">Danh mục</div>
                <ul class="p-3 space-y-2 text-[13px] font-medium text-gray-800">
                    <li class="font-bold"><a href="#" class="hover:text-primary">TẤT CẢ SẢN PHẨM</a></li>
                    <li><a href="#" class="hover:text-primary">LỊCH SỬ, TRUYỀN THỐNG</a></li>
                    <li><a href="#" class="hover:text-primary">VĂN HỌC VIỆT NAM</a></li>
                    <li><a href="#" class="hover:text-primary">VĂN HỌC NƯỚC NGOÀI</a></li>
                    <li><a href="#" class="hover:text-primary">KIẾN THỨC, KHOA HỌC</a></li>
                    <li><a href="#" class="hover:text-primary">TRUYỆN TRANH</a></li>
                    <li><a href="#" class="hover:text-primary">MANGA - COMIC</a></li>
                    <li><a href="#" class="hover:text-primary">WINGS BOOKS</a></li>
                    <li><a href="#" class="hover:text-primary">TỦ SÁCH THANH NIÊN</a></li>
                    <li><a href="#" class="hover:text-primary">DÀNH CHO CHA MẸ</a></li>
                    <li class="pt-2 font-bold text-gray-500 border-t border-gray-100 mt-2">Độ tuổi</li>
                    <li class="pl-2"><a href="#" class="hover:text-primary text-gray-600 font-normal">Nhà trẻ - mẫu giáo (0 - 6)</a></li>
                    <li class="pl-2"><a href="#" class="hover:text-primary text-gray-600 font-normal">Nhi đồng (6 - 11)</a></li>
                    <li class="pl-2"><a href="#" class="hover:text-primary text-gray-600 font-normal">Thiếu niên (11 - 15)</a></li>
                    <li class="pl-2"><a href="#" class="hover:text-primary text-gray-600 font-normal">Tuổi mới lớn (15 - 18)</a></li>
                    <li class="pl-2"><a href="#" class="hover:text-primary text-gray-600 font-normal">Tuổi trưởng thành (Trên 18 tuổi)</a></li>
                </ul>
            </div>

            <!-- Block 2 -->
            <div class="border border-gray-200">
                <div class="bg-primary text-white font-bold text-sm p-3 uppercase flex justify-between items-center cursor-pointer">
                    THỂ LOẠI SÁCH
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                </div>
                <ul class="p-4 space-y-3 text-[13px] text-gray-700">
                    <li class="flex items-center gap-2"><input type="radio" name="tl_rad" class="text-red-600 focus:ring-red-500"/> Giải mã bản thân</li>
                    <li class="flex items-center gap-2"><input type="radio" name="tl_rad" class="text-red-600 focus:ring-red-500"/> Combo</li>
                    <li class="flex items-center gap-2"><input type="radio" name="tl_rad" class="text-red-600 focus:ring-red-500"/> Đồ dùng</li>
                    <li class="flex items-center gap-2"><input type="radio" name="tl_rad" class="text-red-600 focus:ring-red-500"/> Sách ngoại văn</li>
                    <li class="flex items-center gap-2"><input type="radio" name="tl_rad" class="text-red-600 focus:ring-red-500"/> Sách công cụ Đoàn - Đội</li>
                </ul>
            </div>

            <!-- Block 3 -->
            <div class="border border-gray-200">
                <div class="bg-primary text-white font-bold text-sm p-3 uppercase flex justify-between items-center cursor-pointer">
                    NHÀ XUẤT BẢN
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                </div>
                <ul class="p-4 space-y-3 text-[13px] text-gray-700">
                    <li class="flex items-center gap-2"><input type="radio" name="nxb_rad" class="text-red-600"/> Tagger</li>
                    <li class="flex items-center gap-2"><input type="radio" name="nxb_rad" class="text-red-600"/> Nhà Xuất Bản Kim Đồng</li>
                    <li class="flex items-center gap-2"><input type="radio" name="nxb_rad" class="text-red-600"/> Nhiều tác giả</li>
                    <li class="flex items-center gap-2"><input type="radio" name="nxb_rad" class="text-red-600"/> Kosaku Anakubo</li>
                </ul>
            </div>

            <!-- Block 4 -->
            <div class="border border-gray-200">
                <div class="bg-primary text-white font-bold text-sm p-3 uppercase flex justify-between items-center cursor-pointer">
                    KHOẢNG GIÁ
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                </div>
                <ul class="p-4 space-y-3 text-[13px] text-gray-700">
                    <li class="flex items-center gap-2"><input type="radio" name="price" /> Giá dưới 100.000đ</li>
                    <li class="flex items-center gap-2"><input type="radio" name="price" /> 100.000đ - 200.000đ</li>
                    <li class="flex items-center gap-2"><input type="radio" name="price" /> 200.000đ - 300.000đ</li>
                    <li class="flex items-center gap-2"><input type="radio" name="price" /> 300.000đ - 500.000đ</li>
                    <li class="flex items-center gap-2"><input type="radio" name="price" /> 500.000đ - 1.000.000đ</li>
                </ul>
            </div>
        </div>

        <!-- Book Grid (Mainside) -->
        <div class="flex-1">
            <!-- Toolbar sorting -->
            <div class="flex justify-between items-center mb-6 pb-2 border-b border-gray-200">
                <h2 class="text-xl font-bold uppercase">Tất Cả Sản Phẩm</h2>
                <div class="flex items-center gap-2 text-[13px]">
                    <span class="text-gray-500">Sắp xếp:</span>
                    <select class="border border-gray-300 rounded px-3 py-1.5 focus:ring-primary focus:border-primary outline-none">
                        <option>Mặc định</option>
                        <option>Giá tăng dần</option>
                        <option>Giá giảm dần</option>
                        <option>Tên A-Z</option>
                    </select>
                </div>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-x-4 gap-y-10">
                <asp:Repeater ID="rptSach" runat="server">
                    <ItemTemplate>
                        <div class="group flex flex-col bg-white">
                            <!-- Ảnh sách -->
                            <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="block relative aspect-w-3 aspect-h-4 bg-transparent overflow-hidden mb-3">
                                <img src='<%# "img/books/" + Eval("HinhAnh") %>' onerror="this.src='https://placehold.co/400x550/FFF/333?text=Book';" alt='<%# Eval("TenSP") %>' class="w-full h-full object-contain mix-blend-multiply drop-shadow-sm group-hover:drop-shadow-md transition-all duration-300"/>
                                <div class="absolute top-1 right-1 bg-rose-500 text-white text-[11px] font-bold h-8 w-8 flex items-center justify-center rounded-full shadow-sm">-20%</div>
                            </a>
                            <div class="flex flex-col flex-1">
                                <a href='ChiTiet.aspx?id=<%# Eval("MaSP") %>' class="text-[13px] font-bold text-gray-800 hover:text-primary line-clamp-2 leading-snug transition-colors mb-2"><%# Eval("TenSP") %></a>
                                <div class="flex items-center gap-2 mt-auto">
                                    <span class="text-[13px] font-bold text-primary"><%# string.Format("{0:N0}đ", Eval("Gia")) %></span>
                                    <span class="text-[11px] text-gray-400 line-through"><%# string.Format("{0:N0}đ", Convert.ToDecimal(Eval("Gia")) * 1.25m) %></span>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            
            <asp:Label ID="LabelNoData" runat="server" Text="Đang cập nhật thêm sách cho bộ sưu tập này." Visible="false" CssClass="text-gray-400 font-light italic mt-12 text-center block" />
        </div>
    </div>
</asp:Content>
