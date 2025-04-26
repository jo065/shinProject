<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script src="${pageContext.request.contextPath}/static/js/cms/content.js"></script>
<input type="hidden" id="content_id" value="${content_id}" />

<style>
.cms-content-area {
    padding: 60px;
    margin: auto;
}

.content-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 16px;
}

.content-label {
    font-weight: bold;
    padding: 10px 0;
    width: 80px;
    white-space: nowrap; /* 한줄 표시 */
}

.content-value {
    padding: 10px 0;
    border-bottom: 1px solid #ccc;
}

.content-body {
    padding: 20px 0;
}

.content-footer {
    border-top: 1px solid #ccc;
    text-align: center;
    padding: 20px 0;
    color: #666;
}
</style>


<!-- CONTENT AREA -->
<div id="cms-content" class="cms-content-area">
    <table class="content-table">
        <tr>
            <td class="content-label">제목 :</td>
            <td class="content-value">
                <span id="content-title"></span>
            </td>
            <td class="content-label">등록일 :</td>
            <td class="content-value">
                <span id="content-regdt" class="content-regdt"></span>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="content-body" id="content"></td>
        </tr>
        <tr>
            <!-- footer영역 추후 댓글 등으로 활용 -->
            <td colspan="2" class="content-footer"></td>
        </tr>
    </table>
</div>



