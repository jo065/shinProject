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
      background-color: #343a40;
      color: white;
      padding: 20px;
    }

    .content {
      flex: 1;
      padding: 20px;
      background-color: white;
      overflow-y: auto;
    }

    .sidebar a {
      display: block;
      color: #ccc;
      text-decoration: none;
      margin: 10px 0;
    }

    .sidebar a:hover {
      color: #fff;
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

  </style>
</head>
<body>
  <div class="container">

    <div class="sidebar">
      <%@ include file="left_menu.jsp" %>
    </div>

    <div class="content">
      <!-- ✅ 상단 Header Bar -->
      <div class="header-bar" style="display: flex; justify-content: flex-end; align-items: center; margin-bottom: 20px; font-size: 14px; color: #555;">
        <span style="margin-right: 10px;">
          <strong>${admin.lgn_id}</strong> 님 어서오세요.
        </span>
        <!-- 홈페이지 이동 버튼 -->
         <a href="/home/home.do" class="btn btn-home" style="margin-right:5px;">
           <i class="fa-solid fa-house"></i> 홈페이지
         </a>

         <!-- 로그아웃 버튼 -->
         <a href="/cms/logout" class="btn btn-logout">
           <i class="fa-solid fa-arrow-right-from-bracket"></i> 로그아웃
         </a>
      </div>

      <!-- 🔄 동적 본문 include -->
      <c:if test="${not empty contentPage}">
        <jsp:include page="${contentPage}" />
      </c:if>
    </div>

  </div>

</body>
</html>
