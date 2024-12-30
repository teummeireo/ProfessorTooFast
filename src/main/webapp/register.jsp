<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register in P.T.F</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login_register.css"> <!-- 스타일 경로 -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico.png">
</head>
<body>
    <div class="container">
        <div class="left-panel"></div>

        <div class="right-panel">
            <form id="registerForm">
                <h2>회원가입</h2>
                <p>Please enter your details to continue.</p>

                <!-- 아이디 입력란과 중복 확인 버튼 -->
                <div class="input-group">
                    <input type="text" id="register_loginId" placeholder="Enter Your email address" name="loginId" maxlength="16" required>
                    <button type="button" id="checkLoginId-btn" class="check-button">중복확인</button>
                </div>

                <!-- 닉네임 입력란과 중복 확인 버튼 -->
                <div class="input-group">
                    <input type="text" id="register_nickname" placeholder="Enter Nickname" name="nickname" maxlength="16" required>
                    <button type="button" id="checkNickname-btn" class="check-button">중복확인</button>
                </div>
				<div class="input-group">
                <input type="password" id="register_password" placeholder="Enter Password" name="password" maxlength="16" required>
                </div>
                <div class="input-group">
                    <input type="text" id="register_joinCode" placeholder="Enter Code" name="joinCode" maxlength="64" required>
                </div>

                <button type="button" id="register-btn" value="registerTransfer">Sign Up</button>
                <button type="button" class="secondary-button" onclick="goToLogin()">Go To Log In</button>
            </form>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
$(document).ready(function () {
    // 아이디 중복 체크
    $("#checkLoginId-btn").click(function () {
        var loginId = $("#register_loginId").val();

        if (!loginId) {
            alert("아이디를 입력해주세요.");
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/api/users/check-duplicate-id",
            method: "GET",
            data: { loginId: loginId },
            dataType: "json",
            success: function (response) {
                if (response.isLoginIdUnique) {
                    alert("사용 가능한 아이디입니다.");
                } else {
                    alert("이미 사용 중인 아이디입니다.");
                }
            },
            error: function () {
                alert("아이디 중복 체크 중 오류가 발생했습니다.");
            }
        });
    });

    // 닉네임 중복 체크
    $("#checkNickname-btn").click(function () {
        var nickname = $("#register_nickname").val();

        if (!nickname) {
            alert("닉네임을 입력해주세요.");
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/api/users/check-duplicate-nickname",
            method: "GET",
            data: { nickname: nickname },
            dataType: "json",
            success: function (response) {
                if (response.isNicknameUnique) {
                    alert("사용 가능한 닉네임입니다.");
                } else {
                    alert("이미 사용 중인 닉네임입니다.");
                }
            },
            error: function () {
                alert("닉네임 중복 체크 중 오류가 발생했습니다.");
            }
        });
    });

    // joinCode 유효성 체크
    $("#checkJoinCode-btn").click(function () {
        var joinCode = $("#register_joinCode").val();

        if (!joinCode) {
            alert("joinCode를 입력해주세요.");
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/api/users/check-join-code",
            method: "GET",
            data: { joinCode: joinCode },
            dataType: "json",
            success: function (response) {
                if (response.isValid) {
                    alert("유효한 joinCode입니다.");
                } else {
                    alert("유효하지 않은 joinCode입니다.");
                }
            },
            error: function () {
                alert("joinCode 확인 중 오류가 발생했습니다.");
            }
        });
    });

    // 회원가입 요청
    $("#register-btn").click(function () {
        var registerData = {
            loginId: $("#register_loginId").val(),
            password: $("#register_password").val(),
            nickname: $("#register_nickname").val(),
            joinCode: $("#register_joinCode").val()
        };

        $.ajax({
            url: "${pageContext.request.contextPath}/api/users",
            method: "POST",
            data: JSON.stringify(registerData),
            contentType: "application/json; charset=UTF-8",
            success: function () {
                alert("회원가입이 완료되었습니다.");
                window.location.href = "login.jsp";
            },
            error: function (xhr) {
                alert("회원가입 중 오류가 발생했습니다: " + xhr.responseText);
            }
        });
    });
});
</script>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
//로그인 페이지로 이동
	function goToLogin() {
	    window.location.href = "login.jsp";
	}
</script>
</body>
</html>
