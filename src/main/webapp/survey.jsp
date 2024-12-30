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
            <input type="radio" id="difficulty1" name="difficulty" value="1">
        </label>
        <label>
            2
            <input type="radio" id="difficulty2" name="difficulty" value="2">
        </label>
        <label>
            3
            <input type="radio" id="difficulty3" name="difficulty" value="3">
        </label>
        <label>
            4
            <input type="radio" id="difficulty4" name="difficulty" value="4">
        </label>
        <label>
            5
            <input type="radio" id="difficulty5" name="difficulty" value="5">
        </label>
        <label>
            6
            <input type="radio" id="difficulty6" name="difficulty" value="6">
        </label>
        <label>
            7
            <input type="radio" id="difficulty7" name="difficulty" value="7">
        </label>
        <label>
            8
            <input type="radio" id="difficulty8" name="difficulty" value="8">
        </label>
        <label>
            9
            <input type="radio" id="difficulty9" name="difficulty" value="9">
        </label>
        <label>
            10
            <input type="radio" id="difficulty10" name="difficulty" value="10">
        </label>
    </div>
</div>

<div class="survey-section">
    <p>2. 오늘 수업의 진도의 빠르기 정도를 체크해주세요. (1느리다 → 10빠르다)</p>
    <br>
    <div class="survey-options">
        <label>
            1
            <input type="radio" id="speed1" name="speed" value="1">
        </label>
        <label>
            2
            <input type="radio" id="speed2" name="speed" value="2">
        </label>
        <label>
            3
            <input type="radio" id="speed3" name="speed" value="3">
        </label>
        <label>
            4
            <input type="radio" id="speed4" name="speed" value="4">
        </label>
        <label>
            5
            <input type="radio" id="speed5" name="speed" value="5">
        </label>
        <label>
            6
            <input type="radio" id="speed6" name="speed" value="6">
        </label>
        <label>
            7
            <input type="radio" id="speed7" name="speed" value="7">
        </label>
        <label>
            8
            <input type="radio" id="speed8" name="speed" value="8">
        </label>
        <label>
            9
            <input type="radio" id="speed9" name="speed" value="9">
        </label>
        <label>
            10
            <input type="radio" id="speed10" name="speed" value="10">
        </label>
    </div>
</div>

<div class="survey-section">
    <p>3. 오늘 수업 자료의 유용했던 정도를 체크해주세요. (1내용 추가가 필요하다 → 10유용했다)</p>
    <br>
    <div class="survey-options">
        <label>
            1
            <input type="radio" id="material1" name="material" value="1">
        </label>
        <label>
            2
            <input type="radio" id="material2" name="material" value="2">
        </label>
        <label>
            3
            <input type="radio" id="material3" name="material" value="3">
        </label>
        <label>
            4
            <input type="radio" id="material4" name="material" value="4">
        </label>
        <label>
            5
            <input type="radio" id="material5" name="material" value="5">
        </label>
        <label>
            6
            <input type="radio" id="material6" name="material" value="6">
        </label>
        <label>
            7
            <input type="radio" id="material7" name="material" value="7">
        </label>
        <label>
            8
            <input type="radio" id="material8" name="material" value="8">
        </label>
        <label>
            9
            <input type="radio" id="material9" name="material" value="9">
        </label>
        <label>
            10
            <input type="radio" id="material10" name="material" value="10">
        </label>
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
	<br>
<button id="surveyInsert-btn" class="submit-button" onclick="openModal()">제출하기</button>
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
<script>
$(document).ready(function() {
	$("#surveyInsert-btn").click( function() {
		
		var surveyInsertData = {
				userId: $("#surveyInsert_userId").val(),
				difficulty: $("input[name='difficulty']:checked").val(), // 선택된 라디오 버튼 값
	            speed: $("input[name='speed']:checked").val(), // 선택된 라디오 버튼 값
	            material: $("input[name='material']:checked").val(), // 선택된 라디오 버튼 값
				questions: $("#surveyInsert_questions").val(),
				comments: $("#surveyInsert_comments").val()
	        };

	    $.ajax({
	    	url  		: "${pageContext.request.contextPath}/api/surveys" ,
	    	method 		: 'POST' , 
	    	data 		: JSON.stringify(surveyInsertData) , 			
	    	contentType : "application/json; charset=UTF-8",
	    	//dataType 	: "String", 	
	    	success 	: function(res) { console.log("응답:" + res) }   ,
	    	error: function(xhr, status, error) {
    	        // xhr 객체에서 응답 텍스트를 가져오기
    	        console.log("에러 상태:", status);
    	        console.log("에러 메시지:", error);
    	        console.log("응답 텍스트:", xhr.responseText); // 서버에서 반환한 응답
    	        // 필요에 따라 xhr 객체를 JSON으로 변환하여 출력
    	        try {
    	            var response = JSON.parse(xhr.responseText);
    	            console.log("응답 객체:", response);
    	        } catch (e) {
    	            console.log("응답이 JSON 형식이 아닙니다:", xhr.responseText);
    	        }
    	    }  
	    });	    		
	});
});

</script>

<script>
    // URL에서 파라미터 읽기
    const params = new URLSearchParams(window.location.search);
    const userId = params.get('userId');
    const nickname = params.get('nickname');
    const role = params.get('role');

    // 읽어온 값 확인 (개발용 출력)
    console.log("User ID:", userId);
    console.log("Nickname:", nickname);
    console.log("Role:", role);

    // 페이지에 표시 (선택)
    document.addEventListener("DOMContentLoaded", () => {
        document.getElementById("userInfo").textContent = `Logged in as: ${nickname} (Role: ${role})`;
    });
</script>

</body>
</html>