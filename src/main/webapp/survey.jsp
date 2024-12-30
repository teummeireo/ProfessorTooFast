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
<link rel ="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">

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

<div class="rectangle">
<div class="header-bar"></div>
    
    <!-- Title Section -->
    <div class="title-section">
        <h1>수업 피드백 설문</h1>
        <p>오늘 배운 수업에 대한 내용을 피드백 받는 설문조사 입니다 : )</p>
    </div>


    <div class="survey-section">
        <p>1. 오늘 수업의 난이도는 어땠나요? (1쉽다 → 10어렵다)</p>
        <br>
        <div class="survey-options">
            <label>
                1
                <input type="radio" name="difficulty" value="1">
            </label>
            <label>
                2
                <input type="radio" name="difficulty" value="2">
            </label>
            <label>
                3
                <input type="radio" name="difficulty" value="3">
            </label>
            <label>
                4
                <input type="radio" name="difficulty" value="4">
            </label>
            <label>
                5
                <input type="radio" name="difficulty" value="5">
            </label>
            <label>
                6
                <input type="radio" name="difficulty" value="6">
            </label>
            <label>
                7
                <input type="radio" name="difficulty" value="7">
            </label>
            <label>
                8
                <input type="radio" name="difficulty" value="8">
            </label>
            <label>
                9
                <input type="radio" name="difficulty" value="9">
            </label>
            <label>
                10
                <input type="radio" name="difficulty" value="10">
            </label>
        </div>
    </div>


    <div class="survey-section">
        <p>2. 오늘 수업의 진도의 빠르기 정도를 체크해주세요. (1느리다 → 10빠르다)</p>
        <br>
        <div class="survey-options">
            <label>
                1
                <input type="radio" name="speed" value="1">
            </label>
            <label>
                2
                <input type="radio" name="speed" value="2">
            </label>
            <label>
                3
                <input type="radio" name="speed" value="3">
            </label>
            <label>
                4
                <input type="radio" name="speed" value="4">
            </label>
            <label>
                5
                <input type="radio" name="speed" value="5">
            </label>
            <label>
                6
                <input type="radio" name="speed" value="6">
            </label>
            <label>
                7
                <input type="radio" name="speed" value="7">
            </label>
            <label>
                8
                <input type="radio" name="speed" value="8">
            </label>
            <label>
                9
                <input type="radio" name="speed" value="9">
            </label>
            <label>
                10
                <input type="radio" name="speed" value="10">
            </label>
        </div>
    </div>


    <div class="survey-section">
        <p>3. 오늘 수업 자료의 유용했던 정도를 체크해주세요. (1내용 추가가 필요하다 → 10유용했다)</p>
        <br>
        <div class="survey-options">
            <label>
                1
                <input type="radio" name="speed" value="1">
            </label>
            <label>
                2
                <input type="radio" name="speed" value="2">
            </label>
            <label>
                3
                <input type="radio" name="speed" value="3">
            </label>
            <label>
                4
                <input type="radio" name="speed" value="4">
            </label>
            <label>
                5
                <input type="radio" name="speed" value="5">
            </label>
            <label>
                6
                <input type="radio" name="speed" value="6">
            </label>
            <label>
                7
                <input type="radio" name="speed" value="7">
            </label>
            <label>
                8
                <input type="radio" name="speed" value="8">
            </label>
            <label>
                9
                <input type="radio" name="speed" value="9">
            </label>
            <label>
                10
                <input type="radio" name="speed" value="10">
            </label>
        </div>
    </div>


    <div class="survey-section">
        <p>4. 오늘 수업 중 궁금했던 내용이 있나요? (선택)</p>
        <br>
        <div class="survey-options1">
            <label>
                <input type="radio" name="question" value="yes">
                네
            </label>
            <br>
            <br>
            <label>
                <input type="radio" name="question" value="no">
                아니오
            </label>
        </div>
    </div>

    <div class="survey-section">
        <p>4-1. 있다면 어떤 내용인가요?</p>
        <textarea style="width: 100%; height: 80px; border-radius: 5px; border: 1px solid #DDD; padding: 10px;"></textarea>
    </div>

    <div class="survey-section">
        <p>5. 강사님께 하고 싶은 말이 있다면 기입해주세요. (선택)</p>
        <textarea style="width: 100%; height: 80px; border-radius: 5px; border: 1px solid #DDD; padding: 10px;"></textarea>
    </div>
	<br>
    <button class="submit-button" onclick="openModal()">제출하기</button>
    <br>
<div id="myModal" class="modal">
    <div class="modal-content">
        <h2>제출 완료되었습니다!</h2>
        <p>답변이 성공적으로 제출되었습니다. <br>원하시는 다음 작업을 선택하세요.</p>
        <div class="modal-buttons">
            <button class="home-button" onclick="location.href='main.jsp'">홈으로 가기</button>
            <button class="survey-button" onclick="location.href='my_survey.jsp'">내 설문 확인하기</button>
            <br>
        </div>
    </div>
</div>

</div>
	<button class="custom-button" onclick="location.href='login.jsp'">Logout</button>
</body>
</html>
