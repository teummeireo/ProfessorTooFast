<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico2.png">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/main_css.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main in P.T.F</title>
</head>
<body>
    <div class="container">
        <img src="${pageContext.request.contextPath}/images/tomaico2.png" alt="애니메이션 PNG" class="animated-image">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <header class="header">
            <div class="logo">🍅 Teummeireo</div>
            <nav class="nav">
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
            </nav>
        </header>

        <main class="main-content">
            <h1>Professor, Too Fast</h1>
            <p>"강사님 넘 빨라요"는 수업 설문 피드백 플랫폼입니다.</p>
        </main>

        <div class="cards">
            <div class="card">
                <h3>내 설문 보기</h3>
                <p>이전 설문 확인하기</p>
                <button class="btn" id="view-mysurvey-btn">설문 보기</button>
            </div>
            <div class="card">
                <h3>설문하기</h3>
                <p>설문지 작성하러가기</p>
                <button class="btn" id="view-survey-btn">설문 작성</button>
            </div>
        </div>

    </div>

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
                window.location.href = "${pageContext.request.contextPath}/survey.jsp"; //세션 유지 상태로 이동
            });
        });
    </script>
</body>
</html>
