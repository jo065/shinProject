<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../common/plugin.jsp" %>
<%@ include file="./cms_plugins.jsp" %>


<script>
    let menu;
    $(document).ready(function() {
        menu = new CmsMenuMng('#menu', {
            maxDepth: -1,           // -1: 무제한
            direction: 'horizontal' // 또는 'vertical'
        });
    });
</script>

<header style="display:none">
    <menu style=" display: flex;
          align-items: center;   /* 수직 가운데 정렬 */
          justify-content: center; /* 수평 가운데 정렬 */
          gap: 40px; /* 로고와 메뉴 사이 간격 */
      ">
      <div id="logo">
        <img src="/static/img/logo.png" alt="Logo" style="width: 230px;">
      </div>
        <div id="menu">메뉴영역</div>
    </menu>
</header>

<%@ include file="../common/header.jsp" %>


<main style="padding:10px;">
    <!-- 💡 메인 컨텐츠 include -->
    <c:if test="${not empty pagePath}">
        <jsp:include page="${pagePath}" />
    </c:if>
</main>


 <%@ include file="../common/footer.jsp" %>




