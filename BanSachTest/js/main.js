// Swiperjs
const swiperBanner = new Swiper('#swiper-banner', {
  speed: 1000,
  slidesPerView: 'auto',
  autoplay: {
    delay: 8000,
    disableOnInteraction: false,
  },
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
})

const swiperShowProduct = {
  slidesPerView: 4,
  spaceBetween: 30,
  slidesPerGroup: 1,
  loop: true,
  loopFillGroupWithBlank: true,
  breakpoints: {
    1024: {
      slidesPerView: 6,
    },
    768: {
      slidesPerView: 4,
    },
    640: {
      slidesPerView: 2,
    },
    500: {
      slidesPerView: 2,
    },
  },
  pagination: {
    el: '.swiper-pagination',
    clickable: true,
  },
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
}

const swiperTrend = new Swiper('#swiper-trend', swiperShowProduct)
const swiperTextbook = new Swiper('#swiper-textbook', swiperShowProduct)

const body = document.querySelector('body')
const hamburgerIcon = document.getElementById('hamburger')
const menu = document.getElementById('menu')
const menuOverlay = document.getElementById('menu-overlay')

function showMenu() {
  menu.style.display = 'block'
}

function hiddenMenu() {
  menu.style.display = 'none'
}

hamburgerIcon.addEventListener('click', showMenu)
menuOverlay.addEventListener('click', hiddenMenu)

window.onresize = function () {
  if (this.innerWidth > 1024) {
    menu.style.display = 'block'
  } else {
    menu.style.display = 'none'
  }
  currentSliderPerView()
}
