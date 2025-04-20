/**
 * 게시판 렌더링 클래스
 * @author : doil
 */
class CmsBbsMng {
  constructor(el, bbs_id) {
    this.container = typeof el === 'string' ? document.querySelector(el) : el;
    this.bbs_id = bbs_id;
    this.bbsInfo = null;
    this.galleryInstance = null;

    this._init();
  }

  async _init() {
    try {
      const res = await fetch(`/cms/bbs/getBBSInfo/${this.bbs_id}`);
      this.bbsInfo = await res.json();

      if (!this.bbsInfo) {
        this._renderError("게시판 정보를 불러올 수 없습니다.");
        return;
      }

      switch (Number(this.bbsInfo.bbs_type)) {
        case 2:
          this._renderGallery();
          break;
        case 3:
          this._renderSlider();
          break;
        default:
          this._renderList(); // 1, 4 등
          break;
      }


    } catch (e) {
      console.error(e);
      this._renderError("서버 오류가 발생했습니다.");
    }
  }

  _renderGallery() {
    this.container.innerHTML = `
      <div class="gallery-wrap" id="bbsGallery">
        <a href="/static/img/hello.jpg" class="glightbox" data-gallery="bbsGallery">
          <img src="/static/img/hello.jpg" alt="샘플 이미지" style="width:200px; height:auto;">
        </a>
      </div>
    `;

    // 💡 GLightbox 인스턴스 생성
    this.galleryInstance = GLightbox({
      selector: '#bbsGallery .glightbox'
    });
  }

  _renderSlider() {
    this.container.innerHTML = `
      <div class="swiper-container" id="bbsSlider">
        <div class="swiper mySwiper">
          <div class="swiper-wrapper">
            <!-- 슬라이드 내용은 setData()에서 추가 -->
          </div>
          <div class="swiper-pagination"></div>
          <div class="swiper-button-next"></div>
          <div class="swiper-button-prev"></div>
        </div>
      </div>
    `;

    // Swiper 인스턴스 초기화
    this.swiper = new Swiper(".mySwiper", {
      loop: true,
      pagination: {
        el: ".swiper-pagination",
        clickable: true
      },
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev"
      }
    });
  }


  _renderList() {
    this.container.innerHTML = `<div>📋 게시판 </div>`;
  }

  _renderError(msg) {
    this.container.innerHTML = `<div style="color:red;">${msg}</div>`;
  }

  setData(dataList) {
    const type = Number(this.bbsInfo?.bbs_type);

    if (type === 3 && this.swiper) {
      const wrapper = this.container.querySelector(".swiper-wrapper");
      wrapper.innerHTML = ''; // 기존 슬라이드 제거

      dataList.forEach(item => {
        const slide = document.createElement('div');
        slide.className = 'swiper-slide';
        slide.innerHTML = `<img src="${item.image_url}" alt="${item.title || ''}" style="width:100%; height:auto;">`;
        wrapper.appendChild(slide);
      });

      this.swiper.update(); // 슬라이드 갱신
    }
   }
}


// 전역 노출용
window.CmsBbsMng = CmsBbsMng;
