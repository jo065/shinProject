<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 로그인</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      background-color: #ffffff;
      font-family: 'Segoe UI', sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .login-box {
      width: 300px;
      padding: 40px;
      border: 1px solid #ddd;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
      text-align: center;
    }

    .login-box h2 {
      margin-bottom: 20px;
      font-size: 22px;
      text-align: center;
      color: #333;
    }

    .login-box input[type="text"],
    .login-box input[type="password"] {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      box-sizing: border-box;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    .login-box input[type="submit"] {
      width: 100%;
      padding: 10px;
      background-color: #2c467e;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      margin-top: 10px;
    }

    .login-box .link {
      display: block;
      margin-top: 10px;
      text-align: right;
      font-size: 12px;
      color: #888;
      text-decoration: none;
    }

    .login-box .link:hover {
      text-decoration: underline;
    }
  </style>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
</head>
<body>
  <form class="login-box" method="post" action="/cms/loginPost">
    <img src="/static/img/cm_logo.jpeg" alt="Logo" style="width: 230px; padding-bottom: 20px;">
    <h2>관리자 로그인</h2>
    <input type="text" name="lgn_id" placeholder="아이디" required />
    <input type="password" name="lgn_passwd" placeholder="비밀번호" required />

     <c:if test="${not empty msg}">
            <div style="color: red; text-align: center; margin-bottom: 10px; font-size: 13px;">
              ${msg}
            </div>
          </c:if>

    <input type="submit" value="로그인" />
  </form>
</body>

<script>
document.addEventListener("DOMContentLoaded", function () {
  document.querySelector("form").addEventListener("submit", function(e) {
    const pwInput = document.querySelector("input[name='lgn_passwd']");
    const plain = pwInput.value;

    const hash = CryptoJS.SHA256(plain).toString(CryptoJS.enc.Hex);
    pwInput.value = hash;
  });
});
</script>
</html>
