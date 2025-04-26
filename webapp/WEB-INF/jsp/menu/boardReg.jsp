<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<style>
#btn-add-post{    background: #1a3c6e;
                  color: white;
                  padding: 4px 15px;
                  border-radius: 3px;
                  border: none;}
</style>
<head>
    <meta charset="UTF-8">
    <title>신원명판산업</title>
      <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
    <style>

    </style>

</head>
<body>
    <section class="about-section" id="about">
        <h2 class="section-title">게시글</h2>
        <div id="board-table"></div>

        <div style="margin-bottom: 10px; text-align: end;">
            <button id="btn-add-post" onclick="openPostForm()">게시글 등록</button>
        </div>
    </section>

    <!-- 게시글 등록 모달 -->
    <div id="post-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background-color: rgba(0, 0, 0, 0.5); z-index: 9999; justify-content: center; align-items: center;">
        <div style="background: white; padding: 30px; border-radius: 12px; width: 450px; position: relative; box-shadow: 0 5px 25px rgba(0,0,0,0.15);">
            <h3 style="margin-top: 0; margin-bottom: 20px; font-size: 22px; color: #333; padding-bottom: 12px; border-bottom: 1px solid #eee; font-weight: 600;">게시글 등록</h3>

            <form id="post-form" enctype="multipart/form-data">
                <label for="bbs_name" style="display: block; margin-bottom: 6px; font-weight: 500; color: #444;">게시판 이름:</label>
                <input type="text" id="bbs_name" name="bbs_name" required
                       style="width: 100%; margin-bottom: 16px; padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; transition: all 0.2s; box-sizing: border-box;"
                       onFocus="this.style.borderColor='#4dabf7'; this.style.boxShadow='0 0 0 3px rgba(77, 171, 247, 0.15)';"
                       onBlur="this.style.borderColor='#ddd'; this.style.boxShadow='none';" />

                <label for="bbs_type" style="display: block; margin-bottom: 6px; font-weight: 500; color: #444;">게시판 타입:</label>
                <select id="bbs_type" name="bbs_type" required
                        style="width: 100%; margin-bottom: 16px; padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; background-color: white; appearance: auto; height: 42px; box-sizing: border-box;">
                    <option value="공지">조각명판</option>
                    <option value="일반">실크인쇄</option>
                    <option value="QnA">부식명판</option>
                    <option value="QnA">표지판</option>
                </select>

                <label for="use_yn" style="display: block; margin-bottom: 6px; font-weight: 500; color: #444;">사용 여부:</label>
                <select id="use_yn" name="use_yn" required
                        style="width: 100%; margin-bottom: 16px; padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; background-color: white; appearance: auto; height: 42px; box-sizing: border-box;">
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                </select>

                <label for="upload_file" style="display: block; margin-bottom: 6px; font-weight: 500; color: #444;">첨부파일 (사진):</label>
                <div class="file-box">
                    <input type="file" id="upload_file" name="upload_file" accept="image/*">
                    <img id="preview_image" src="#" alt="미리보기" style="display: none; margin-top: 10px; max-width: 50%; border-radius: 6px;" />
                </div>

                <div style="display: flex; justify-content: flex-end; margin-top: 10px;">
                    <button type="button" onclick="closePostForm()"
                            style="padding: 10px 16px; background-color: #e9ecef; color: #495057; border: none; border-radius: 3px; cursor: pointer; font-weight: 500; margin-right: 8px; transition: all 0.2s;">
                        닫기
                    </button>
                    <button type="submit"
                            style="padding: 10px 20px; background-color: #1a3c6e; color: white; border: none; border-radius: 3px; cursor: pointer; font-weight: 500; transition: all 0.2s;">
                        등록
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>

<script>

</script>
 <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/static/js/menu/boardReg.js"></script>