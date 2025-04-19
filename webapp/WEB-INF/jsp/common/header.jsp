<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
       * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Noto Sans KR', sans-serif; }
       body { background-color: #f8f9fa; color: #333; line-height: 1.6; }
       header { background-color: #fff; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); position: fixed; width: 100%; z-index: 1000; transition: all 0.3s ease; }
       .header-container { display: flex; justify-content: space-between; align-items: center; padding: 15px 5%; max-width: 1200px; margin: 0 auto; }
       .logo { font-size: 24px; font-weight: 700; color: #1a3c6e; }

       .nav-menu { display: flex; list-style: none; }
       .nav-menu li { margin-left: 30px; }
       .nav-menu a { text-decoration: none; color: #333; font-weight: 500; font-size: 16px; transition: color 0.3s ease; }
       .nav-menu a:hover { color: #1a3c6e; }

       .premium-banner { position: relative; height: 500px; width: 100%; overflow: hidden; background: linear-gradient(135deg, #1a2a6c, #2a3f7c 25%, #1e50a2 50%, #344e86 75%, #19387a); box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15); }

       .wave { position: absolute; width: 200%; height: 200px; bottom: -30px; left: -50%; border-radius: 50%; opacity: 0.2; background: rgba(255, 255, 255, 0.8); animation: wave 15s infinite linear; z-index: 20; }
       .wave:nth-child(2) { bottom: -50px; opacity: 0.15; animation: wave 17s infinite linear; z-index: 20; }
       .wave:nth-child(3) { bottom: -70px; opacity: 0.1; animation: wave 20s infinite linear; z-index: 20; }

       @keyframes wave { 0% { transform: translateX(0) translateZ(0) scaleY(1); } 50% { transform: translateX(-25%) translateZ(0) scaleY(0.8); } 100% { transform: translateX(-50%) translateZ(0) scaleY(1); } }

       .particles { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
       .particle { position: absolute; border-radius: 50%; background: rgba(255, 255, 255, 0.5); box-shadow: 0 0 10px 2px rgba(255, 255, 255, 0.3); animation: float 20s infinite ease-in-out; }

       @keyframes float { 0%, 100% { transform: translateY(0) translateX(0); } 25% { transform: translateY(-20px) translateX(10px); } 50% { transform: translateY(-35px) translateX(-15px); } 75% { transform: translateY(-15px) translateX(25px); } }

       .banner-content { position: relative; z-index: 10; padding: 50px; display: flex; height: 100%; align-items: center; }
       .banner-content .image { width: 40%; height: auto; margin-right: 20px; z-index: 10; }
       .banner-content .text { flex: 1; }
       .banner-graphic { flex: 1; display: flex; align-items: center; justify-content: center; position: relative; }
       .banner-circle { width: 280px; height: 280px; border-radius: 50%; background: rgba(255, 255, 255, 0.1); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); backdrop-filter: blur(5px); display: flex; align-items: center; justify-content: center; position: relative; overflow: hidden; }

       .circle-inner { width: 85%; height: 85%; border-radius: 50%; background: rgba(255, 255, 255, 0.15); display: flex; align-items: center; justify-content: center; }
       .machine-icon { width: 100%; height: 100%; background-image: url('/static/img/img1.png'); background-size: cover; background-position: center center; }
       .banner-text { flex: 1; display: flex; flex-direction: column; justify-content: center; color: white; padding-left: 40px; }

       .company-logo { font-size: 28px; font-weight: 700; letter-spacing: 1px; position: relative; text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); }
       .company-name { margin-left: 73px; font-size: 46px; font-weight: 800; letter-spacing: -1px; margin-bottom: 27px; text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); }
       .company-desc { font-size: 25px; font-weight: 300; line-height: 1.6; opacity: 0.9; }

       @media (max-width: 768px) { .banner-content { flex-direction: column; padding: 30px; } .banner-graphic, .banner-text { width: 100%; padding: 20px 0; } .company-name { font-size: 36px; } .banner-circle { width: 200px; height: 200px; } }

       .highlight-line { position: absolute; width: 100%; height: 2px; background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent); top: 40%; animation: scan 3s infinite; }

       @keyframes scan { 0% { transform: translateY(-50px); opacity: 0; } 50% { opacity: 1; } 100% { transform: translateY(50px); opacity: 0; } }

       section { padding: 100px 5%; max-width: 1200px; margin: 0 auto; opacity: 0; transform: translateY(50px); transition: opacity 1s, transform 1s; }
       section.show { opacity: 1; transform: translateY(0); }

       .about-image { display: flex; justify-content: center; align-items: center; height: 10vh; opacity: 0; transform: translateY(30px); transition: opacity 1s, transform 1s; }
       .about-image.show { opacity: 1; transform: translateY(0); }
       .section-title { position: relative; text-align: center; font-size: 26px; font-weight: 700; color: #1a1a2e; margin-bottom: 50px; padding-bottom: 15px; }
       .section-title::after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 60px; height: 3px; background: linear-gradient(90deg, #1e4aaf, #2b7ae1); }
       .section-title p { color: #666; font-size: 18px; }

       .button-box { display: flex; width: 100%; gap: 1px; }

       .plate-button { flex-grow: 1; padding: 15px; background-color: #2c467e; color: white; font-size: 18px; border: none; cursor: pointer; transition: background-color 0.3s ease; text-align: center; }
       .plate-button:hover { background-color: #4a6499; }

       .scroll-to-top-btn { position: fixed; bottom: 30px; right: 30px; width: 50px; height: 50px; background-color: #2c467e; color: white; border: none; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; cursor: pointer; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); opacity: 0.8; transition: opacity 0.3s ease, transform 0.3s ease; }
       .scroll-to-top-btn:hover { background-color: #0056b3; opacity: 1; }
       .scroll-to-top-btn.hide { display: none; }

</style>
<header>
<button id="scrollToTopBtn" class="scroll-to-top-btn">
    <i class="fa fa-arrow-up"></i>
</button>
    <div class="header-container">
        <div class="logo">
            <a href="/home/home.do">
                <img src="/static/img/logo.png" alt="Logo" style="width: 230px;">
            </a>
        </div>
        <ul class="nav-menu">
            <li><a href="/home/home.do">홈</a></li>
            <li><a href="/menu/menu01.do">인사말</a></li>
            <li><a href="/menu/menu02.do">조각명판</a></li>
            <li><a href="#process">실크인쇄 명판</a></li>
            <li><a href="#cases">부식명판</a></li>
            <li><a href="#info">표지판</a></li>
            <li><a href="#address">오시는 길</a></li>
        </ul>
    </div>
</header>

<!-- 메인 배너 섹션 -->
<div class="premium-banner">
    <div class="wave"></div>
    <div class="wave"></div>
    <div class="wave"></div>

    <div class="particles"></div>

    <div class="banner-content">
        <div class="image">
            <img id="animated-image" src="/static/img/img1.png" alt="Image" style="width: 100%; height: auto; position: relative; right: 60px;">
        </div>

        <div class="banner-text">
            <div class="company-logo"> <img src="/static/img/whiteLogo.png" alt="Image" style="width: 203px; margin-left: 97px;"></div>
            <h1 class="company-name">신원명판산업</h1>
            <p class="company-desc">조각 명판 / 실크 인쇄 명판 / 부식 명판<br>최고의 품질과 정밀함으로 고객 맞춤 솔루션을 제공합니다.</p>
        </div>
    </div>
</div>
<script>
// 상단으로 가기 버튼
const scrollToTopBtn = document.getElementById('scrollToTopBtn');

// 버튼을 클릭하면 페이지 맨 위로 스크롤
scrollToTopBtn.addEventListener('click', () => {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'  // 부드러운 스크롤 효과
    });
});

// 페이지가 스크롤되었을 때 버튼의 표시/숨기기
window.addEventListener('scroll', () => {
    if (document.body.scrollTop > 200 || document.documentElement.scrollTop > 200) {
        scrollToTopBtn.classList.remove('hide');  // 200px 이상 스크롤 시 버튼 표시
    } else {
        scrollToTopBtn.classList.add('hide');     // 그 외에는 버튼 숨기기
    }
});


document.addEventListener("DOMContentLoaded", () => {
    // IntersectionObserver 설정
    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add("show"); // 섹션이 보이면 애니메이션 적용
                observer.unobserve(entry.target); // 한 번만 실행되도록
            }
        });
    }, {
        threshold: 0.5 // 섹션이 50% 이상 보일 때 애니메이션 실행
    });

    // 각 섹션에 대해 관찰 시작
    const sections = document.querySelectorAll("section");
    sections.forEach(section => {
        if (section) {
               observer.observe(section);
           }
    });

    // .about-image도 애니메이션을 위해 관찰
    const aboutImage = document.querySelector(".about-image");
    if (aboutImage) {
        observer.observe(aboutImage);
    }
});


    // 파티클의 개수와 속성을 설정합니다.
    const particlesData = [
        { size: '6px', top: '10%', left: '15%', delay: '0s' },
        { size: '10px', top: '20%', left: '25%', delay: '2s' },
        { size: '4px', top: '30%', left: '35%', delay: '1s' },
        { size: '8px', top: '40%', left: '65%', delay: '0.5s' },
        { size: '12px', top: '70%', left: '75%', delay: '3s' },
        { size: '5px', top: '80%', left: '85%', delay: '1.5s' },
        { size: '7px', top: '85%', left: '5%', delay: '2.5s' },
        { size: '9px', top: '15%', left: '95%', delay: '1.2s' },
        { size: '4px', top: '45%', left: '45%', delay: '2.7s' },
    ];

    const particlesContainer = document.querySelector('.particles');

    // 파티클을 동적으로 생성하고 추가합니다.
    particlesData.forEach(particle => {
        const particleElement = document.createElement('div');
        particleElement.classList.add('particle');
        particleElement.style.width = particle.size;
        particleElement.style.height = particle.size;
        particleElement.style.top = particle.top;
        particleElement.style.left = particle.left;
        particleElement.style.animationDelay = particle.delay;

        // 생성한 파티클을 particlesContainer에 추가
        particlesContainer.appendChild(particleElement);
    });
</script>
<%@ include file="/WEB-INF/jsp/common/plugin.jsp" %>