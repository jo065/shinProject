<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 💡 공통 스타일/스크립트 로드 -->
<link href="${pageContext.request.contextPath}/static/vendor/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/static/vendor/tabulator/dist/js/tabulator.min.js"></script>

<link href="https://unpkg.com/filepond/dist/filepond.min.css" rel="stylesheet">
<script src="https://unpkg.com/filepond/dist/filepond.min.js"></script>
<script src="https://unpkg.com/filepond-plugin-image-preview/dist/filepond-plugin-image-preview.min.js"></script>
<link href="https://unpkg.com/filepond-plugin-image-preview/dist/filepond-plugin-image-preview.min.css" rel="stylesheet">



<script src="${pageContext.request.contextPath}/static/js/cms/admin.js"></script>


<input type="hidden" id="bbs_id" value="${bbs_id}" />
<input type="hidden" id="bbs_type" value="${bbs_type}" />

<div id="container" style="padding: 20px;">
  <h4>📁 컨텐츠 관리</h4>

  <!-- Top: 버튼 영역 -->
  <div style="margin-bottom: 16px;">
    <button id="btnAddContent" onclick="insertContent()">➕ 등록</button>
    <button id="btnDeleteContent" onclick="deleteContents()">🗑️ 삭제</button>
  </div>

  <!-- Middle: Tabulator 테이블 -->
  <div id="contentTable"></div>
</div>

