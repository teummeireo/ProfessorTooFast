<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register in P.T.F</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login_register.css"> <!-- 스타일 경로 -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico2.png">
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
                    <input type="text" id="register_loginId" placeholder="아이디" name="loginId" maxlength="16" required>
                    <button type="button" id="checkLoginId-btn" class="check-button">중복확인</button>
                </div>

                <!-- 닉네임 입력란과 중복 확인 버튼 -->
                <div class="input-group">
                    <input type="text" id="register_nickname" placeholder="닉네임" name="nickname" maxlength="16" required>
                    <button type="button" id="checkNickname-btn" class="check-button">중복확인</button>
                </div>
				<div class="input-group">
                <input type="password" id="register_password" placeholder="비밀번호" name="password" maxlength="16" required>
                </div>
                <div class="input-group">
                    <input type="text" id="register_joinCode" placeholder="코드번호를 입력하세요." name="joinCode" maxlength="64" required>
                </div>

                <button type="button" id="register-btn" value="registerTransfer" disabled>회원가입하기</button>
                <button type="button" class="secondary-button" onclick="goToLogin()">로그인하기</button>
            </form>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
$(document).ready(function () {
    let isLoginIdValid = false;
    let isNicknameValid = false;

    function updateRegisterButtonState() {
        console.log("Login ID Valid:", isLoginIdValid);
        console.log("Nickname Valid:", isNicknameValid);
        if (isLoginIdValid && isNicknameValid) {
            $("#register-btn").prop("disabled", false);
        } else {
            $("#register-btn").prop("disabled", true);
        }
    }

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
                    isLoginIdValid = true;
                } else {
                    alert("이미 사용 중인 아이디입니다.");
                    isLoginIdValid = false;
                }
                updateRegisterButtonState();
            },
            error: function () {
                alert("아이디 중복 체크 중 오류가 발생했습니다.");
            }
        });
    });

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
                    isNicknameValid = true;
                } else {
                    alert("이미 사용 중인 닉네임입니다.");
                    isNicknameValid = false;
                }
                updateRegisterButtonState();
            },
            error: function () {
                alert("닉네임 중복 체크 중 오류가 발생했습니다.");
            }
        });
    });
    
 // 회원가입 버튼 클릭 이벤트 핸들러
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
            success: function (res) {
                alert("회원가입이 성공적으로 완료되었습니다.");
                console.log("응답:", res);
                // 회원가입 후 로그인 페이지로 이동
                location.assign("login.jsp");
            },
            error: function (xhr, status, error) {
                console.error("에러 상태:", status);
                console.error("에러 메시지:", error);
                console.error("응답 텍스트:", xhr.responseText);
                try {
                    var response = JSON.parse(xhr.responseText);
                    alert("오류 발생: " + response.message);
                } catch (e) {
                    alert("회원가입 중 오류가 발생했습니다.");
                }
            }
        });
    });

    $("#register-btn").prop("disabled", true);
});

</script>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
	//로그인 페이지로 이동
	function goToLogin() {
		location.assign("login.jsp");
	}
</script>
</body>
</html>
