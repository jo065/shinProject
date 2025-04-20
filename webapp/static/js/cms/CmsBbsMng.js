/**
 * 게시판 렌더링 클래스
 * @author : doil
 */
class CmsBbsMng {
  constructor(el, bbsId) {
    this.container = typeof el === 'string' ? document.querySelector(el) : el;
    this.bbsId = bbsId;
    this.bbsInfo = null; // 게시판 정보 캐싱

    this.init();
  }

  async init() {
    try {
      await this._loadInfo();
      this._render();
    } catch (err) {
      console.error('게시판 정보를 불러오는 중 오류 발생:', err);
      this.container.innerHTML = '<p style="color:red">게시판 정보를 불러올 수 없습니다.</p>';
    }
  }

  async _loadInfo() {
    const response = await fetch(`/cms/bbs/getBBSInfo/${this.bbsId}`);
    if (!response.ok) throw new Error('네트워크 오류');
    this.bbsInfo = await response.json();
  }

  _render() {
    if (!this.bbsInfo) return;

    const type = String(this.bbsInfo.bbs_type);

    switch (type) {
      case '1':
      case '3':
      case '4':
        this._renderList(); break;
      case '2':
        this._renderGallery(); break;
      default:
        this.container.innerHTML = '<p style="color:gray">지원하지 않는 게시판 유형입니다.</p>';
    }
  }

  _renderList() {
    const tableEl = document.createElement('div');
    this.container.innerHTML = '';
    this.container.appendChild(tableEl);

    new Tabulator(tableEl, {
      layout: "fitColumns",
      height: 500,
      ajaxURL: `/cms/api/bbsList/${this.bbsId}`,
      placeholder: "게시물이 없습니다.",
      columns: [
        { title: "번호", field: "rownum", width: 80, hozAlign: "center" },
        { title: "제목", field: "title", hozAlign: "left" },
        { title: "작성자", field: "writer", width: 120, hozAlign: "center" },
        { title: "등록일", field: "reg_dt", width: 140, hozAlign: "center" }
      ]
    });
  }

  _renderGallery() {
    this.container.innerHTML = `<div class="gallery-notice">🖼 갤러리형 게시판은 준비 중입니다.</div>`;
  }
}

// 전역 노출용
window.CmsBbsMng = CmsBbsMng;
