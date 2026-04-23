<%@ Page Title="Chi tiết sách - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="ChiTiet.aspx.cs" Inherits="ChiTiet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style>
        :root {
            --book-primary: #1e293b;
            --bg-adaptive: #f8fafc;
            --shine-x: 50%;
            --shine-y: 50%;
        }

        .preview-stage {
            background: radial-gradient(circle at center, var(--bg-adaptive) 0%, #ffffff 100%);
            perspective: 5000px; /* High perspective for natural proportions */
            perspective-origin: 50% 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 0;
            transition: background 1.5s ease;
        }

        .book-container {
            position: relative;
            transform-style: preserve-3d;
            filter: drop-shadow(0 30px 60px rgba(0,0,0,0.15));
        }

        .book-3d {
            width: 320px;
            height: 480px;
            position: relative;
            transform-style: preserve-3d;
            transform: rotateY(-25deg) rotateX(10deg);
            cursor: grab;
            will-change: transform;
        }

        .book-face {
            position: absolute;
            background-color: #f3f0e8;
            backface-visibility: hidden;
            -webkit-backface-visibility: hidden;
            top: 0;
            left: 0;
        }

        /* Front Cover */
        /* Front Cover */
        .book-front {
            width: 320px;
            height: 480px;
            transform: rotateY(0deg) translateZ(25px);
            background-size: cover;
            border-radius: 2px;
            z-index: 5;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 40px;
            overflow: hidden;
            box-shadow: inset 0 0 15px rgba(0,0,0,0.1);
        }

        /* Ambient light */
        .book-front::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to right, rgba(0,0,0,0.1), transparent 15%);
            pointer-events: none;
            z-index: 2;
        }

        /* Moving light SOURCE reflection */
        .book-front::after {
            content: '';
            position: absolute;
            inset: -100%;
            background: radial-gradient(
                circle at var(--shine-x) var(--shine-y), 
                rgba(255, 255, 255, 0.45) 0%, 
                transparent 35%
            );
            pointer-events: none;
            z-index: 10;
            mix-blend-mode: soft-light;
        }

        /* Cover Title Glitter Logic */
        .cover-title-group {
            position: relative;
            z-index: 20;
            text-transform: uppercase;
            letter-spacing: 2px;
            line-height: 1.1;
        }
        .cover-title-base {
            font-family: 'Cormorant', serif;
            font-size: 24px;
            font-weight: 700;
            color: #a8947b; /* Elegant Gold-Bronze base */
            opacity: 0.6;
        }
        .cover-title-shine {
            position: absolute;
            inset: 0;
            font-family: 'Cormorant', serif;
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, #fff 0%, #d4af37 25%, #fff 50%, #d4af37 75%, #fff 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            mask-image: radial-gradient(circle at var(--shine-x) var(--shine-y), #000 0%, transparent 25%);
            -webkit-mask-image: radial-gradient(circle at var(--shine-x) var(--shine-y), #000 0%, transparent 25%);
            mask-size: 200% 200%;
            -webkit-mask-size: 200% 200%;
            pointer-events: none;
            filter: drop-shadow(0 0 10px rgba(212, 175, 55, 0.8));
            z-index: 21;
        }

        .book-back {
            width: 320px;
            height: 480px;
            transform: rotateY(180deg) translateZ(25px);
            background: #f3f0e8;
            border-radius: 2px;
        }

        .book-spine {
            width: 50px;
            height: 480px;
            left: 135px;
            transform: rotateY(-90deg) translateZ(160px);
            background: var(--book-primary);
            background-image: linear-gradient(to right, rgba(0,0,0,0.15), transparent 15%, transparent 85%, rgba(0,0,0,0.15));
        }

        .book-right {
            width: 50px; 
            height: 480px;
            left: 135px;
            transform: rotateY(90deg) translateZ(160px);
            background: #fff;
            background-image: repeating-linear-gradient(90deg, #fff, #fff 2px, #e5e7eb 3px);
        }

        .book-top {
            width: 320px;
            height: 50px;
            top: 215px;
            transform: rotateX(90deg) translateZ(240px);
            background: #fff;
            background-image: repeating-linear-gradient(0deg, #fff, #fff 2px, #e5e7eb 3px);
        }

        .book-bottom {
            width: 320px;
            height: 50px;
            top: 215px;
            transform: rotateX(-90deg) translateZ(240px);
            background: #fff;
            background-image: repeating-linear-gradient(0deg, #fff, #fff 2px, #e5e7eb 3px);
        }

        .headband {
            position: absolute;
            height: 6px;
            width: 50px;
            left: 0;
            top: 0;
            background: repeating-linear-gradient(to right, #634d31, #634d31 2px, #d4c5b3 2px, #d4c5b3 4px);
            transform: rotateX(90deg) translateZ(241px) rotateY(-90deg) translateX(-25px);
        }

        .metallic-text {
            background: linear-gradient(135deg, var(--book-primary) 0%, #fff 50%, var(--book-primary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .glass-detail {
            background: rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border: 1px solid rgba(255, 255, 255, 0.4);
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
                <!-- Left Column: Interactive 3D Book -->
                <div class="w-full lg:w-[45%] flex justify-center select-none py-10 lg:py-0">
                    <div class="book-container shadow-inner" id="rotateContainer">
                        <div class="book-3d" id="book3D">
                            <!-- Front -->
                            <div class="book-face book-front" id="bookFront" runat="server">
                                <div class="cover-title-group">
                                    <h4 class="cover-title-base"><asp:Literal ID="litTitleCover" runat="server"></asp:Literal></h4>
                                    <div class="cover-title-shine"><asp:Literal ID="litTitleCoverShine" runat="server"></asp:Literal></div>
                                </div>
                                <div class="absolute inset-0 bg-gradient-to-tr from-black/5 to-transparent pointer-events-none z-10"></div>
                            </div>
                            <!-- Back -->
                            <div class="book-face book-back border-l border-black/5 flex flex-col items-center justify-center p-8 text-center bg-[#f3f0e8]">
                                <div class="w-16 h-16 bg-black/5 rounded-full mb-4"></div>
                                <div class="mt-auto text-[10px] text-gray-400 uppercase tracking-widest">Premium Quality</div>
                            </div>
                            <!-- Spine -->
                            <div class="book-face book-spine flex items-center justify-center">
                                <span class="text-[10px] text-white/40 font-bold uppercase rotate-90 whitespace-nowrap tracking-widest">Premium Books</span>
                            </div>
                            <!-- Right (Pages) -->
                            <div class="book-face book-right"></div>
                            <!-- Top (Pages) -->
                            <div class="book-face book-top">
                                <div class="headband"></div>
                            </div>
                            <!-- Bottom (Pages) -->
                            <div class="book-face book-bottom"></div>
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

                            <button type="button" class="w-full bg-primary text-white py-5 rounded-2xl font-bold text-lg hover:bg-secondary transition-all shadow-xl shadow-primary/30 flex items-center justify-center gap-4 active:scale-95 group">
                                <svg class="w-6 h-6 group-hover:rotate-12 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                                Add to Collection
                            </button>
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
        const book = document.getElementById('book3D');
        const container = document.getElementById('rotateContainer');
        const stage = document.getElementById('stage');
        
        let isDragging = false;
        let startX, startY;
        let currentRotateY = -25;
        let currentRotateX = 10;

        function updateReflection(ry, rx) {
            // High-precision light mapping for fixed source effect
            // We map the rotation to a radial gradient center point
            let shineX = 50 - (ry * 0.8); 
            let shineY = 50 + (rx * 1.2);
            
            document.documentElement.style.setProperty('--shine-x', `${shineX}%`);
            document.documentElement.style.setProperty('--shine-y', `${shineY}%`);
        }

        // Adaptive Color Logic
        const primaryColor = getComputedStyle(document.documentElement).getPropertyValue('--book-primary').trim() || '#0284c7';
        stage.style.background = `radial-gradient(circle at center, ${primaryColor}15 0%, #ffffff 100%)`;

        // Initialize reflection
        updateReflection(currentRotateY, currentRotateX);

        container.addEventListener('mousedown', (e) => {
            isDragging = true;
            startX = e.pageX;
            startY = e.pageY;
            book.style.animation = 'none';
            book.style.transition = 'none';
        });

        window.addEventListener('mousemove', (e) => {
            if (!isDragging) return;
            const deltaX = e.pageX - startX;
            const deltaY = e.pageY - startY;
            const ry = currentRotateY + (deltaX * 0.4); // Slower for block stability
            const rx = currentRotateX - (deltaY * 0.4);
            book.style.transform = `rotateY(${ry}deg) rotateX(${rx}deg)`;
            updateReflection(ry, rx);
        });

        window.addEventListener('mouseup', (e) => {
            if (!isDragging) return;
            isDragging = false;
            const deltaX = e.pageX - startX;
            const deltaY = e.pageY - startY;
            currentRotateY += (deltaX * 0.4);
            currentRotateX -= (deltaY * 0.4);
            book.style.transition = 'transform 0.8s cubic-bezier(0.165, 0.84, 0.44, 1)';
        });

        // Touch support
        container.addEventListener('touchstart', (e) => {
            isDragging = true;
            startX = e.touches[0].pageX;
            startY = e.touches[0].pageY;
            book.style.animation = 'none';
            book.style.transition = 'none';
        });
        window.addEventListener('touchmove', (e) => {
            if (!isDragging) return;
            const deltaX = e.touches[0].pageX - startX;
            const deltaY = e.touches[0].pageY - startY;
            const ry = currentRotateY + (deltaX * 0.4);
            const rx = currentRotateX - (deltaY * 0.4);
            book.style.transform = `rotateY(${ry}deg) rotateX(${rx}deg)`;
            updateReflection(ry, rx);
        });
        window.addEventListener('touchend', () => { isDragging = false; book.style.transition = 'transform 0.8s cubic-bezier(0.165, 0.84, 0.44, 1)'; });
    </script>
</asp:Content>
