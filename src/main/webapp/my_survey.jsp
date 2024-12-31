<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" 	uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="x" 	uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="sql" 	uri="http://java.sun.com/jsp/jstl/sql" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tomato Survey</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

</head>
<body>
<jsp:include page = "${pageContext.request.contextPath}/check_session.jsp" />
<jsp:include page = "${pageContext.request.contextPath}/check_user.jsp" />
<div class="rectangle">
<div class="header-bar"></div>
<button class="custom-button">Logout</button>

    <div class="title-section">
        <h1>내 응답 보기</h1>
        <p>아래는 설문 조사 했던 결과입니다.</p>
    </div>

<form action="submitSurvey" method="post">
이거 설문지?
</form>
<button id="custom-button" class="custom-button">Logout</button>
<script>
$(document).ready(function () {
    // "내 응답 보기" 버튼 클릭 이벤트
    $("#mySurveys-btn").click(function () {
        userId = $("#mySurveys_userId").val();
        $.ajax({
            url: "${pageContext.request.contextPath}/api/mysurveys",
            method: "GET",
            data: "userId=" + userId,
            dataType: "json",
            success: function (obj) {
                console.log("응답:" + obj);

                $(obj).map(function (i, vo) {
                    console.log(vo.userId);
                    console.log(vo.surveyId);
                    console.log(vo.difficulty);
                    console.log(vo.speed);
                    console.log(vo.material);
                    console.log(vo.questions);
                    console.log(vo.comments);
                    console.log(vo.createAt);
                });
            },
            error: function (err) {
                console.log("에러:" + err);
            },
        });
    });

    // 로그아웃 버튼 클릭 이벤트
    $("#custom-button").click(function () {
        $.ajax({
            url: "${pageContext.request.contextPath}/api/logout",
            method: "POST",
            success: function () {
                alert("로그아웃이 완료되었습니다.");
                window.location.href = "${pageContext.request.contextPath}/main.jsp"; // 메인 페이지로 이동
            },
            error: function (err) {
                alert("로그아웃 중 오류가 발생했습니다.");
                console.error(err);
            },
        });
    });
});
</script>
</body>
</html>