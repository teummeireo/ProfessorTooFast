<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" 	uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" 	uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="x" 	uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="sql" 	uri="http://java.sun.com/jsp/jstl/sql" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login in P.T.F</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login_register.css"> <!-- 스타일 경로 -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico2.png">
</head>
<body>
    <div class="container">
        <!-- 왼쪽 이미지 배경 -->
        <div class="left-panel"></div>
        
        <!-- 오른쪽 로그인 폼 -->
        <div class="right-panel">
            <form id="loginForm">
                <h2>로그인</h2>
                <p>Please enter your details to continue.</p>
                
                <input type="text" id="login_loginId" placeholder="아이디" name="loginId" required>
                <input type="password" id="login_password" placeholder="비밀번호" name="password" required>
	<br>
	<br>
                <button type="button" id="login-btn" class="loginForm" value="loginTransfer">로그인</button>
                <button type="button" class="secondary-button" onclick="goToRegister()">회원가입</button>
                <br>
                <br>
            </form>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
$(document).ready(function() {
    // 로그인 버튼 클릭 이벤트
    $("#login-btn").click(function() {
        var loginData = {
            loginId: $("#login_loginId").val(),
            password: $("#login_password").val()
        };

        $.ajax({
            url: "${pageContext.request.contextPath}/api/login",
            method: 'POST',
            data: JSON.stringify(loginData),
            contentType: "application/json; charset=UTF-8",
            dataType: "json",
            success: function(obj) {
                // role에 따라 분기 처리
                if (obj.role === "ADMIN") {
                    window.location.href = "${pageContext.request.contextPath}/statistics.jsp";
                } else if (obj.role === "USER") {
                    window.location.href = "${pageContext.request.contextPath}/main.jsp";
                } else {
                    alert("알수없는 유저입니다.");
                }
            },
            error: function(err) {
                console.log("에러:", err);
                alert("로그인 실패. 다시 시도해주세요.");
            }
        });
    });

    // Enter 키로 로그인 처리
    $("#loginForm").on("keydown", function(e) {
        if (e.keyCode === 13) {
            e.preventDefault(); // 기본 Enter 키 동작 방지 (폼 제출 방지)
            $("#login-btn").click(); // 로그인 버튼 클릭 트리거
        }
    });
    
});
</script>

<script>
	function goToRegister() {
	    location.assign("register.jsp"); // 히스토리 남김
	    // 또는
	    // location.replace("register.jsp"); // 히스토리 남기지 않음
	}
</script>



</body>
</html>
