<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tomato Survey</title>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/tomaico2.png">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
function openModal() {
    document.getElementById('myModal').style.display = 'block';
}

function closeModal() {
    document.getElementById('myModal').style.display = 'none';
}
</script>
</head>
<body>
<jsp:include page="${pageContext.request.contextPath}/check_session.jsp" />
<jsp:include page="${pageContext.request.contextPath}/check_user.jsp" />

<div class="rectangle">
    <div class="header-bar"></div>
    
    <!-- Title Section -->
    <div class="title-section">
        <h1>수업 피드백 설문</h1>
        <p>오늘 배운 수업에 대한 내용을 피드백 받는 설문조사 입니다 :)</p>
    </div>

    <div class="survey-section">
        <p>1. 오늘 수업의 난이도는 어땠나요? (1: 쉽다 → 10: 어렵다)</p>
        <div class="survey-options">
            <c:forEach var="i" begin="1" end="10">
                <label>
                    ${i}
                    <input type="radio" class="difficulty" name="difficulty" value="${i}">
                </label>
            </c:forEach>
        </div>
    </div>

    <div class="survey-section">
        <p>2. 오늘 수업의 진도의 빠르기 정도를 체크해주세요. (1: 느리다 → 10: 빠르다)</p>
        <div class="survey-options">
            <c:forEach var="i" begin="1" end="10">
                <label>
                    ${i}
                    <input type="radio" class="speed" name="speed" value="${i}">
                </label>
            </c:forEach>
        </div>
    </div>

    <div class="survey-section">
        <p>3. 오늘 수업 자료의 유용했던 정도를 체크해주세요. (1: 내용 추가가 필요하다 → 10: 유용했다)</p>
        <div class="survey-options">
            <c:forEach var="i" begin="1" end="10">
                <label>
                    ${i}
                    <input type="radio" class="material" name="material" value="${i}">
                </label>
            </c:forEach>
        </div>
    </div>

    <div class="survey-section">
        <p>4. 오늘 수업 중 궁금했던 내용이 있다면 어떤 내용인지 입력해주세요. (선택)</p>
        <textarea id="questions" style="width: 100%; height: 80px; border-radius: 5px; border: 1px solid #DDD; padding: 10px;"></textarea>
    </div>

    <div class="survey-section">
        <p>5. 강사님께 하고 싶은 말이 있다면 기입해주세요. (선택)</p>
        <textarea id="comments" style="width: 100%; height: 80px; border-radius: 5px; border: 1px solid #DDD; padding: 10px;"></textarea>
    </div>

    <button id="surveyInsert-btn" class="submit-button">제출하기</button>
    <br>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <button class="custom-button">Logout</button>
</div>

<script>
$(document).ready(function () {
    $("#surveyInsert-btn").click(function () {
    	// 선택된 값 가져오기
        var difficulty = $("input[name='difficulty']:checked").val();
        var speed = $("input[name='speed']:checked").val();
        var material = $("input[name='material']:checked").val();

        // 필수 항목 체크
        if (!difficulty || !speed || !material) {
            alert("필수 설문 문항에 모두 답해주세요!");
            return; // 함수 종료
        }

        var surveyInsertData = {
            userId: "${sessionScope.userId}",
            difficulty: difficulty,
            speed: speed,
            material: material,
            questions: $("#questions").val(),
            comments: $("#comments").val()
        };

        console.log("설문 데이터:", surveyInsertData);

        $.ajax({
            url: "${pageContext.request.contextPath}/api/surveys",
            method: "POST",
            data: JSON.stringify(surveyInsertData),
            contentType: "application/json; charset=UTF-8",
            success: function (res) {
                console.log("응답:", res);

                // SweetAlert2로 모달 대체
                Swal.fire({
                    icon: 'success',
                    title: '제출 완료되었습니다!',
                    html: `
                        <p>답변이 성공적으로 제출되었습니다.<br>원하시는 다음 작업을 선택하세요.</p>
                        <div>
                        	<button class="survey-button" onclick="location.href='${pageContext.request.contextPath}/'">홈으로 가기</button>
                        	<button class="survey-button1" onclick="location.href='${pageContext.request.contextPath}/surveys/my'">내 설문 확인하기</button>
                        </div>
                    `,
                    showConfirmButton: false,
                    allowOutsideClick: false
                });
            },
            error: function (xhr, status, error) {
                console.error("에러:", error, "상태:", status);
                alert(xhr.responseText);
            }
        });
    });
});
</script>
    <button class="custom-button">Logout</button>


<script>
$(document).ready(function () {
    // 로그아웃 버튼 클릭 이벤트
    $(".custom-button").click(function () {
        $.ajax({
            url: "${pageContext.request.contextPath}/api/logout",
            method: "POST",
            success: function () {
                alert("로그아웃이 완료되었습니다.");
                window.location.href = "${pageContext.request.contextPath}/"; // 메인 페이지로 이동
            },
            error: function (err) {
                alert("로그아웃 중 오류가 발생했습니다.");
                console.error(err);
            }
        });
    });
});
</script>
</body>
</html>