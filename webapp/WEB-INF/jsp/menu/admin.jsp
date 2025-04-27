<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자</title>
      <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
    <style>
        .admin-section {
                    padding: 80px 0;
                }
                .admin-title {
                    font-size: 24px;
                    font-weight: 600;
                    margin-bottom: 30px;
                    color: #333;
                    text-align: center;
                }
                .login-form {
                    background: white;
                    border-radius: 10px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                    padding: 40px;
                    max-width: 500px;
                    margin: 0 auto;
                }
                .form-control {
                    height: 50px;
                    border-radius: 5px;
                    border: 1px solid #e0e6ed;
                    padding: 10px 15px;
                    margin-bottom: 20px;
                }
                .btn-login {
                    border: none;
                    height: 50px;
                    border-radius: 5px;
                    background-color: #1a3c6e;
                    color: white;
                    font-weight: 500;
                    letter-spacing: 0.5px;
                    width: 100%;
                    transition: all 0.3s;
                }
                .btn-login:hover {
                    background-color: #0747a6;
                }
    </style>
.filepond--root {margin-bottom : 0 !importanat;}
</head>
<body>
     <section class="admin-section">
         <div class="container">
             <div class="admin-title">관리자 확인</div>
             <div class="login-form">
                 <form>
                     <div class="mb-3">
                         <input type="password" id="admin_pw" class="form-control" placeholder="비밀번호" required>
                     </div>
                     <button onclick="authenticateAdmin();" type="button" class="btn-login">확인</button>
                 </form>
                 <div class="company-slogan mt-4 text-center">
                    <img src="/static/img/logo.png" alt="Image" style="width: 50%;">
                 </div>
             </div>
         </div>
     </section>
</body>
</html>

<script>

</script>
 <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/static/js/menu/admin.js"></script>