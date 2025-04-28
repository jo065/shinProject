<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script src="${pageContext.request.contextPath}/static/js/cms/editor.js"></script>


<!-- include summernote css/js -->
<link href="${pageContext.request.contextPath}/static/vendor/summernote/0.9.0/summernote-lite.min.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/static/vendor/summernote/0.9.0/summernote-lite.min.js"></script>
<script src="${pageContext.request.contextPath}/static/vendor/summernote/0.9.0/lang/summernote-ko-KR.js"></script>



<style>
.container {
    width: 100%;
    max-width: 100%;
    padding: 0;
}

.editor-container {
    max-width: 100%; /* 너비 제한 없애기 */
    padding: 20px;
}

.note-editor.note-frame {
  font-family: '맑은 고딕', sans-serif;
  font-size: 14px;
}
.note-editor .note-editable {
  min-height: 300px;
  padding: 20px;
}

.form-btn {
  text-align: center;
  margin-top: 30px;
}

#submitBtn {
  background-color: #007bff; /* Bootstrap 기본 Primary 파랑색 */
  border: none;
  color: white;
  padding: 10px 20px;
  font-size: 16px;
  margin-right: 10px;
  border-radius: 4px;
  cursor: pointer;
}

#submitBtn:hover {
  background-color: #0069d9; /* hover시 약간 더 진한 파랑 */
}

.btn-secondary {
  background-color: #6c757d; /* Bootstrap Secondary 회색 */
  border: none;
  color: white;
  padding: 10px 20px;
  font-size: 16px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-secondary:hover {
  background-color: #5a6268; /* hover시 약간 더 진한 회색 */
}

.form-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 20px;
  width: 100%;
}

.form-title label {
  font-weight: bold;
  font-size: 16px;
}

.form-title input[type="text"] {
  flex: 1;
  min-width: 300px;
  padding: 8px 12px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.form-title input[type="text"]:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.2);
}



</style>

<div>
    <h4>📁 컨텐츠 관리 <span id="bbs_title"></span></h4>
</div>

<!-- ✨ 기본 editor 페이지 구조 -->
<div class="editor-container" style="margin: 20px auto;">

    <div class="form-title form-group d-flex align-items-center" style="gap: 10px;">
        <label for="title" style="font-weight: bold;">카테고리 :</label>
        <select id="swalCate" class="swal2-input"> </select>
        <button id="btnMngCate" onclick="manageCate(${bbs_id})">🏷️ 카테고리 관리</button>
    </div>

    <!-- 제목 입력 -->
    <div class="form-title form-group d-flex align-items-center" style="gap: 10px;">
        <label for="title" style="font-weight: bold;">제목 :</label>
        <input type="text" id="title" class="form-control" placeholder="제목을 입력하세요" style="flex: 1; min-width: 300px;">
    </div>

    <!-- Summernote 에디터 -->
    <div class="form-group" style="margin-top: 20px;">
        <textarea id="summernote" name="content"></textarea>
    </div>

    <!-- 버튼 영역 -->
    <div class="form-btn form-group text-center" style="margin-top: 30px;">
        <button type="button" id="submitBtn" class="btn btn-primary" onclick="saveContent()">저장</button>
        <button type="button" class="btn btn-secondary" onclick="cancel()">취소</button>
    </div>

</div>