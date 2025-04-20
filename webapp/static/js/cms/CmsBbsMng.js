/**
 * 게시판 렌더링 클래스
 * @author : doil
 */
class CmsBbsMng {
  constructor(el, bbs_id) {
    this.container = typeof el === 'string' ? document.querySelector(el) : el;
    this.bbs_id = bbs_id;
    this.bbsInfo = null;
    this.contentList = [];

    this.galleryInstance = null;
    this.swiper = null;

    this.init(); // 동기적 init 호출
  }

  init() {
    this.render(); // 초기 상태 render (비어있을 수도 있음)
    this.fetchData(); // fetch는 비동기적으로
  }

  async fetchData() {
    try {
      const [infoRes, contentRes] = await Promise.all([
        fetch(`/cms/bbs/getBBSInfo/${this.bbs_id}`),
        fetch(`/cms/bbs/getContentsList/${this.bbs_id}`)
      ]);

      this.bbsInfo = await infoRes.json();
      const contentData = await contentRes.json();
      this.contentList = contentData.data || [];

      this.render(); // 📦 데이터 로드 후 다시 렌더
    } catch (e) {
      console.error("데이터 로딩 오류", e);
      this._renderError("데이터 로딩 실패");
    }
  }

  render() {
    if (!this.bbsInfo) {
      this.container.innerHTML = `<div>⌛ 게시판 정보를 불러오는 중입니다...</div>`;
      return;
    }

    const type = Number(this.bbsInfo.bbs_type);

    switch (type) {
      case 2:
        this._renderGallery();
        break;
      case 3:
        this._renderSlider();
        break;
      default:
        this._renderList();
        break;
    }
  }

  _renderGallery() {
    const images = this.contentList.map(item => {
      const fileId = item.file_id;
      const imageUrl = `/cms/cdn/img/${fileId}`;
      return `
        <a href="${imageUrl}" class="glightbox" data-gallery="bbsGallery">
          <img src="${imageUrl}" alt="${item.title || ''}" style="width:200px;">
        </a>
      `;
    }).join('');

    this.container.innerHTML = `<div class="gallery-wrap" id="bbsGallery">${images}</div>`;

    this.galleryInstance = GLightbox({
      selector: '#bbsGallery .glightbox'
    });
  }

  _renderSlider() {
    const mainSlides = this.contentList.map(item => {
      const imageUrl = `/cms/cdn/img/${item.file_id}`;
      return `
        <div class="swiper-slide">
          <img src="${imageUrl}" alt="${item.title || ''}" style="width:100%; height:auto;">
        </div>
      `;
    }).join('');

    const thumbSlides = this.contentList.map(item => {
      const thumbUrl = `/cms/cdn/img/${item.file_id}?thumb=true`;
      return `
        <div class="swiper-slide">
          <img src="${thumbUrl}" alt="thumb" style="width:100px; height:auto;">
        </div>
      `;
    }).join('');

    this.container.innerHTML = `
      <div class="swiper mySwiperMain">
        <div class="swiper-wrapper">${mainSlides}</div>

        <!-- ✅ 버튼 요소 추가 -->
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
      </div>

      <div class="swiper mySwiperThumbs" style="margin-top:10px;">
        <div class="swiper-wrapper">${thumbSlides}</div>
      </div>
    `;

    // 썸네일 슬라이더 먼저 생성
    const thumbsSwiper = new Swiper(".mySwiperThumbs", {
      spaceBetween: 10,
      slidesPerView: 4,
      freeMode: true,
      watchSlidesProgress: true,
    });

    // 메인 슬라이더에서 연결
    this.swiper = new Swiper(".mySwiperMain", {
      spaceBetween: 10,
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev"
      },
      thumbs: {
        swiper: thumbsSwiper,
      }
    });
  }

  _renderList() {
    this.container.innerHTML = `<div>📋 일반 게시판 (${this.contentList.length}건)</div>`;
  }

  _renderError(msg) {
    this.container.innerHTML = `<div style="color:red;">${msg}</div>`;
  }
}



// 전역 노출용
window.CmsBbsMng = CmsBbsMng;
