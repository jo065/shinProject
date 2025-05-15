/**
 * 게시판 렌더링 클래스
 * @author : doil
 */
class CmsBbsMng {
  constructor(el, bbs_id, opts = {}) {
    this.container = typeof el === 'string' ? document.querySelector(el) : el;
    this.bbs_id = bbs_id;
    this.bbsInfo = null;
    this.contentList = [];

    this.galleryInstance = null;
    this.swiper = null;

    this.opts = opts;
    const { callback = null} = opts;
    this.callback = callback;

    this.init(); // 동기적 init 호출
  }

  init() {
    this.render(); // 초기 상태 render (비어있을 수도 있음)
    this.fetchData(); // fetch는 비동기적으로
  }

  async fetchData() {
    try {
      const hasAjax = !!this.opts.ajaxURL;

      // 조건에 따라 fetch 배열 구성
      const fetchList = [
        fetch(`/cms/bbs/getBBSInfo/${this.bbs_id}`), // 게시판 정보는 무조건
        !hasAjax ? fetch(`/cms/bbs/getContentsList/${this.bbs_id}`) : null // ajaxURL이 없을 때만 fetch
      ].filter(Boolean); // null 제거

      const [infoRes, contentRes] = await Promise.all(fetchList);

      // 공통 처리
      this.bbsInfo = await infoRes.json();

      // contentRes가 있다면 처리
      if (contentRes) {
        const contentData = await contentRes.json();
        this.contentList = contentData.data || [];
      }

      this.render(this.callback);

    } catch (e) {
      console.error("📛 데이터 로딩 오류:", e);
      this._renderError("데이터 로딩 실패");
    }
  }

  render(callback) {
    if (!this.bbsInfo) {
      this.container.innerHTML = `<div>⌛ 게시판 정보를 불러오는 중입니다...</div>`;
      return;
    }

    const type = Number(this.bbsInfo.bbs_type);

    switch (type) {
      case 2:
        this._renderGallery(callback);
        break;
      case 3:
        this._renderSlider(callback);
        break;
      default:
        this._renderList(callback);
        break;
    }
  }

// 갤러리형 게시판 렌더링
  _renderGallery(callback) {
    const images = this.contentList.map((item, index) => {
      const fileId = item.file_id;
      const imageUrl = `/cms/cdn/img/${fileId}`;
      return `
       <a href="${imageUrl}" class="glightbox" data-gallery="bbsGallery" style="position: relative; display: inline-block;">
               <img src="${imageUrl}" alt="${item.title || ''}" style="width:100%;">
               <div style="position: absolute; top: 10px; left: 10px; background-color: rgba(0, 0, 0, 0.5); color: white; padding: 5px; font-size: 14px;">
                 a-${index}
               </div>
             </a>
      `;
    }).join('');

    this.container.innerHTML = `<div class="gallery-wrap" id="bbsGallery">${images}</div>`;

    this.galleryInstance = GLightbox({
      selector: '#bbsGallery .glightbox'
    });
  }

// 포토 슬라이드형 게시판 렌더링
  _renderSlider(callback) {
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

  // 리스트형 게시판 렌더링
  _renderList(callback) {

    console.log(`
    %c    ad8888ba,   88b           d88   ad88888ba       88888888ba   88        88  88  88           88888888ba,    88888888888  88888888ba
      d8"'    \`"8b  888b         d888  d8"     "8b      88      "8b  88        88  88  88           88      \`"8b   88           88      "8b
     d8'            88\`8b       d8'88  Y8,              88      ,8P  88        88  88  88           88        \`8b  88           88      ,8P
     88             88 \`8b     d8' 88  \`Y8aaaaa,        88aaaaaa8P'  88        88  88  88           88         88  88aaaaa      88aaaaaa8P'
     88             88  \`8b   d8'  88    \`"""""8b,      88""""""8b,  88        88  88  88           88         88  88"""""      88""""88'
     Y8,            88   \`8b d8'   88          \`8b      88      \`8b  88        88  88  88           88         8P  88           88    \`8b
      Y8a.    .a8P  88    \`888'    88  Y8a     a8P      88      a8P  Y8a.    .a8P  88  88           88      .a8P   88           88     \`8b
       \`"Y8888Y"'   88     \`8'     88   "Y88888P"       88888888P"    \`"Y8888Y"'   88  88888888888  88888888Y"'    88888888888  88      \`8b

    %c                                                                                                  %cby @doil
    `,
      "color: #4caf50; font-weight: bold; font-family: monospace;",
      "color: #2196f3; font-size: 16px; font-weight: bold;",
      "color: #aaa; font-size: 10px; font-style: italic;");




    const table_uuid = `bbs_table_${Date.now()}`;
      // 레이아웃 구성
      this.container.innerHTML = `
        <div class="cms-bbs-header"><span class="cms-bbs-title">${this.bbsInfo.bbs_name}</span>  ${this.contentList.length}건 </div>
        <div class="cms-bbs-list" id="${table_uuid}"></div>
        <div class="cms-bbs-footer"></div>
      `;

     const hasAjax = !!this.opts.ajaxURL;

      // 없으면 기본 Tabulator init
     const defaultTabulatorOptions = {
       data: this.contentList,
       layout: "fitColumns",
       pagination: "local",          // ✅ 기본 페이지네이션
       paginationSize: 10,           // ✅ 페이지당 10개
       height:500,
       placeholder: "등록된 게시글이 없습니다.",  // ✅ 빈 데이터 메시지
       columns: [
         {
           title: "No",
           formatter: "rownum", // Tabulator 내장 인덱스 formatter
           hozAlign: "center",
           width: 60
         },
         { title: "제목", field: "title" },
         { title: "작성자", field: "reg_id", width: 100 },
         {
           title: "작성일",
           field: "reg_dt",
           width: 200,
           formatter: function(cell) {
             const value = cell.getValue();
             const date = new Date(value);

             // YYYY-MM-DD HH:mm:ss 형식으로 포매팅
             const yyyy = date.getFullYear();
             const MM = String(date.getMonth() + 1).padStart(2, '0');
             const dd = String(date.getDate()).padStart(2, '0');
             const hh = String(date.getHours()).padStart(2, '0');
             const mm = String(date.getMinutes()).padStart(2, '0');
             const ss = String(date.getSeconds()).padStart(2, '0');

             return `${yyyy}-${MM}-${dd} ${hh}:${mm}:${ss}`;
           }
         }
       ]

     };
       // opts.tabulator가 있으면 merge, 없으면 default
     const finalOptions = Object.assign({}, defaultTabulatorOptions, this.opts || {});
     if (hasAjax) {
        finalOptions.ajaxURL = this.opts.ajaxURL;
        finalOptions.ajaxConfig = this.opts.ajaxConfig || 'GET';
        finalOptions.pagination = "remote";  // remote로 오버라이드
     }


     this.table = new Tabulator(`#${table_uuid}`, finalOptions);

    const defaultEvents = {
      rowClick: (e, row) => {
        // 게시글 이동
        // http://localhost:8080/cms/bbs/viewContent/19

        const {content_id = content_id} = row.getData();
        if (content_id) {
                window.location.href = `/cms/bbs/viewContent/${content_id}`;
        } else {
                console.warn('⚠️ content_id가 없습니다.');
        }

      },
      rowDblClick: (e, row) => {
        console.log("✨ 기본 rowDblClick:", row.getData());
      }
    };

    // 사용자 정의와 병합 (사용자가 있으면 덮어씀)
    const mergedEvents = Object.assign({}, defaultEvents, this.opts.events || {});

    // 이벤트 등록
    for (const [eventName, handler] of Object.entries(mergedEvents)) {
      if (typeof handler === 'function') {
        this.table.on(eventName, handler);
      }
    }


     if (typeof this.callback === 'function') {
        this.callback(this.table);
     }


  }

  _renderError(msg) {
    this.container.innerHTML = `<div style="color:red;">${msg}</div>`;
  }
}



// 전역 노출용
window.CmsBbsMng = CmsBbsMng;
