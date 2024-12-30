<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/main_css.css"> <!-- 스타일 경로 -->
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico.png">
</head>
<body>

<form>
	<div class="container">
        <h1 class="title">강넘빨</h1>
        <div class="image-container">
            <img src="${pageContext.request.contextPath}/images/tomaico.png" alt="토마토 캐릭터" class="tomato-image">
        </div>
        <div class="button-container">
            <button class="custom-button" onclick="location.href='my-surveys.jsp'">내 설문 보기</button>
            <button class="custom-button" onclick="location.href='new-survey.jsp'">설문 참여하기</button>
        </div>
    </div>
</form>





<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>

</script>
</body>
</html>