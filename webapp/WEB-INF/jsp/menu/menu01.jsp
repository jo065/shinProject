<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>신원명판산업</title>
      <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
    <style>
        * {
              margin: 0;
              padding: 0;
              box-sizing: border-box;
              font-family: 'Noto Sans KR', sans-serif;
            }

            body {
              background-color: #f8f9fa;
              color: #333;
              line-height: 1.6;
            }

            .greeting-section {
              position: relative;
              padding: 120px 0 80px;
              background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 40%, rgba(240, 245, 255, 0.9) 100%);
              overflow: hidden;
            }

            .pattern-bg {
              position: absolute;
              top: 0;
              right: 0;
              width: 100%;
              height: 100%;
              background-image: radial-gradient(#e0e8ff 1px, transparent 1px);
              background-size: 20px 20px;
              opacity: 0.3;
              z-index: 1;
            }

            .container {
              max-width: 1200px;
              margin: 0 auto;
              padding: 0 20px;
              position: relative;
              z-index: 2;
            }

            .greeting-container {
              display: flex;
              flex-wrap: wrap;
              align-items: center;
              gap: 50px;
            }

            .greeting-content {
              flex: 1;
              min-width: 300px;
            }

            .greeting-image {
              flex: 1;
              min-width: 300px;
              position: relative;
            }

            .image-frame {
              position: relative;
              width: 100%;
              height: 0;
              padding-bottom: 75%;
              border-radius: 10px;
              overflow: hidden;
              box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
            }

            .image-frame img {
              position: absolute;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              object-fit: cover;
            }

            .blue-accent {
              position: absolute;
              width: 100px;
              height: 100px;
              background-color: #2b7ae1;
              border-radius: 50%;
              opacity: 0.15;
              z-index: -1;
            }

            .accent-1 {
              top: -30px;
              right: -30px;
              width: 150px;
              height: 150px;
            }

            .accent-2 {
              bottom: -20px;
              left: -40px;
              width: 100px;
              height: 100px;
            }

            .company-subheading {
              font-size: 15px;
              text-transform: uppercase;
              letter-spacing: 3px;
              color: #2b7ae1;
              margin-bottom: 15px;
              font-weight: 600;
            }

            .greeting-title {
              font-size: 36px;
              font-weight: 700;
              color: #1a1a2e;
              margin-bottom: 25px;
              line-height: 1.3;
            }

            .greeting-title span {
              position: relative;
              display: inline-block;
            }

            .greeting-title span::after {
              content: '';
              position: absolute;
              bottom: 5px;
              left: 0;
              width: 100%;
              height: 8px;
              background-color: rgba(43, 122, 225, 0.15);
              z-index: -1;
            }

            .greeting-description {
              font-size: 16px;
              color: #555;
              margin-bottom: 25px;
              line-height: 1.8;
            }

            .highlight-text {
              font-size: 18px;
              line-height: 1.7;
              color: #333;
              font-weight: 500;
              padding: 20px 25px;
              border-left: 3px solid #2b7ae1;
              background-color: rgba(43, 122, 225, 0.03);
              margin: 30px 0;
            }

            .ceo-sign {
              display: flex;
              align-items: flex-end;
              margin-top: 40px;
            }

            .ceo-info {
                display: flex;
                 margin-right: 30px;
                  gap: 7px;
            }

            .ceo-position {
              font-size: 14px;
              color: #777;
              margin-bottom: 5px;
            }

            .ceo-name {
              font-size: 20px;
              font-weight: 600;
              color: #1a1a2e;
              line-height: 1;
            }

            .signature {
              width: 120px;
              opacity: 0.8;
            }

            .values-container {
              display: flex;
              flex-wrap: wrap;
              gap: 15px;
              margin-top: 40px;
            }

            .value-tag {
              padding: 10px 20px;
              background-color: white;
              border-radius: 30px;
              box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
              font-size: 14px;
              font-weight: 500;
              color: #444;
              display: flex;
              align-items: center;
            }

            .value-tag-icon {
              width: 24px;
              height: 24px;
              margin-right: 8px;
              display: flex;
              align-items: center;
              justify-content: center;
              background-color: rgba(43, 122, 225, 0.1);
              border-radius: 50%;
            }

            .value-tag-icon svg {
              width: 12px;
              height: 12px;
              fill: #2b7ae1;
            }

            @media (max-width: 768px) {
              .greeting-section {
                padding: 80px 0 60px;
              }

              .greeting-container {
                flex-direction: column-reverse;
              }

              .greeting-title {
                font-size: 28px;
              }

              .blue-accent {
                display: none;
              }
            }
    </style>

</head>
<body>
    <section class="about-section" id="about">
        <div class="pattern-bg"></div>
           <div class="container">
             <div class="greeting-container">
               <div class="greeting-content">
                 <p class="company-subheading">인사말</p>
                 <h1 class="greeting-title">안녕하십니까? <br> <span>신원명판산업</span> 입니다.</h1>

                 <p class="greeting-description">
                   안녕하십니까?
                   저희 홈페이지를 방문해주셔서 감사드립니다.
                   저희 신원명판산업은 조각명판, 실크인쇄명판,
                   부식명판 제작전문 업체로서
                   오랜 경험과 풍부한 노하우를 바탕으로
                   신속하고 철저한 납기준수, 최상의 품질관리,
                   고객만족의 가격 그리고 항상 최선을 다하는 업체로서
                   함께 성장해가는 동반자가될 것을 약속드립니다.
                 </p>
                 <div class="values-container">
                   <div class="value-tag">
                     <div class="value-tag-icon">
                       <svg viewBox="0 0 24 24">
                         <path d="M20.24 12.24a6 6 0 0 0-8.49-8.49L5 10.5V19h8.5z"></path>
                         <line x1="16" y1="8" x2="2" y2="22"></line>
                         <line x1="17.5" y1="15" x2="9" y2="15"></line>
                       </svg>
                     </div>
                     고품질 제작
                   </div>
                   <div class="value-tag">
                     <div class="value-tag-icon">
                       <svg viewBox="0 0 24 24">
                         <circle cx="12" cy="12" r="10"></circle>
                         <polyline points="12 6 12 12 16 14"></polyline>
                       </svg>
                     </div>
                     신속한 납기
                   </div>
                   <div class="value-tag">
                     <div class="value-tag-icon">
                       <svg viewBox="0 0 24 24">
                         <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                         <polyline points="22 4 12 14.01 9 11.01"></polyline>
                       </svg>
                     </div>
                     신뢰와 정확성
                   </div>
                   <div class="value-tag">
                     <div class="value-tag-icon">
                       <svg viewBox="0 0 24 24">
                         <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                         <circle cx="9" cy="7" r="4"></circle>
                         <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                         <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                       </svg>
                     </div>
                     고객 중심 서비스
                   </div>
                 </div>

                 <div class="ceo-sign">
                   <div class="ceo-info">
                     <p class="ceo-position">대표</p>
                     <p class="ceo-name">김형희</p>
                   </div>
                 </div>
               </div>

               <div class="greeting-image">
                 <div class="blue-accent accent-1"></div>
                 <div class="blue-accent accent-2"></div>
                 <div class="image-frame">
                   <img id="animated-image" src="/static/img/hello.jpg" alt="Image">
                 </div>
               </div>
             </div>
           </div>
        </section>

</body>

</html>

<script>

</script>
 <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/static/js/menu/menu01.js"></script>