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

      if (this.bbsInfo.bbs_type == 2) {
        this._renderGallery();
      } else {
        this._renderList();
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

  _renderList() {
    this.container.innerHTML = `<div>📋 일반 게시판 (탭 뷰 예정)</div>`;
  }

  _renderError(msg) {
    this.container.innerHTML = `<div style="color:red;">${msg}</div>`;
  }

  setData(dataList) {
    // 📌 추후 이미지 리스트를 동적으로 바인딩하려면 여기에 구현
  }
}


// 전역 노출용
window.CmsBbsMng = CmsBbsMng;
