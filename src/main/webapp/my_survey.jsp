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
        padding: 20px;
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
        padding: 20px;
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

    /* Button */
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
</style>
</head>
<body>

<div class="rectangle">
<div class="header-bar"></div>
    
    <!-- Title Section -->
    <div class="title-section">
        <h1>수업 피드백 설문</h1>
        <p>오늘 배운 수업에 대한 내용을 피드백 받는 설문조사 입니다 :)</p>
    </div>

    <!-- 1번 Section -->
    <div class="survey-section">
        <p>1. 오늘 수업의 난이도는 어땠나요? (1쉽다 → 10어렵다)</p>
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
</div>

<button class="custom-button">Logout</button>

</body>
</html>
