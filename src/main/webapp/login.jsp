<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login in P.T.F</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login_register.css"> <!-- 스타일 경로 -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico.png">
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
                
                <input type="text" id="login_loginId" placeholder="Enter Your email address" name="loginId" required>
                <input type="password" id="login_password" placeholder="Enter Password" name="password" required>

                <button type="button" id="login-btn" class="loginForm" value="loginTransfer">Log In</button>
                <button type="button" class="secondary-button" onclick="goToRegister()">Go To Sign Up</button>
            </form>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
$(document).ready(function() {
    // 로그인 버튼 클릭 이벤트
    $("#login-btn").click( function() {
		
		var loginFormData = $("#login").serialize();
		var loginData = {
	            loginId: $("#login_loginId").val(),
	            password: $("#login_password").val(),	
		};

	    $.ajax({
	    	url: "${pageContext.request.contextPath}/api/login",
	    	method 		: 'POST' , 
	    	data 		: JSON.stringify(loginData) , 			
	    	contentType : "application/json; charset=UTF-8",
	    	dataType 	: "json",  	
	    	success 	: function(obj) {
	    						console.log("응답:" + obj);
	    						console.log(obj['userId']);
	    						console.log(obj['nickname']);
	    						console.log(obj['role']);
	    						window.location.href = "${pageContext.request.contextPath}/main.jsp";
	    					}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });	    		
	});
    
 	// Enter 키로 로그인 처리
    $("#loginForm").on("keydown", function (e) {
        if (e.keyCode === 13) {
            e.preventDefault(); // 기본 Enter 키 동작 방지 (폼 제출 방지)
            $("#login-btn").click(); // 로그인 버튼 클릭 트리거
        }
    });
    
});
</script>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
//회원가입 페이지로 이동
	function goToRegister() {
	    window.location.href = "register.jsp";
	}
</script>

</body>
</html>
