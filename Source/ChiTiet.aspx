<%@ Page Title="Chi tiết sách - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="ChiTiet.aspx.cs" Inherits="ChiTiet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style>
        :root {
            --book-primary: #92400E;
            --bg-adaptive: #FFFBEB;
        }

        .preview-stage {
            background: radial-gradient(circle at center, var(--bg-adaptive) 0%, #ffffff 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 0;
            transition: background 1.5s ease;
        }

        .book-view-container {
            position: relative;
            width: 380px;
            max-width: 100%;
            transition: all 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
            filter: drop-shadow(0 30px 50px rgba(0,0,0,0.2));
        }

        .book-view-container:hover {
            transform: translateY(-15px) rotate(-2deg) scale(1.03);
            filter: drop-shadow(0 40px 70px rgba(0,0,0,0.25));
        }

        .book-main-image {
            width: 100%;
            height: 560px;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            border-radius: 8px 16px 16px 8px; /* Classic book curve */
            position: relative;
            overflow: hidden;
            border-left: 2px solid rgba(0,0,0,0.1);
        }

        /* Spine shadow effect */
        .book-main-image::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 25px;
            background: linear-gradient(to right, 
                rgba(0,0,0,0.2) 0%, 
                rgba(0,0,0,0.05) 40%, 
                transparent 100%);
            z-index: 2;
        }

        /* Highlight edge */
        .book-main-image::after {
            content: '';
            position: absolute;
            left: 10px;
            top: 0;
            bottom: 0;
            width: 1px;
            background: rgba(255,255,255,0.1);
            z-index: 3;
        }

        .cover-overlay {
            position: absolute;
            inset: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px;
            text-align: center;
            z-index: 10;
            background: rgba(0,0,0,0.02);
        }

        .cover-title-text {
            font-family: 'Noto Serif', serif;
            font-size: 28px;
            font-weight: 700;
            color: #1e293b;
            text-shadow: 0 2px 4px rgba(255,255,255,0.8);
            line-height: 1.2;
        }

        .glass-detail {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.5);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="bg-white min-h-screen">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-10">
            <!-- Breadcrumbs -->
            <nav class="flex text-sm font-medium text-gray-500">
                <a href="Default.aspx" class="hover:text-primary transition">Trang chủ</a>
                <span class="mx-2">/</span>
                <span class="text-gray-900"><asp:Literal ID="litBreadcrumb" runat="server">Chi tiết sản phẩm</asp:Literal></span>
            </nav>
        </div>

        <div class="preview-stage mt-10" id="stage">
            <div class="flex flex-col lg:flex-row gap-10 lg:gap-20 items-center justify-center max-w-7xl mx-auto px-6 w-full">
                <!-- Left Column: Premium Book Image -->
                <div class="w-full lg:w-[45%] flex justify-center py-10 lg:py-0">
                    <div class="book-view-container">
                        <div class="book-main-image shadow-2xl" id="bookFront" runat="server">
                            <div class="cover-overlay">
                                <h4 class="cover-title-text"><asp:Literal ID="litTitleCover" runat="server"></asp:Literal></h4>
                                <div class="hidden"><asp:Literal ID="litTitleCoverShine" runat="server"></asp:Literal></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Product Info -->
                <div class="w-full lg:w-[50%]">
                    <div class="glass-detail p-10 rounded-[40px] shadow-2xl relative overflow-hidden">
                        <div class="absolute -top-24 -right-24 w-48 h-48 bg-primary/20 rounded-full blur-3xl"></div>
                        <div class="relative z-10">
                            <span class="inline-block px-4 py-1.5 bg-primary/10 text-primary text-[10px] font-bold uppercase tracking-[0.2em] rounded-full mb-6">Premium Edition</span>
                            <h1 class="text-4xl md:text-5xl font-bold font-heading leading-tight mb-4">
                                <span class="text-slate-900"><asp:Literal ID="litTenSP" runat="server"></asp:Literal></span>
                            </h1>
                            <p class="text-xl text-gray-400 mb-8">By <span class="text-primary"><asp:Literal ID="litTacGia" runat="server"></asp:Literal></span></p>
                            
                            <div class="flex items-center gap-8 border-y border-gray-100/50 py-8 my-8">
                                <div class="text-3xl font-bold text-gray-900 tracking-tighter">
                                    <asp:Literal ID="litGia" runat="server"></asp:Literal>
                                </div>
                                <div class="text-lg text-gray-300 line-through" id="oldPriceContainer" runat="server"><asp:Literal ID="litGiaGoc" runat="server"></asp:Literal></div>
                                <span class="bg-rose-500 text-white px-3 py-1 text-xs font-black rounded-lg" id="discountBadge" runat="server"><asp:Literal ID="litDiscount" runat="server"></asp:Literal></span>
                            </div>

                            <p class="text-gray-500 italic opacity-80 mb-10 leading-relaxed text-lg">
                                <asp:Literal ID="litMoTa" runat="server"></asp:Literal>
                            </p>

                            <button type="button" onclick="addToCart(this)" data-id='<asp:Literal ID="litMaSP" runat="server"></asp:Literal>' class="w-full bg-primary text-white py-5 rounded-2xl font-bold text-lg hover:bg-secondary transition-all shadow-xl shadow-primary/30 flex items-center justify-center gap-4 active:scale-95 group">
                                <svg class="w-6 h-6 group-hover:rotate-12 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                                Thêm vào giỏ hàng
                            </button>
                            <a href="Wishlist.aspx" class="mt-4 min-h-[44px] w-full border border-amber-200 bg-white text-zinc-800 py-3 rounded-2xl font-bold text-sm hover:border-primary hover:text-primary transition-all flex items-center justify-center gap-3">
                                Lưu vào danh sách yêu thích
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Meta section -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 grid grid-cols-2 md:grid-cols-4 gap-12 text-center">
            <div class="group">
                <span class="text-gray-400 text-xs uppercase tracking-widest block mb-2">Quality</span>
                <span class="text-lg font-bold text-gray-900 group-hover:text-primary transition"><asp:Literal ID="litCoverType" runat="server">Đang cập nhật</asp:Literal></span>
            </div>
            <div class="group">
                <span class="text-gray-400 text-xs uppercase tracking-widest block mb-2">Nhà cung cấp</span>
                <span class="text-lg font-bold text-gray-900 group-hover:text-primary transition"><asp:Literal ID="litSupplier" runat="server">Fahasa</asp:Literal></span>
            </div>
            <div class="group">
                <span class="text-gray-400 text-xs uppercase tracking-widest block mb-2">Đánh giá</span>
                <span class="text-lg font-bold text-gray-900 group-hover:text-primary transition"><asp:Literal ID="litRating" runat="server">Chưa có đánh giá</asp:Literal></span>
            </div>
            <div class="group">
                <span class="text-gray-400 text-xs uppercase tracking-widest block mb-2">Publisher</span>
                <span class="text-lg font-bold text-gray-900 group-hover:text-primary transition"><asp:Literal ID="litPublisher" runat="server">Đang cập nhật</asp:Literal></span>
            </div>
        </div>
    </div>

    <script>
        // Adaptive Color Logic
        const stage = document.getElementById('stage');
        const primaryColor = getComputedStyle(document.documentElement).getPropertyValue('--book-primary').trim() || '#92400E';
        stage.style.background = `radial-gradient(circle at center, ${primaryColor}15 0%, #ffffff 100%)`;

        function addToCart(btn) {
            const id = btn.getAttribute('data-id');
            const originalText = btn.innerHTML;
            
            btn.disabled = true;
            btn.innerHTML = '<svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> Đang thêm...';

            fetch(`CartHandler.ashx?action=add&maSP=${id}`)
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        btn.classList.replace('bg-primary', 'bg-emerald-500');
                        btn.innerHTML = '<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> Đã thêm vào bộ sưu tập!';
                        document.getElementById('cartCount').innerText = data.cartCount;
                        setTimeout(() => {
                            btn.classList.replace('bg-emerald-500', 'bg-primary');
                            btn.innerHTML = originalText;
                            btn.disabled = false;
                        }, 3000);
                    } else if (data.code === 'auth_required') {
                        window.location.href = `Login.aspx?ReturnUrl=${window.location.pathname}${window.location.search}`;
                    } else {
                        alert(data.message);
                        btn.innerHTML = originalText;
                        btn.disabled = false;
                    }
                });
        }
    </script>
</asp:Content>
