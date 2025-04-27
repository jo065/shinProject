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
            <h3>씨엠테크</h3>
            <p>끊임없는 노력으로, 직원 등 모든 이해관계자 여러분의 기대에 부흥하는 성실기업으로 <br>함께 성장, 발전해 나갈 것을 약속 드립니다.</p>
        </div>

        <div class="footer-column">
            <h3>연락처</h3>
            <ul>
                <li>경기도 화성시 봉담읍 쇠틀길 86</li>
                <li>전화: 031-895-6144</li>
                <li>이메일: dyt1532@naver.com</li>
                <li>FAX: 031-895-6147</li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2025 씨엠테크. All Rights Reserved.</p>
    </div>
</footer>
<%@ include file="/WEB-INF/jsp/common/plugin.jsp" %>