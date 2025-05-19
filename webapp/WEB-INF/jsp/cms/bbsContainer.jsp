<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../common/plugin.jsp" %>
<%@ include file="./cms_plugins.jsp" %>

<!-- 💡 숨겨진 파라미터 전달 (필요시 JS에서 활용) -->
<input type="hidden" id="bbs_id" value="${bbs_id}" />
<input type="hidden" id="bbs_type" value="${bbs_type}" />
<style>

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
    </section>


 <%@ include file="../common/footer.jsp" %>
