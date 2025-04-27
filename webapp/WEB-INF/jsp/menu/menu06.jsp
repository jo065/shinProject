<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>신원명판산업</title>
      <%@ include file="/WEB-INF/jsp/common/header.jsp" %>
       <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=e756b74a4c2b9dc078781e79e685e4ed"></script>
    <style>
        .address-text    {
        text-align: center;
        font-size: 20px;
        font-weight: bold;
        color: #1a3c6e;
                          }
    </style>

</head>
<body>
    <section class="about-section" id="about">
        <h2 class="section-title">오시는 길</h2>
        <p class="address-text">경기도 화성시 봉담읍 쇠틀길 86</p>
          <div class="case-studies">
            <div id="map" style="width:100%; height:350px;"></div>
          </div>
          <div class="map_ico_btn_wrap">
        </div>
    </section>
</body>

</html>

<script>
    window.onload = function () {
            var container = document.getElementById('map');
                 var options = {
                     center: new kakao.maps.LatLng(37.2009732, 126.9790237), // 경기도 화성시 봉담읍 쇠틀길 86의 위도, 경도
                     level: 3
                 };

                 var map = new kakao.maps.Map(container, options);

                 var markerPosition = new kakao.maps.LatLng(37.2009732, 126.9790237); // 마커 위치
                 var marker = new kakao.maps.Marker({
                     position: markerPosition
                 });
                 marker.setMap(map);
              };
</script>
 <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/static/js/menu/menu06.js"></script>