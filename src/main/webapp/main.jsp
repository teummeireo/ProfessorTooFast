<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
	
<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" 	uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="x" 	uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="sql" 	uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="icon" type="image/png"
	href="${pageContext.request.contextPath}/images/tomaico2.png">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/main_css.css">
<!-- 스타일 경로 -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Main in P.T.F</title>
<link rel="stylesheet" href="css/style.css">

</head>
<body>

	<style>
body, html {
	margin: 0;
	padding: 0;
	font-family: 'Montserrat', sans-serif;
	font-weight: bold;
	box-sizing: border-box;
	background: linear-gradient(135deg, #790604, #FF4500);
	color: #fff;
	overflow-x: hidden;
}

.container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px;
}

/* Header */
/* Header */
.header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	background: #000;
	padding: 20px 40px;
	border-radius: 20px;
	width: 1200px; /* 고정된 너비 설정 */
	margin: 0 auto; /* 자동으로 중앙 정렬 */
	position: relative; /* Allow translation */
}

.logo {
	font-size: 24px;
	font-weight: bold;
	display: flex;
	align-items: center;
}

.nav a {
	text-decoration: none;
	color: white;
	margin-left: 20px;
	padding: 10px 20px;
	border-radius: 8px;
	transition: all 0.3s ease;
}

.nav .btn.secondary:hover {
	background: rgba(255, 255, 255, 0.2);
}

/* Main Content */
.main-content {
	text-align: center;
	margin: 100px auto;
}

.main-content h1 {
	font-size: 3.5rem;
	margin-bottom: 20px;
	line-height: 1.2;
}

.main-content p {
	font-size: 1.2rem;
	margin-bottom: 30px;
}

/* Background Gradient and Effects */
body::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: radial-cgradient(circle at 30% 30%, rgba(255, 255, 255, 0.1),
		transparent 70%);
	z-index: -1;
}
/* PNG 이미지 이동 및 회전 애니메이션 */
.animated-image {
	width: 50px; /* 이미지 크기 조정 */
	height: auto;
	animation: moveAndRotate 5s linear infinite; /* 이동 및 회전 애니메이션 적용 */
}

/* 애니메이션 정의 */
@
keyframes moveAndRotate { 0% {
	transform: translateX(0) rotate(0deg); /* 처음 위치 및 회전 */
}

50
%
{
transform
:
translateX(
300px
)
rotate(
180deg
); /* 오른쪽으로 이동 및 180도 회전 */
}
100
%
{
transform
:
translateX(
0
)
rotate(
360deg
); /* 원래 위치 및 360도 회전 */
}
}
.cards {
	display: flex;
	justify-content: center;
	gap: 20px;
	margin-top: 20px;
}

.card {
	color: white;
	padding: 30px;
	border-radius: 12px;
	text-align: center;
	width: 200px;
	background-color: #000; /* 카드 배경색 */
	border: 2px solid #035f14; /* 카드 테두리 색 */
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 카드 그림자 */
	transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover {
	transform: translateY(-5px); /* 카드 호버 시 살짝 위로 이동 */
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3); /* 그림자 강도 증가 */
}

.card h3 {
	font-size: 1.5rem;
	margin-bottom: 10px;
	font-weight: bold;
}

.card p {
	font-size: 1rem;
	margin-bottom: 15px;
}

.card .btn {
	background: linear-gradient(135deg, #035f14, #035f14); /* 버튼 배경색 */
	color: white;
	border: none;
	padding: 12px 25px; /* 버튼 크기 */
	font-size: 1.1rem;
	border-radius: 8px;
	cursor: pointer;
	transition: background-color 0.3s ease, transform 0.3s ease;
}

.card .btn:hover {
	background-color: #9d4edd; /* 버튼 호버 시 배경 색상 */
	transform: scale(1.05); /* 버튼 크기 증가 효과 */
}

.card .btn:focus {
	outline: none; /* 버튼 클릭 시 테두리 제거 */
	box-shadow: 0 0 5px 2px rgba(0, 0, 0, 0.2); /* 클릭 시 테두리 효과 */
}
.survey-message {
    display: block;
    margin-top: 10px;
    font-size: 0.9rem;
    color: red;
}

</style>

	<div class="container">
		<img src="${pageContext.request.contextPath}/images/tomaico2.png"
			alt="애니메이션 PNG" class="animated-image">


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



		<!-- Main Content -->
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
		        <button class="btn" id="view-survey-btn" disabled>설문 작성</button>
		        <p class="survey-message" style="margin-top: 10px; font-size: 0.9rem; color: red;"></p>
		    </div>
		</div>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script>
		$(document).ready(function () {
			
			let isSubmit = null; // 초기 상태를 null로 설정
	        var userId = "${sessionScope.userId}";
	        
	        // 상태 메시지 및 버튼 초기화 함수
	        function updateSurveyButtonState(isSubmit, userId) {
	            const messageElement = $(".survey-message"); // 메시지 표시 영역
	            const surveyButton = $("#view-survey-btn"); // 설문 버튼

	            if (!userId) {
	                surveyButton.prop("disabled", true);
	                messageElement.text("로그인을 해주세요.");
	            } else if (isSubmit == false) {
	                surveyButton.prop("disabled", false);
	                messageElement.text(""); // 메시지 초기화
	            } else if (isSubmit == true) {
	                surveyButton.prop("disabled", true);
	                messageElement.text("설문을 이미 제출하셨습니다.");
	            }
	        }
	        

	        // userId가 세션에 있는 경우에만 요청 실행
	        $.ajax({
	            url: "/api/users",
	            method: 'GET',
	            data: { userId: userId }, // 객체로 전달
	            dataType: "json",
	            success: function (obj) {
	                console.log("응답:" + obj);
	                console.log(obj['loginId']);
	                console.log(obj['nickname']);
	                console.log(obj['role']);
	                console.log(obj['isSubmit']); 
	                isSubmit = obj['isSubmit'];
	                updateSurveyButtonState(isSubmit, userId);
	            },
	            error: function (err) {
	            	console.error("세션 데이터를 가져오는 중 오류 발생");
	                updateSurveyButtonState(null, null); // 기본 상태로 초기화
	            }
	        });

    	
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

	</div>
</body>
</html>
