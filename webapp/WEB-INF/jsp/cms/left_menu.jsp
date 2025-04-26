<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
.menu-container {
      padding: 0;
      margin: 0;
      color: #343a40;
      border-bottom: 1px solid #c5c5c5;
      width: 220px;
      display: flex;
      justify-content: center;
}

/* 활성화된 메뉴 스타일 */
.menu-link {
  display: block;
  padding: 8px 12px;
  text-decoration: none;
  color: white;
  border-radius: 5px;
}
.menu-link.active {
  background-color: #e9e9e9;
  font-weight: bold;
}

</style>

<div class="menu-container">
  <h3>관리자 메뉴</h3>
 </div>

<!-- ✅ id 추가!! -->
<a href="/cms/admin?menu=menuMng" id="menuMng" class="menu-link"><i class="fa-solid fa-bars"></i> 메뉴 관리</a>
<a href="/cms/admin?menu=bbsMng" id="bbsMng" class="menu-link"><i class="fa-solid fa-clipboard"></i> 게시판 관리</a>
<a href="/cms/admin?menu=config" id="config" class="menu-link"><i class="fa-solid fa-gear"></i> 설정</a>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const menu = urlParams.get('menu');

    let targetId = menu;

    // ✅ 만약 menu 파라미터가 없고, 현재 URL이 '/cms/admin'이면
    if (!menu && window.location.pathname === '/cms/admin') {
        targetId = 'menuMng';  // 기본으로 'menuMng'를 active 처리
    }

    if (targetId) {
        const target = document.getElementById(targetId);
        if (target) {
            target.classList.add('active');
        }
    }
});
</script>
