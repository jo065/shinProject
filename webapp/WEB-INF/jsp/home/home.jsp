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
    </style>

</head>
<body>
    <!-- 회사 소개 섹션 -->
    <section class="about-section" id="about">
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
            <div class="about-image">
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
    <section class="products-section" id="products">
        <h2 class="section-title">명판 소개</h2>
        <div class="tabs">
          <button class="tab-btn active" onclick="openTab('engraved')">조각 명판</button>
          <button class="tab-btn" onclick="openTab('silk')">실크 명판</button>
          <button class="tab-btn" onclick="openTab('etched')">부식 명판</button>
        </div>

        <div id="engraved" class="tab-content active">
          <div class="category-info">
            <h3>조각 명판</h3>
            <p>정밀한 레이저 가공 기술로 제작된 고품질 조각 명판입니다. 내구성이 뛰어나고 선명한 텍스트와 그래픽을 구현할 수 있어 산업용 장비 및 다양한 분야에서 활용됩니다.</p>
          </div>
        </div>

            <!-- 실크 명판 탭 -->
            <div id="silk" class="tab-content">
              <div class="category-info">
                <h3>실크 명판</h3>
                <p>실크스크린 인쇄 기술을 활용한 다채로운 색상과 디자인이 가능한 명판입니다. 컬러풀한 디자인과 고급스러운 마감으로 다양한 용도에 활용됩니다.</p>
              </div>
            </div>

            <!-- 부식 명판 탭 -->
            <div id="etched" class="tab-content">
              <div class="category-info">
                <h3>부식 명판</h3>
                <p>화학적 부식 공정을 통해 금속 표면에 정교한 디자인을 새기는 기술로 제작된 명판입니다. 고급스러운 질감과 탁월한 내구성으로 장기간 사용이 가능합니다.</p>
              </div>
          </div>


        <div class="product-card">
          <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide"><img id="animated-image" src="/static/img/ex1.jpeg" alt="Image"></div>
               <div class="swiper-slide"><img id="animated-image" src="/static/img/ex1.jpeg" alt="Image"></div>
               <div class="swiper-slide"><img id="animated-image" src="/static/img/ex1.jpeg" alt="Image"></div>
               <div class="swiper-slide"><img id="animated-image" src="/static/img/ex1.jpeg" alt="Image"></div>
               <div class="swiper-slide"><img id="animated-image" src="/static/img/ex1.jpeg" alt="Image"></div>
               <div class="swiper-slide"><img id="animated-image" src="/static/img/ex1.jpeg" alt="Image"></div>
                </div>
           </div>
      </div>
      <div class="swiper-button-prev"></div>
      <div class="swiper-button-next"></div>
    </section>

    <!--위치 안내 -->
    <section class="cases-section" id="address">
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
     function openTab(tabName) {
          // Hide all tab content
          var tabContents = document.getElementsByClassName("tab-content");
          for (var i = 0; i < tabContents.length; i++) {
            tabContents[i].classList.remove("active");
          }

          // Remove active class from all tab buttons
          var tabButtons = document.getElementsByClassName("tab-btn");
          for (var i = 0; i < tabButtons.length; i++) {
            tabButtons[i].classList.remove("active");
          }

          // Show the current tab and add active class to the button that opened it
          document.getElementById(tabName).classList.add("active");

          // Find the button that corresponds to this tab and add active class
          for (var i = 0; i < tabButtons.length; i++) {
            if (tabButtons[i].addEventListener) {
              var buttonText = tabButtons[i].textContent.trim();
              if ((tabName === "engraved" && buttonText === "조각 명판") ||
                  (tabName === "silk" && buttonText === "실크 명판") ||
                  (tabName === "etched" && buttonText === "부식 명판")) {
                tabButtons[i].classList.add("active");
              }
            }
          }
        }

    window.addEventListener('load', function () {
            const img = document.getElementById('animated-image');
            setTimeout(() => {
                img.classList.add('zoom-in');
            }, 100); // 약간의 딜레이 후 확대
        });

   var swiper = new Swiper('.swiper-container', {
     loop: true,                 // 무한 루프
     slidesPerView: 3,           // 한 번에 3개 보여주기
     spaceBetween: 30,           // 슬라이드 간 간격(px)
     autoplay: {
       delay: 3000,              // 3초마다 자동 이동
       disableOnInteraction: false, // 사용자 조작 후에도 계속 자동
     },
     navigation: {
       nextEl: '.swiper-button-next',
       prevEl: '.swiper-button-prev',
     },
   });

   window.onload = function () {
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
       };
</script>
 <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/static/js/home/home.js"></script>