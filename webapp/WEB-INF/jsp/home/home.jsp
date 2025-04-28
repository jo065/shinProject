<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>신원명판산업</title>
      <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
     <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=e756b74a4c2b9dc078781e79e685e4ed"></script>
    <style>
    .contact-cards {display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 40px;}
    .contact-card {flex: 1; min-width: 280px; background-color: #f8fafd; border-radius: 10px; padding: 24px; display: flex; align-items: center; transition: all 0.3s ease; border: 1px solid rgba(0, 0, 0, 0.06);}
    .contact-card:hover {transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1); border-color: rgba(43, 122, 225, 0.3);}

    .icon-wrapper {width: 60px; height: 60px; border-radius: 50%; background-color: rgba(43, 122, 225, 0.1); display: flex; align-items: center; justify-content: center; margin-right: 20px; flex-shrink: 0;}
    .icon {width: 24px; height: 24px; fill: #2b7ae1;}

    .contact-info h3 {font-size: 14px; color: #7b7b8a; margin-bottom: 5px; font-weight: 500;}
    .contact-info p {font-size: 18px; font-weight: 600; color: #1a1a2e;}
    .contact-info a {font-size: 18px; font-weight: 600; color: #1a1a2e; text-decoration: none; transition: color 0.2s ease;}
    .contact-info a:hover {color: #2b7ae1;}

    .about-text div {display: flex; align-items: center; width: 100%; background-color: white; color: #1a3c6e; padding: 10px 20px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); font-size: 20px; font-weight: 500; transition: transform 0.3s ease, box-shadow 0.3s ease; position: relative; justify-content: center;}
    .about-text div::after {content: ""; position: absolute; bottom: 0; left: 0; width: 100%; height: 5px; background-color: #2c467e;}
    .about-text {display: flex; justify-content: space-between; width: 100%; gap: 20px;}
    .about-text div i {margin-right: 10px; font-size: 20px;}
    .about-text div:hover {transform: translateY(-5px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);}
    .about-text div:first-child {margin-left: 0;}
    .about-text div:last-child {margin-right: 0;}

    .products-section {background-color:#f8fafd;}
    .product-cards {display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px;}
    .product-card {overflow: hidden; transition: transform 0.3s ease;}
    .product-card:hover {transform: translateY(-10px);}
    .product-card img {width: 100%; height: 300px; object-fit: cover;}
    .product-info {padding: 20px;}
    .product-info h3 {font-size: 22px; margin-bottom: 10px; color: #1a3c6e;}

    .process-section {background-color: #fff;}
    .process-steps {display: flex; justify-content: space-between; margin-top: 30px; flex-wrap: wrap;}
    .process-step {flex: 1; min-width: 200px; text-align: center; padding: 20px; position: relative;}

    .step-number {width: 60px; height: 60px; border-radius: 50%; background-color: #1a3c6e; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: 700; margin: 0 auto 20px;}
    .process-step h3 {margin-bottom: 15px; color: #1a3c6e;}

    .case-studies {display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px;}
    .case-study {background-color: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);}
    .case-study img {width: 100%; height: 200px; object-fit: cover;}
    .case-info {padding: 20px;}
    .case-info h3 {font-size: 22px; margin-bottom: 10px; color: #1a3c6e;}

    @media (max-width: 768px) {
        .about-content {flex-direction: column;}
        .banner-content h1 {font-size: 36px;}
    }
    .swiper {width: 600px; height: 400px;}

    #animated-image {transform: scale(1); transition: transform 3s ease-in-out;  object-fit: cover;}
    #animated-image.zoom-in {transform: scale(1.1);}

    .plate-button {text-decoration: none;}

    .address-text{text-align: center; font-size: 20px; font-weight: bold; color: #1a3c6e;}


    .tabs {
          display: flex;
          justify-content: center;
          margin-bottom: 40px;
          border-radius: 8px;
          overflow: hidden;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .tab-btn {
          flex: 1;
          padding: 16px 20px;
          background-color: #fff;
          border: none;
          cursor: pointer;
          font-size: 16px;
          font-weight: 500;
          transition: all 0.3s ease;
          text-align: center;
          position: relative;
          z-index: 1;
          color: #555;
        }

        .tab-btn:not(:last-child) {
          border-right: 1px solid #eaedf2;
        }

        .tab-btn.active {
          background-color: #2b7ae1;
          color: white;
        }

        .tab-btn:hover:not(.active) {
          background-color: #f0f4f8;
        }

        .tab-content {
          display: none;
          animation: fadeIn 0.5s ease forwards;
        }

        .tab-content.active {
          display: block;
        }

        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }

        .nameplate-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
          gap: 30px;
          margin-top: 30px;
        }

        .nameplate-card {
          background-color: #fff;
          border-radius: 12px;
          overflow: hidden;
          box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
          transition: all 0.3s ease;
        }

        .nameplate-card:hover {
          transform: translateY(-10px);
          box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .nameplate-img {
          width: 100%;
          height: 250px;
          overflow: hidden;
          position: relative;
        }

        .nameplate-img img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.5s ease;
        }

        .nameplate-card:hover .nameplate-img img {
          transform: scale(1.05);
        }

        .nameplate-content {
          padding: 25px;
        }

        .nameplate-title {
          font-size: 20px;
          font-weight: 600;
          color: #1a1a2e;
          margin-bottom: 12px;
          position: relative;
          padding-bottom: 12px;
        }

        .nameplate-title::after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 0;
          width: 40px;
          height: 2px;
          background-color: #2b7ae1;
        }

        .nameplate-desc {
          color: #555;
          font-size: 15px;
          margin-bottom: 20px;
          line-height: 1.7;
        }

        .features-list {
          list-style: none;
        }

        .features-list li {
          position: relative;
          padding-left: 25px;
          margin-bottom: 8px;
          font-size: 14px;
          color: #555;
        }

        .features-list li::before {
          content: '✓';
          position: absolute;
          left: 0;
          color: #2b7ae1;
          font-weight: bold;
        }

        .category-info {
          text-align: center;
          max-width: 800px;
          margin: 0 auto 40px;
          background-color: #fff;
          padding: 25px;
          border-radius: 10px;
          box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .category-info h3 {
          font-size: 24px;
          color: #2b7ae1;
          margin-bottom: 15px;
        }

        .category-info p {
          color: #555;
          font-size: 16px;
          line-height: 1.7;
        }

        .cta-button {
          display: inline-block;
          padding: 12px 24px;
          background: linear-gradient(90deg, #1e4aaf, #2b7ae1);
          color: white;
          border-radius: 6px;
          text-decoration: none;
          font-weight: 500;
          margin-top: 15px;
          transition: all 0.3s ease;
        }

        .cta-button:hover {
          transform: translateY(-3px);
          box-shadow: 0 5px 15px rgba(43, 122, 225, 0.3);
        }

        @media (max-width: 768px) {
          .tabs {
            flex-direction: column;
          }

          .tab-btn:not(:last-child) {
            border-right: none;
            border-bottom: 1px solid #eaedf2;
          }

          .nameplate-grid {
            grid-template-columns: 1fr;
          }
        }
        .shortcut-button {
          display: inline-block;
          margin: 10px;
          padding: 10px 20px;
          background-color: #007BFF;
          color: white;
          text-decoration: none;
          border-radius: 5px;
        }

        .shortcut-button:hover {
          background-color: #0056b3;
        }
        #buttonContainer {margin-top: 32px; text-align: end;}
    </style>

</head>
<body>
<section class="about-section" id="about">
    <img src="/static/img/shinMain.jpeg" alt="shinMain">
</section>
    <!-- 회사 문의 섹션 -->
    <section class="about-section" id="about" style="display:none;">
        <h2 class="section-title">문의 안내</h2>
        <div class="contact-cards">
                <div class="contact-card">
                  <div class="icon-wrapper">
                    <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                      <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                    </svg>
                  </div>
                  <div class="contact-info">
                    <h3>전화 문의</h3>
                    <a href="tel:031-494-2315">031-494-2315</a>
                  </div>
                </div>

                <div class="contact-card">
                  <div class="icon-wrapper">
                    <i class="fa-solid fa-envelope" style="color: #2b7ae1; font-size: 20px;"></i>
                  </div>
                  <div class="contact-info">
                    <h3>이메일 문의</h3>
                    <a href="mailto:is2315@hanmail.net">is2315@hanmail.net</a>
                  </div>
                </div>
              </div>
            <div class="about-image" style="display:none;">
                <div class="button-box">
                    <a href="/menu/menu02.do" class="plate-button">
                        <i class="fa-regular fa-share-from-square"></i> 조각명판
                    </a>
                    <button class="plate-button"><i class="fa-regular fa-share-from-square"></i> 실크인쇄</button>
                    <button class="plate-button"><i class="fa-regular fa-share-from-square"></i> 부식명판</button>
                </div>
            </div>
        </div>
    </section>

    <!-- 제품 섹션 -->
    <section class="products-section" id="products" style="margin-bottom:50px;">
        <h2 class="section-title">명판 소개 </h2>
        <div class="tabs" id="tabButtons"></div>

        <div id="tabContents"></div>

        <div class="product-card">
          <div class="swiper-container">
            <div class="swiper-wrapper">
              <!-- 슬라이드 들어감 -->
            </div>
          </div>
        </div>
      <div class="swiper-button-prev"></div>
      <div class="swiper-button-next"></div>
       <div id="buttonContainer"></div>
    </section>

    <!--위치 안내 -->
    <section class="cases-section" id="address" style="display:none;">
    <h2 class="section-title">LOCATION</h2>
     <p class="address-text">경기 안산시 단원구 산단로 432 편익A동 201호</p>
      <div class="case-studies">
        <div id="map" style="width:100%; height:350px;"></div>
      </div>
    </section>


</body>

</html>
<!-- Swiper CSS -->
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
<!-- Swiper JS -->
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>


<script>
let swiper;
let tabsData = [];
let activeBbsId = null;

function initTabs(flatList) {
  tabsData = flatList.filter(item => item.bbs_id != null && item.menu_name !== '표지판');
  console.log("tabsData", tabsData);

  const tabButtons = document.getElementById('tabButtons');
  const tabContents = document.getElementById('tabContents');
  const buttonContainer = document.getElementById('buttonContainer');

  if (!tabButtons || !tabContents) return;

  tabButtons.innerHTML = '';
  tabContents.innerHTML = '';

  tabsData.forEach((item, idx) => {
    const tabId = `tab${item.bbs_id}`;

    const button = document.createElement('button');
    button.className = 'tab-btn';
    button.textContent = item.menu_name + ' 바로가기';
    button.setAttribute('data-tab', tabId);

    // 클릭 이벤트 연결
    button.addEventListener('click', function(e) {
      // 모든 탭 버튼에서 active 클래스 제거
      document.querySelectorAll('#tabButtons .tab-btn').forEach(btn => btn.classList.remove('active'));
      // 현재 클릭된 버튼에 active 클래스 추가
      button.classList.add('active');
      openTab(tabId, item.bbs_id); // openTab 호출 시 activeBbsId 값을 설정
    });

    tabButtons.appendChild(button);
  });

  // 첫 번째 탭을 기본으로 활성화
  if (tabsData.length > 0) {
    setTimeout(() => {
      const firstButton = document.querySelector('#tabButtons .tab-btn');
      if (firstButton) {
        firstButton.classList.add('active');
        activeBbsId = tabsData[0].bbs_id;  // 첫 번째 탭의 bbs_id를 activeBbsId에 저장
        openTab(`tab${tabsData[0].bbs_id}`, tabsData[0].bbs_id); // 첫 번째 탭을 열 때 activeBbsId 설정
      }
    }, 0);
  }

  // 첫 번째 탭을 위한 버튼들만 생성 (한 번만 생성)
  createShortcutButtons();
}

// 탭 버튼을 눌러서 활성화된 탭만 보이도록 하는 함수
function createShortcutButtons() {
  const buttonContainer = document.getElementById('buttonContainer');
  buttonContainer.innerHTML = '';  // 버튼을 다시 생성하기 전에 기존 버튼을 비워줍니다.

  tabsData.forEach(tab => {
    const button = document.createElement('a');

    // 경로 중복을 방지하여 최종 URL 생성
    let finalPath = tab.page_path;
    if (!finalPath.endsWith('/')) {
      finalPath += '/';  // 만약 '/'가 없으면 추가
    }
    finalPath += tab.bbs_id; // bbs_id 추가

    button.href = finalPath;  // 페이지 경로 설정

    // 아이콘과 텍스트를 함께 추가
    button.innerHTML = `<i class="fa-solid fa-share-from-square"></i> ${tab.menu_name} 바로가기`;  // 아이콘과 텍스트 추가

    button.classList.add('shortcut-button');  // 버튼 스타일링 클래스 (선택적)

    // 활성화된 버튼만 표시
    if (tab.bbs_id === activeBbsId) {
      button.style.display = 'inline-block';  // 활성화된 버튼만 보이도록 설정
    } else {
      button.style.display = 'none';  // 나머지 버튼은 숨김
    }

    // 버튼을 버튼 컨테이너에 추가
    buttonContainer.appendChild(button);
  });
}


async function openTab(tabId, bbs_id) {
  // 활성화된 bbs_id 저장
  activeBbsId = bbs_id;  // 현재 활성화된 탭의 bbs_id를 저장

  // 모든 탭 콘텐츠에서 active 클래스 제거
  document.querySelectorAll('.tab-content').forEach(content => {
    content.classList.remove('active');
  });

  // 클릭된 탭에 해당하는 콘텐츠 활성화
  const targetContent = document.getElementById(tabId);
  if (targetContent) {
    targetContent.classList.add('active');
  }

  // 탭 버튼의 active 상태도 업데이트 (직접 클릭하지 않은 경우를 위해)
  document.querySelectorAll('#tabButtons .tab-btn').forEach(btn => {
    if (btn.getAttribute('data-tab') === tabId) {
      btn.classList.add('active');
    } else {
      btn.classList.remove('active');
    }
  });

  // Swiper 초기화
  if (swiper) {
    swiper.destroy(true, true);
    swiper = null;
  }

  await loadSwiperImages(bbs_id);

  swiper = new Swiper('.swiper-container', {
    loop: true,
    slidesPerView: 3,
    spaceBetween: 30,
    autoplay: {
      delay: 3000,
      disableOnInteraction: false,
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    }
  });

  // createShortcutButtons를 openTab 이후에 호출 (단 한 번만 호출)
  createShortcutButtons();
}





async function loadSwiperImages(bbs_id) {
  try {
    const list = await getContentsList(bbs_id);
    if (!list || !Array.isArray(list)) return;

    const wrapper = document.querySelector('.swiper-wrapper');
    if (!wrapper) return;

    wrapper.innerHTML = '';

    list.forEach(item => {
      const slide = document.createElement('div');
      slide.className = 'swiper-slide';

      const img = document.createElement('img');
      img.src = item.imageUrl || item.file_path || '';
      img.alt = item.title || '이미지';
      img.style.width = '100%';
      img.style.height = '300px';
      img.style.objectFit = 'cover';

      slide.appendChild(img);
      wrapper.appendChild(slide);
    });

    if (swiper) {
      swiper.update();
      swiper.slideTo(0, 0);
      swiper.autoplay.start();
    }
  } catch (error) {
    console.error('Swiper 이미지 로드 실패', error);
  }
}



window.addEventListener('load', async function () {


      // ✅ 4. 지도 로딩
      var container = document.getElementById('map');
      var options = {
          center: new kakao.maps.LatLng(37.32531500274263, 126.78658727671835),
          level: 3
      };

      var map = new kakao.maps.Map(container, options);

      var markerPosition = new kakao.maps.LatLng(37.32531500274263, 126.78658727671835);
      var marker = new kakao.maps.Marker({
          position: markerPosition
      });
      marker.setMap(map);
  });

</script>
 <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/static/js/home/home.js"></script>