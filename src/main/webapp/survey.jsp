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
<!-- 
<link rel="stylesheet" type="text/css" href="/css/style.css">
-->
<style>
body {
    background-color: #FFBCBC;
    margin: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

/* Rectangle */
.rectangle {
    width: 40%;
    height: 100%;
    background-color: #FFFFFF;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    overflow-y: auto;
    overflow-x: hidden;
    position: relative;
}

/* 스크롤바 굵기 조정 */
.rectangle::-webkit-scrollbar {
    width: 10px; 
    height: 10px;
}

.rectangle::-webkit-scrollbar-thumb {
    background-color: #CCC; /* 스크롤바 색상 */
    border-radius: 10px; /* 둥글게 */
}

.rectangle::-webkit-scrollbar-track {
    background: #F7F7F7;
}

/* Header Bar */
.header-bar {
    background-color: #F5576D; /* 오렌지색 바 */
    height: 10px;
    width: 100%;
    border-top-left-radius: 8px;
    border-top-right-radius: 8px;
}

/* Title Section */
.title-section {
    padding: 25px;
    text-align: center;
    border-bottom: 1px solid #DDD; /* 구분선 */
}

.title-section h1 {
    margin: 0;
    font-size: 24px;
    color: #333333; /* 제목 색상 */
}

.title-section p {
    margin: 10px 0 0 0;
    font-size: 14px;
    color: #666666; /* 설명 텍스트 색상 */
}

/* Survey Section */
.survey-section {
    padding: 30px;
}

.survey-section p {
    font-size: 16px;
    color: #333333;
    margin-bottom: 10px;
}

.survey-options {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.survey-options label {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 14px;
    color: #666666;
}

.survey-options input[type="radio"] {
    margin-top: 5px;
    cursor: pointer;
}

/* Custom button styles */
.custom-button {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    padding: 14px 20px;
    gap: 10px;

    position: absolute;
    width: 77px;
    height: 44px;
    top: 20px;
    right: 20px;

    background: #F5576D;
    border-radius: 8px;

    border: none;
    color: white;
    font-size: 14px;
    cursor: pointer;
}

.custom-button:hover {
    background: #D6455A; 
}

/* Submit button styles */
.submit-button {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100px;
    height: 44px;
    margin: 20px auto 0 auto;
    background: #D6455A;
    border-radius: 8px;
    border: none;
    color: white;
    font-size: 14px;
    cursor: pointer;
}

.submit-button:hover {
    background: #A00060;
}

/* Textarea styles */
textarea {
    width: 100%;
    height: 80px;
    border-radius: 5px;
    border: 1px solid #DDD;
    padding: 10px;
    font-size: 14px;
    color: #333333;
}
</style>
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
    <button class="submit-button">Submit</button>
<br>
</div>
<button class="custom-button">Logout</button>
</body>
</html>
