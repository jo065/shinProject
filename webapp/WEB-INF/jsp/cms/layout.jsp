<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>
<head>
  <title>CMS Layout</title>

  <!-- 공통 CSS/JS 로딩 -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css" />
  <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
</head>
<body>

  <!-- 상단 영역 -->
  <header>
    <h2>📘 공통 상단</h2>
  </header>

  <!-- 콘텐츠 영역 -->
  <main>
    <c:if test="${not empty includePage}">
        <jsp:include page="${includePage}" />
     </c:if>
  </main>


  <!-- 하단 영역 -->
  <footer>
    <hr />
    <p style="text-align: center;">© CMS Footer</p>
  </footer>

</body>
</html>
