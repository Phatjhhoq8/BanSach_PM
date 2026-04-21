<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HomeCT.ascx.cs" Inherits="BanSachTest.UserUI.HomeCT" %>
<!-- show products -->
    <div class="container mx-auto mb-4">
      <!-- best-selling -->
      <div class="bg-white mt-4">
        <!-- heading -->
        <div class="py-3 px-6 bg-gradient-to-l from-secondary-500 to-primary-600"><h2 class="uppercase text-white font-semibold text-lg">xu hướng</h2></div>
        <!-- wrapper - inner products -->
        <div id="swiper-trend" class="swiper mySwiper pt-5">
          <div class="swiper-wrapper">

              <% for(int i=0;i<listSPXuHuong.Count;i++)
                 { %>

            <div class="swiper-slide hover:shadow-xl h-auto">
              <!-- thumbnail -->
              <div class="p-1"><img class="w-full h-auto" src='<%="./img/products/trending/"+listSPXuHuong[i].HinhAnh %>' alt="trending" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#"><%=listSPXuHuong[i].TenSach %></a>
                <div class="mt-1 text-base text-primary-700"><%=listSPXuHuong[i].Gia.ToString() %></div>
                <div class="text-sm text-gray-500 line-through"></div>
              </div>
            </div>
            
              <% } %>

          </div>
          <div class="swiper-button-next text-primary-400"></div>
          <div class="swiper-button-prev text-primary-400"></div>
          <div class="swiper-pagination"></div>
        </div>
        <!-- button - see more -->
        <div class="flex justify-center py-5">
          <a
            class="block p-3 w-52 text-center rounded-3xl text-sm font-semibold text-white bg-gradient-to-r from-secondary-500 to-primary-600"
            href="#"
            >Xem Thêm</a
          >
        </div>
      </div>

      <!-- textbook - sach giao khoa -->
      <div class="bg-white mt-4">
        <!-- heading -->
        <div class="py-3 px-6 bg-gradient-to-l from-secondary-500 to-primary-600"><h2 class="uppercase text-white font-semibold text-lg">sách giáo khoa</h2></div>
        <!-- wrapper - inner products -->
        <div id="swiper-textbook" class="swiper mySwiper pt-5">
          <div class="swiper-wrapper">
            <div class="swiper-slide hover:shadow-xl h-auto">
              <!-- thumbnail -->
              <div class="p-1"><img class="w-full h-auto" src="./img/products/textbook/1.jpg" alt="textbook" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#">Tập Bài Hát 3 (2021)</a>
                <div class="mt-1 text-base text-primary-700">2.350</div>
                <div class="text-sm text-gray-500 line-through">4.700</div>
              </div>
            </div>
            <div class="swiper-slide hover:shadow-xl h-auto">
              <div class="p-1"><img class="w-full h-auto" src="./img/products/textbook/2.jpg" alt="textbook" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#">Dr.STONE - Tập 14: Bộ Mặt Thật Của Medusa</a>
                <div class="mt-1 text-base text-primary-700">25.000</div>
                <div class="text-sm text-gray-500 line-through"></div>
              </div>
            </div>
            <div class="swiper-slide hover:shadow-xl h-auto">
              <div class="p-1"><img class="w-full h-auto" src="./img/products/textbook/3.jpg" alt="textbook" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#">Komi - Nữ Thần Sợ Giao Tiếp - Tập 6 - Tặng Kèm SNS Card</a>
                <div class="mt-1 text-base text-primary-700">25.000</div>
                <div class="text-sm text-gray-500 line-through"></div>
              </div>
            </div>
            <div class="swiper-slide hover:shadow-xl h-auto">
              <div class="p-1"><img class="w-full h-auto" src="./img/products/textbook/4.jpg" alt="textbook" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#">Altair - Cánh Đại Bàng Kiêu Hãnh - Tập 20</a>
                <div class="mt-1 text-base text-primary-700">30.000</div>
                <div class="text-sm text-gray-500 line-through"></div>
              </div>
            </div>
            <div class="swiper-slide hover:shadow-xl h-auto">
              <div class="p-1"><img class="w-full h-auto" src="./img/products/textbook/5.jpg" alt="textbook" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#">Boruto - Naruto Hậu Sinh Khả Úy - Tập 11: Đội 7 Thế Hệ Mới</a>
                <div class="mt-1 text-base text-primary-700">25.000</div>
                <div class="text-sm text-gray-500 line-through">25.000</div>
              </div>
            </div>
            <div class="swiper-slide hover:shadow-xl h-auto">
              <div class="p-1"><img class="w-full h-auto" src="./img/products/textbook/6.jpg" alt="textbook" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#">Đội Quân Nhí Nhố - Tập 36</a>
                <div class="mt-1 text-base text-primary-700">20.000</div>
                <div class="text-sm text-gray-500 line-through"></div>
              </div>
            </div>
            <div class="swiper-slide hover:shadow-xl h-auto">
              <div class="p-1"><img class="w-full h-auto" src="./img/products/textbook/7.jpg" alt="textbook" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#">Khí Chất Bao Nhiêu, Hạnh Phúc Bấy Nhiêu (Tái Bản 2022)</a>
                <div class="mt-1 text-base text-primary-700">120.930</div>
                <div class="text-sm text-gray-500 line-through">139.000</div>
              </div>
            </div>
            <div class="swiper-slide hover:shadow-xl h-auto">
              <div class="p-1"><img class="w-full h-auto" src="./img/products/textbook/8.jpg" alt="textbook" /></div>
              <!-- infomation: title - price - price old -->
              <div class="p-2">
                <a class="text-sm block line-clamp-2" href="#">Ý Tưởng Lớn Dành Cho Các Triết Gia Nhỏ - Aristotle Nói Về Hạnh Phúc</a>
                <div class="mt-1 text-base text-primary-700">15.660</div>
                <div class="text-sm text-gray-500 line-through">18.000</div>
              </div>
            </div>
          </div>
          <div class="swiper-button-next text-primary-400"></div>
          <div class="swiper-button-prev text-primary-400"></div>
          <div class="swiper-pagination"></div>
        </div>
        <!-- button - see more -->
        <div class="flex justify-center py-5">
          <a
            class="block p-3 w-52 text-center rounded-3xl text-sm font-semibold text-white bg-gradient-to-r from-secondary-500 to-primary-600"
            href="#"
            >Xem Thêm</a
          >
        </div>
      </div>

    </div>