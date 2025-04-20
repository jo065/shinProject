<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 💡 공통 스타일/스크립트 로드 -->
<link href="${pageContext.request.contextPath}/static/vendor/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/static/vendor/tabulator/dist/js/tabulator.min.js"></script>

<!-- GLightbox CSS & JS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/glightbox/dist/css/glightbox.min.css">
<script src="https://cdn.jsdelivr.net/npm/glightbox/dist/js/glightbox.min.js"></script>


<link href="${pageContext.request.contextPath}/static/css/cms/Bbs.style.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/static/js/cms/CmsBbsMng.js"></script>

<!-- 💡 숨겨진 파라미터 전달 (필요시 JS에서 활용) -->
<input type="hidden" id="bbs_id" value="${bbs_id}" />
<input type="hidden" id="bbs_type" value="${bbs_type}" />

<div id="bbsArea" style=""></div>

<script>

</script>
