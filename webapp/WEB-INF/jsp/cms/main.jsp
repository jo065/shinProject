<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ✅ jQuery @v3.7.1 -->
<script src="${pageContext.request.contextPath}/static/vendor/jquery/jquery-3.7.1.min.js"></script>

<!-- ✅ Tabulator @v6.3.1 -->
<link href="${pageContext.request.contextPath}/static/vendor/tabulator/dist/css/tabulator_simple.min.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/vendor/tabulator/dist/js/tabulator.min.js"></script>

<!-- ✅ SweetAlert2 @v11.16.1 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/sweetalert2/11.16.1/sweetalert2.css">
<script src="${pageContext.request.contextPath}/static/vendor/sweetalert2/11.16.1/sweetalert2.min.js"></script>

<!-- ✅ FontAwesome @v6.7.2 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome/6.7.2/css/all.min.css">

<!-- ✅ Ionicons @v7.4.0 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/ionicons/7.4.0/icon.min.css">
<script src="${pageContext.request.contextPath}/static/vendor/ionicons/7.4.0/ionicons.min.js"></script>




<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 콘솔</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', sans-serif;
      background-color: #f8f9fa;
    }

    .container {
      display: flex;
      height: 100vh;
    }

    .sidebar {
      width: 220px;
      background-color: #f7f7f7;
      color: white;
      padding: 20px;
      border: 1px solid #ededed;
    }

    .content {
      flex: 1;
      background-color: #f5f5f5;
      overflow-y: auto;
    }

    .sidebar a {
      display: block;
      color: #343a40;
      text-decoration: none;
      margin: 10px 0;
    }

    .sidebar a:hover {
      color: #ccc;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      padding: 6px 10px;
      font-size: 13px;
      font-weight: 500;
      border-radius: 5px;
      text-decoration: none;
      transition: background 0.2s;
    }

    .btn i {
      margin-right: 5px;
    }

    .btn-home {
      background-color: #007bff;
      color: #fff;
    }

    .btn-home:hover {
      background-color: #0056b3;
    }

    .btn-logout {
      background-color: #dc3545;
      color: #fff;
    }

    .btn-logout:hover {
      background-color: #a71d2a;
    }

    .header-bar{     display: flex;
                      justify-content: space-between; /* 왼쪽 그룹, 오른쪽 그룹 양 끝으로 배치 */
                      align-items: center; /* 수직 중앙 정렬 */
                      padding: 15px 20px;
                      background-color: #343a40;
                      font-size: 14px;
                      color: white;
                 }
     .header-right {
       display: flex;
       align-items: center;
     }

     .header-right a {
       margin-left: 10px; /* 버튼 사이 간격 */
     }
  </style>
</head>
<body>
  <div class="container">

    <div class="sidebar">
      <%@ include file="left_menu.jsp" %>
    </div>

    <div class="content">
      <!-- ✅ 상단 Header Bar -->

<div class="header-bar">

  <!-- 왼쪽 -->
  <div class="header-left">
    <img src="/static/img/whiteLogo.png" alt="Logo" style="width: 100px;">
    <span style="font-weight: bold; color:white;">관리자 시스템</span>
  </div>

  <!-- 오른쪽 -->
  <div class="header-right">
  <div id="visitor-stats">

  </div>
    <span>
      <i class="fa-solid fa-circle-user"></i> <strong>${admin.lgn_id}</strong> 님 어서오세요
    </span>

    <!-- 홈페이지 이동 버튼 -->
    <a href="/home/home.do" class="btn btn-home">
      <i class="fa-solid fa-house"></i> 홈페이지
    </a>

    <!-- 로그아웃 버튼 -->
    <a href="/cms/logout" class="btn btn-logout">
      <i class="fa-solid fa-arrow-right-from-bracket"></i> 로그아웃
    </a>
  </div>

</div>


      <!-- 🔄 동적 본문 include -->
      <c:if test="${not empty contentPage}">
        <jsp:include page="${contentPage}" />
      </c:if>
    </div>

  </div>

</body>
</html>
  <script src="${pageContext.request.contextPath}/static/js/common/common.js"></script>
<script>
$(document).ready(function() {
    getCounter().then((data) => {
        console.log("data", data);

        const html = `
          <span>📅 오늘 날짜: <strong>${data.today}</strong></span>
          <span>👁️ 오늘 접속자 수: <strong>${data.today_cnt}</strong>명</span>
          <span>📊 누적 접속자 수: <strong>${data.total_cnt}</strong>명</span>
        `;

        // 순수 JavaScript로도 시도
        const element = document.getElementById('visitor-stats');
        console.log("DOM 요소:", element);

        if (element) {
            element.innerHTML = html;
        }

    }).catch((err) => {
        console.error("카운터 불러오기 실패:", err);
    });
});
</script>

