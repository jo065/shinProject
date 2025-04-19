<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

        /* 헤더 스타일 */
        header {
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 5%;
            max-width: 1200px;
            margin: 0 auto;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #1a3c6e;
        }

        .nav-menu {
            display: flex;
            list-style: none;
        }

        .nav-menu li {
            margin-left: 30px;
        }

        .nav-menu a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .nav-menu a:hover {
            color: #1a3c6e;
        }

        /* 메인 배너 스타일 */
          /* 고급스러운 배너 스타일 */
                .premium-banner {
                    position: relative;
                    height: 500px;
                    width: 100%;
                    overflow: hidden;
                    background: linear-gradient(135deg, #1a2a6c, #2a3f7c 25%, #1e50a2 50%, #344e86 75%, #19387a);
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                }

                /* 동적인 물결 효과 */
                .wave {
                    position: absolute;
                    width: 200%;
                    height: 200px;
                    bottom: -30px;
                    left: -50%;
                    border-radius: 50%;
                    opacity: 0.2;
                    background: rgba(255, 255, 255, 0.8);
                    animation: wave 15s infinite linear;
                    z-index: 20;
                }

                .wave:nth-child(2) {
                    bottom: -50px;
                    opacity: 0.15;
                    animation: wave 17s infinite linear;
                    z-index: 20;
                }

                .wave:nth-child(3) {
                    bottom: -70px;
                    opacity: 0.1;
                    animation: wave 20s infinite linear;
                    z-index: 20;
                }

                @keyframes wave {
                    0% {
                        transform: translateX(0) translateZ(0) scaleY(1);
                    }
                    50% {
                        transform: translateX(-25%) translateZ(0) scaleY(0.8);
                    }
                    100% {
                        transform: translateX(-50%) translateZ(0) scaleY(1);
                    }
                }

                /* 빛나는 입자 효과 */
                .particles {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                }

                .particle {
                    position: absolute;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.5);
                    box-shadow: 0 0 10px 2px rgba(255, 255, 255, 0.3);
                    animation: float 20s infinite ease-in-out;
                }

                @keyframes float {
                    0%, 100% {
                        transform: translateY(0) translateX(0);
                    }
                    25% {
                        transform: translateY(-20px) translateX(10px);
                    }
                    50% {
                        transform: translateY(-35px) translateX(-15px);
                    }
                    75% {
                        transform: translateY(-15px) translateX(25px);
                    }
                }

                /* 배너 내용 스타일 */
               .banner-content {
                   position: relative;
                   z-index: 10;
                   padding: 50px;
                   display: flex;
                   height: 100%;
                   align-items: center; /* 세로로 중앙 정렬 */
               }

               .banner-content .image {
                   width: 40%; /* 이미지가 차지할 너비 */
                   height: auto; /* 이미지 높이는 자동 조정 */
                   margin-right: 20px; /* 이미지와 텍스트 사이에 간격 추가 */
                    z-index: 10;
               }

               .banner-content .text {
                   flex: 1; /* 남은 공간을 차지 */
               }

                /* 좌측 이미지/그래픽 영역 */
                .banner-graphic {
                    flex: 1;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    position: relative;
                }

               .banner-circle {
                   width: 280px;
                   height: 280px;
                   border-radius: 50%;
                   background: rgba(255, 255, 255, 0.1);
                   box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                   backdrop-filter: blur(5px);
                   display: flex;
                   align-items: center;
                   justify-content: center;
                   position: relative;
                   overflow: hidden;
               }

               .circle-inner {
                   width: 85%;
                   height: 85%;
                   border-radius: 50%;
                   background: rgba(255, 255, 255, 0.15);
                   display: flex;
                   align-items: center;
                   justify-content: center;
               }

               .machine-icon {
                   width: 100%;
                   height: 100%;
                   background-image: url('/static/img/img1.png'); /* 이미지 경로 */
                   background-size: cover; /* 이미지가 원 모양에 맞게 크기 조정 */
                   background-position: center center; /* 이미지 중앙 정렬 */
               }


                /* 우측 텍스트 영역 */
                .banner-text {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    color: white;
                    padding-left: 40px;
                }

                .company-logo {
                    font-size: 28px;
                    font-weight: 700;
                    letter-spacing: 1px;
                    position: relative;
                    text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
                }



                .company-name {
                        margin-left: 73px;
                        font-size: 46px;
                        font-weight: 800;
                        letter-spacing: -1px;
                        margin-bottom: 27px;
                        text-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
                }

                .company-desc {
                    font-size: 25px;
                    font-weight: 300;
                    line-height: 1.6;
                    opacity: 0.9;
                }

                /* 반응형 스타일 */
                @media (max-width: 768px) {
                    .banner-content {
                        flex-direction: column;
                        padding: 30px;
                    }

                    .banner-graphic, .banner-text {
                        width: 100%;
                        padding: 20px 0;
                    }

                    .company-name {
                        font-size: 36px;
                    }

                    .banner-circle {
                        width: 200px;
                        height: 200px;
                    }
                }

                /* 추가 세부 효과를 위한 스타일 */
                .highlight-line {
                    position: absolute;
                    width: 100%;
                    height: 2px;
                    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
                    top: 40%;
                    animation: scan 3s infinite;
                }

                @keyframes scan {
                    0% {
                        transform: translateY(-50px);
                        opacity: 0;
                    }
                    50% {
                        opacity: 1;
                    }
                    100% {
                        transform: translateY(50px);
                        opacity: 0;
                    }
                }

        /* 섹션 공통 스타일 */
        section {
            padding: 100px 5%;
            max-width: 1200px;
            margin: 0 auto;
            opacity: 0; /* 섹션을 처음에 보이지 않게 설정 */
            transform: translateY(50px); /* 밑에서 위로 올라올 수 있도록 초기 위치 설정 */
            transition: opacity 1s, transform 1s; /* 애니메이션을 위한 트랜지션 */
        }

        section.show {
            opacity: 1;
            transform: translateY(0); /* 섹션이 보일 때 원래 위치로 애니메이션 */
        }

        .about-image {
            opacity: 0;
            transform: translateY(30px); /* 버튼들이 초기에는 보이지 않게 설정 */
            transition: opacity 1s, transform 1s; /* 애니메이션 효과 */
        }

        .about-image.show {
            opacity: 1;
            transform: translateY(0); /* 화면에 보일 때 버튼들이 올라오는 애니메이션 */
        }



        .section-title {
             position: relative;
             text-align: center;
             font-size: 26px;
             font-weight: 700;
             color: #1a1a2e;
             margin-bottom: 50px;
             padding-bottom: 15px;
           }

           .section-title::after {
             content: '';
             position: absolute;
             bottom: 0;
             left: 50%;
             transform: translateX(-50%);
             width: 60px;
             height: 3px;
             background: linear-gradient(90deg, #1e4aaf, #2b7ae1);
           }

        .section-title p {
            color: #666;
            font-size: 18px;
        }

        .about-image {
            display: flex;
            justify-content: center; /* 버튼 박스를 가로로 중앙 정렬 */
            align-items: center; /* 세로로 중앙 정렬 */
            height: 10vh; /* 화면 전체 높이 */
        }

        .button-box {
            display: flex; /* 버튼을 가로로 배치 */
            width: 100%; /* 버튼 박스의 너비를 80%로 설정 */
            gap: 1px; /* 버튼들 간의 간격 */
        }

        .plate-button {
            flex-grow: 1; /* 버튼들이 가로 공간을 고르게 나눠가짐 */
            padding: 15px;
            background-color: #2c467e; /* 푸른색 배경 */
            color: white;
            font-size: 18px;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-align: center; /* 버튼 텍스트 중앙 정렬 */
        }

        .plate-button:hover {
            background-color: #4a6499; /* 호버 시 배경색 변경 */
        }

/* 상단으로 가기 버튼 스타일 */
.scroll-to-top-btn {
    position: fixed;
    bottom: 30px; /* 화면 하단에서 30px */
    right: 30px;  /* 화면 우측에서 30px */
    width: 50px;   /* 버튼 크기 */
    height: 50px;  /* 버튼 크기 */
    background-color: #2c467e;  /* 파란색 배경 */
    color: white;  /* 아이콘 색상 */
    border: none;  /* 테두리 없앰 */
    border-radius: 50%;  /* 원 모양 */
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;  /* 아이콘 크기 */
    cursor: pointer;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    opacity: 0.8;  /* 초기 투명도 */
    transition: opacity 0.3s ease, transform 0.3s ease;
}

/* 호버 시 배경색 변화 */
.scroll-to-top-btn:hover {
    background-color: #0056b3;
    opacity: 1;
}

/* 버튼이 페이지 상단으로 올라갔을 때 보이지 않도록 */
.scroll-to-top-btn.hide {
    display: none;
}

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
            <li><a href="/menu/menu01.do">조각명판</a></li>
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