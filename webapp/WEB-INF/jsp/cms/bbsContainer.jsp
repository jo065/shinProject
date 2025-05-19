<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../common/plugin.jsp" %>
<%@ include file="./cms_plugins.jsp" %>

<!-- 💡 숨겨진 파라미터 전달 (필요시 JS에서 활용) -->
<input type="hidden" id="bbs_id" value="${bbs_id}" />
<input type="hidden" id="bbs_type" value="${bbs_type}" />
<style>

.small-title {color: #224b96;}
.gallery-wrap {
  display: flex;
  flex-wrap: wrap;       /* 여러 줄로 자동 줄바꿈 */
  gap: 10px;             /* 이미지 사이 간격 */
  margin-bottom: 35px;
}

.gallery-wrap a {
  flex: 0 0 calc(33.333% - 10px);  /* 너비: 전체의 1/3에서 간격 빼기 */
  position: relative;
}

.gallery-wrap img {
  width: 100%;
  height: auto;
  display: block;
}

/* ginner-container 크기 설정 */
.ginner-container {
  max-width: 900px;
  height: 506px;
  position: relative; /* 인덱스를 이미지 위에 올리기 위한 상대 위치 설정 */
  overflow: hidden; /* 이미지가 넘치지 않도록 처리 */
}

/* 이미지 크기 맞추기 */
.ginner-container img {
  width: 100%;
  height: 100%;
  object-fit: cover; /* 비율 유지하면서 부모 영역을 완전히 채우도록 설정 */
}

/* 이미지 위에 인덱스 표시 */
.ginner-container .image-title {
  position: absolute;
  top: 10px;
  left: 10px;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  padding: 5px;
  font-size: 14px;
  font-weight: bold;
}

@media screen and (max-width: 768px) {

.gallery-wrap a {flex: 0 0 calc(50% - 5px);}
}
</style>

<script>
    let menu;
    let g_bbs;

    $(document).ready(function() {

        menu = new CmsMenuMng('#menu', {
                maxDepth: -1,           // -1: 무제한
                direction: 'horizontal' // 또는 'vertical'
            });

        g_bbs = new CmsBbsMng('#bbsArea', ${bbs_id}, {
            height:300,
                events:{
                    rowDblClick: (e, row) => {
                        console.log('오버라이딩 테스트');
                    }
                }
         });
    });



</script>


<%@ include file="../common/header.jsp" %>

<section class="about-section show" id="about">
        <h2 class="section-title"></h2>
        <div id="bbsArea" style=""></div>
        <h3 class="small-title"></h3>
</section>


 <%@ include file="../common/footer.jsp" %>
