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

</head>
<body>

<div class="rectangle">
<div class="header-bar"></div>
<button class="custom-button">Logout</button>

    <div class="title-section">
        <h1>내 응답 보기</h1>
        <p>아래는 설문 조사 했던 결과입니다.</p>
    </div>

<form action="submitSurvey" method="post">
<div class="survey-section">
    <p>1. 오늘 수업의 난이도는 어땠나요? (1쉽다 → 10어렵다)</p>
    <br>
    <div class="survey-options">
        <c:forEach var="i" begin="1" end="10">
            <label>
                ${i}
                <input type="radio" name="difficulty" value="${i}" 
                    <c:if test="${i == difficulty}">checked</c:if> disabled>
            </label>
        </c:forEach>
        <input type="hidden" name="difficulty" value="${difficulty}">
    </div>
</div>

<div class="survey-section">
    <p>2. 오늘 수업의 진도의 빠르기 정도를 체크해주세요. (1느리다 → 10빠르다)</p>
    <br>
    <div class="survey-options">
        <c:forEach var="i" begin="1" end="10">
            <label>
                ${i}
                <input type="radio" name="speed" value="${i}" 
                    <c:if test="${i == speed}">checked</c:if> disabled>
            </label>
        </c:forEach>
        <input type="hidden" name="speed" value="${speed}">
    </div>
</div>

<div class="survey-section">
    <p>3. 오늘 수업 자료의 유용했던 정도를 체크해주세요. (1내용 추가가 필요하다 → 10유용했다)</p>
    <br>
    <div class="survey-options">
        <c:forEach var="i" begin="1" end="10">
            <label>
                ${i}
                <input type="radio" name="usefulness" value="${i}" 
                    <c:if test="${i == usefulness}">checked</c:if> disabled>
            </label>
        </c:forEach>
        <input type="hidden" name="usefulness" value="${usefulness}">
    </div>
</div>

<div class="survey-section">
    <p>4. 오늘 수업 중 궁금했던 내용이 있나요?</p>
    <br>
    <div class="survey-options1">
        <label>
            <input type="radio" name="question" value="yes" 
                <c:if test="${question == 'yes'}">checked</c:if> disabled> 네
        </label>
        <br>
        <br>
        <label>
            <input type="radio" name="question" value="no" 
                <c:if test="${question == 'no'}">checked</c:if> disabled> 아니오
        </label>
        <input type="hidden" name="question" value="${question}">
    </div>
</div>

<div class="survey-section">
    <p>4-1. 있다면 어떤 내용인가요?</p>
    <textarea disabled>${feedback}</textarea>
    <input type="hidden" name="feedback" value="${feedback}">
</div>

<div class="survey-section">
    <p>5. 강사님께 하고 싶은 말이 있다면 기입해주세요. (선택)</p>
    <textarea disabled>${feedback}</textarea>
    <input type="hidden" name="feedback" value="${feedback}">
</div>

	<br>
    <button class="home-button" onclick="location.href='main.jsp'">홈으로</button>
<br>
</form>
</div>
<button class="custom-button" onclick="location.href='login.jsp'">Logout</button>

</body>
</html>
