<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
/* 푸터 스타일 */
        footer {
            background-color: #1a3c6e;
            color: #fff;
            padding: 60px 5% 30px;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
        }

        .footer-column h3 {
            font-size: 20px;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }

        .footer-column h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 40px;
            height: 2px;
            background-color: #fff;
        }

        .footer-column ul {
            list-style: none;
        }

        .footer-column ul li {
            margin-bottom: 10px;
        }

        .footer-column ul li a {
            color: #ccc;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-column ul li a:hover {
            color: #fff;
        }

        .footer-bottom {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

</style>
<!-- 푸터 섹션 -->
<footer>
    <div class="footer-container">
        <div class="footer-column">
            <h3>신원명판산업</h3>
            <p>최고의 품질과 디자인으로<br>명판 산업을 선도합니다.</p>
        </div>
        <div class="footer-column">
            <h3>바로가기</h3>
            <ul>
                <li><a href="/home/home.do">홈</a></li>
                <li><a href="/menu/menu01.do">조각명판</a></li>
                <li><a href="#products">실크인쇄 명판</a></li>
                <li><a href="#process">부식명판</a></li>
                <li><a href="#cases">표지판</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>연락처</h3>
            <ul>
                <li>경기 안산시 단원구 산단로 432 편익A동 201호</li>
                <li>전화: 031-494-2315</li>
                <li>이메일: is2315@hanmail.net</li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2025 신원명판산업. All Rights Reserved.</p>
    </div>
</footer>
<%@ include file="/WEB-INF/jsp/common/plugin.jsp" %>