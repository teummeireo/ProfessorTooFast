<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico.png">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/main_css.css"> <!-- 스타일 경로 -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main in P.T.F</title>
</head>
<body>
    <div class="navbar">
        <div class="logo">P.T.F.</div>

        <!-- 로그인 상태에 따라 버튼 표시 -->
        <div class="nav-links">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <!-- 로그아웃 버튼 -->
                    <button id="logout-btn" class="logout-btn">Logout</button>
                </c:when>
                <c:otherwise>
                    <!-- 로그인 버튼 -->
                    <a href="${pageContext.request.contextPath}/login.jsp" class="login-btn">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="hero">
        <h1>강사님넘빨라요</h1>
        <p>A.K.A. 강넘빨</p>
        <!-- 세션 정보에 따라 환영 메시지 표시 -->
        <c:choose>
            <c:when test="${not empty sessionScope.userId}">
                <p>Welcome back, ${sessionScope.user.nickname} (${sessionScope.user.role})</p>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="cta-btn">Login to get started</a>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="banner">
        Welcome to the P.T.F platform!
    </div>

    <div class="cards">
        <div class="card">
            <h3>내 설문 보기</h3>
            <p>이전 설문 확인하기</p>
            <a href="#" id="view-mysurvey-btn">설문 보기</a>
        </div>
        <div class="card">
            <h3>설문하기</h3>
            <p>설문지 작성하러가기</p>
            <a href="#" id="view-survey-btn">설문 작성</a>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
    $(document).ready(function () {
        // 로그아웃 버튼 클릭 이벤트
        $("#logout-btn").click(function () {
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
                }
            });
        });

        // "내 설문 보기" 버튼 클릭 이벤트
        $("#view-mysurvey-btn").click(function (e) {
            e.preventDefault(); // 기본 동작 막기
            window.location.href = "${pageContext.request.contextPath}/my_survey.jsp"; // 세션 유지 상태로 이동
        });

        // "설문 작성" 버튼 클릭 이벤트
        $("#view-survey-btn").click(function (e) {
            e.preventDefault(); // 기본 동작 막기
            window.location.href = "${pageContext.request.contextPath}/survey.jsp"; // 세션 유지 상태로 이동
        });
    });
</script>
</body>
</html>
