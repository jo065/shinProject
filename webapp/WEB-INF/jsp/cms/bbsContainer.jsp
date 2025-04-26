<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../common/plugin.jsp" %>
<%@ include file="./cms_plugins.jsp" %>

<!-- 💡 숨겨진 파라미터 전달 (필요시 JS에서 활용) -->
<input type="hidden" id="bbs_id" value="${bbs_id}" />
<input type="hidden" id="bbs_type" value="${bbs_type}" />


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

<header style="display:none">
    <menu style="
          display: flex;
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
    <div id="bbsArea" style=""></div>
</main>

 <%@ include file="../common/footer.jsp" %>
