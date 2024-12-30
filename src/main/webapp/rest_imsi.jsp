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
<title>Insert title here</title>
</head>
<body>
<form id="register">
loginId		<input type="text" name="loginId" id="register_loginId"> 
password	<input type="text" name="password" id="register_password"> 
nickname	<input type="text" name="nickname" id="register_nickname">
joinCode	<input type="text" name="joinCode" id="register_joinCode">
<input type="button" id="register-btn" value="registerTransfer">
</form>
<hr><br>

<form id="login">
loginId		<input type="text" name="loginId" id="login_loginId"> 
password	<input type="text" name="password" id="login_password"> 
<input type="button" id="login-btn" value="loginTransfer">
</form>
<hr><br>

<form id="logout">
<input type="button" id="logout-btn" value="logoutTransfer">
</form>
<hr><br>

<form id="surveyInsert">
userId		<input type="text" name="userId" id="surveyInsert_userId"> 
difficulty	<input type="text" name="difficulty" id="surveyInsert_difficulty"> 
speed		<input type="text" name="speed" id="surveyInsert_speed">
material	<input type="text" name="material" id="surveyInsert_material">
questions	<input type="text" name="questions" id="surveyInsert_questions">
comments	<input type="text" name="comments" id="surveyInsert_comments">
<input type="button" id="surveyInsert-btn" value="surveyInsertTransfer">
</form>
<hr><br>

<form id="userInfo">
userId		<input type="text" name="userId" id="userInfo_userId">
<input type="button" id="userInfo-btn" value="userInfoTransfer">
</form>
<hr><br>

<form id="checkLoginId">
loginId		<input type="text" name="loginId" id="checkLoginId_loginId">
<input type="button" id="checkLoginId-btn" value="checkLoginIdTransfer">
</form>
<hr><br>

<form id="checkNickname">
nickname	<input type="text" name="nickname" id="checkNickname_nickname">
<input type="button" id="checkNickname-btn" value="checkNicknameTransfer">
</form>
<hr><br>

<form id="mySurveys">
userId		<input type="text" name="userId" id="mySurveys_userId">
<input type="button" id="mySurveys-btn" value="mySurveysTransfer">
</form>
<hr><br>

<form id="dailySurveys">
createAt	<input type="text" name="createAt" id="dailySurveys_createAt">
<input type="button" id="dailySurveys-btn" value="dailySurveysTransfer">
</form>
<hr><br>

<form id="dailyStatistics">
createAt	<input type="text" name="createAt" id="dailyStatistics_createAt">
<input type="button" id="dailyStatistics-btn" value="dailyStatisticsTransfer">
</form>
<hr><br>


<form id="monthlyStatistics">
month		<input type="text" name="month" id="monthlyStatistics_month">
<input type="button" id="monthlyStatistics-btn" value="monthlyStatisticsTransfer">
</form>
<hr><br>

<form id="periodStatistics">
startDate	<input type="text" name="startDate" id="periodStatistics_startDate">
endDate		<input type="text" name="endDate" id="periodStatistics_endDate">
<input type="button" id="periodStatistics-btn" value="periodStatisticsTransfer">
</form>
<hr><br>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
$( document ).ready(function() {
	//$("#btn").click( function() {  
	//    	$("#input").val();
	//});
	
	//----------------------------------------------------------------------------------
	//회원가입
	//----------------------------------------------------------------------------------
	$("#register-btn").click( function() { 
	
	    var registerData = {
	            loginId: $("#register_loginId").val(),
	            password: $("#register_password").val(),
	            nickname: $("#register_nickname").val(),
	            joinCode: $("#register_joinCode").val()
	        };

	    $.ajax({
	    	url  		: "/api/users" ,
	    	method 		: 'POST' , 
	    	data 		: JSON.stringify(registerData) , 			
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
	
	//----------------------------------------------------------------------------------
	//로그인
	//----------------------------------------------------------------------------------
	$("#login-btn").click( function() {
		
		var loginFormData = $("#login").serialize();
		var loginData = {
	            loginId: $("#login_loginId").val(),
	            password: $("#login_password").val(),	
		};

	    $.ajax({
	    	url  		: "/api/login" ,
	    	method 		: 'POST' , 
	    	data 		: JSON.stringify(loginData) , 			
	    	contentType : "application/json; charset=UTF-8",
	    	dataType 	: "json",  	
	    	success 	: function(obj) {
	    						console.log("응답:" + obj);
	    						console.log(obj['userId']);
	    						console.log(obj['nickname']);
	    						console.log(obj['role']);
	    					}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });	    		
	});
	
	//----------------------------------------------------------------------------------
	//로그아웃
	//----------------------------------------------------------------------------------
	$("#logout-btn").click( function() {
		
	    $.ajax({
	    	url  		: "/api/logout" ,
	    	method 		: 'POST' , 
	    	//data 		:  			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	//dataType 	: "String",  	
	    	success 	: function(res) { console.log("응답:" + res) }   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });	    		
	});

	
	//----------------------------------------------------------------------------------
	//설문 제출
	//----------------------------------------------------------------------------------
	$("#surveyInsert-btn").click( function() {
		
		var surveyInsertData = {
				userId: $("#surveyInsert_userId").val(),
				difficulty: $("#surveyInsert_difficulty").val(),
				speed: $("#surveyInsert_speed").val(),
				material: $("#surveyInsert_material").val(),
				questions: $("#surveyInsert_questions").val(),
				
				comments: $("#surveyInsert_comments").val()
	        };

	    $.ajax({
	    	url  		: "/api/surveys" ,
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
	
	//----------------------------------------------------------------------------------
	//유저 정보
	//----------------------------------------------------------------------------------
	$("#userInfo-btn").click( function() {  
	    userId = $("#userInfo_userId").val();
	    $.ajax({
	    	url  		: "/api/users" ,
	    	method 		: 'GET' , 
	    	data 		: "userId="+userId , 			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	dataType 	: "json",	
	    	success 	: function(obj) {
								console.log("응답:" + obj);
								console.log(obj['loginId']);
								console.log(obj['nickname']);
								console.log(obj['role']);
								console.log(obj['isSubmit']);
			}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });
	});


	//----------------------------------------------------------------------------------
	//아이디 중복 체크
	//----------------------------------------------------------------------------------
	$("#checkLoginId-btn").click( function() {  
	    loginId = $("#checkLoginId_loginId").val();
	    $.ajax({
	    	url  		: "/api/users/check-duplicate-id" ,
	    	method 		: 'GET' , 
	    	data 		: "loginId="+loginId , 			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	dataType 	: "json",	
	    	success 	: function(obj) {
								console.log("응답:" + obj);
								console.log(obj['isLoginIdUnique']);
			}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });
	});
	
	
	//----------------------------------------------------------------------------------
	//닉네임 중복 체크
	//----------------------------------------------------------------------------------
	$("#checkNickname-btn").click( function() {  
	    nickname = $("#checkNickname_nickname").val();
	    $.ajax({
	    	url  		: "/api/users/check-duplicate-nickname" ,
	    	method 		: 'GET' , 
	    	data 		: "nickname="+nickname , 			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	dataType 	: "json",	
	    	success 	: function(obj) {
								console.log("응답:" + obj);
								console.log(obj['isNicknameUnique']);
			}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });
	});
	
	
	//----------------------------------------------------------------------------------
	//내 설문 리스트 조회
	//----------------------------------------------------------------------------------
	$("#mySurveys-btn").click( function() {  
		userId = $("#mySurveys_userId").val();
	    $.ajax({
	    	url  		: "/api/mysurveys" ,
	    	method 		: 'GET' , 
	    	data 		: "userId="+userId , 			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	dataType 	: "json",	
	    	success 	: function(obj) {
								console.log("응답:" + obj);

								$(obj).map(function(i, vo) {
									console.log(vo.userId);
									console.log(vo.surveyId);
									console.log(vo.difficulty);
									console.log(vo.speed);
									console.log(vo.material);
									console.log(vo.questions);
									console.log(vo.comments);
									console.log(vo.createAt);
				});
			}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });
	});
	
	
	//----------------------------------------------------------------------------------
	//일별 설문 리스트 조회
	//----------------------------------------------------------------------------------
	$("#dailySurveys-btn").click( function() {  
		createAt = $("dailySurveys_createAt").val();
	    $.ajax({
	    	url  		: "/api/surveys" ,
	    	method 		: 'GET' , 
	    	data 		: "createAt="+createAt , 			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	dataType 	: "json",	
	    	success 	: function(obj) {
								console.log("응답:" + obj);

								$(obj).map(function(i, vo) {
									console.log(vo.userId);
									console.log(vo.surveyId);
									console.log(vo.difficulty);
									console.log(vo.speed);
									console.log(vo.material);
									console.log(vo.questions);
									console.log(vo.comments);
									console.log(vo.createAt);
				});
			}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });
	});
	
	
	//----------------------------------------------------------------------------------
	//일별 통계 보기
	//----------------------------------------------------------------------------------
	$("#dailyStatistics-btn").click( function() {  
		createAt = $("dailyStatistics_createAt").val();
	    $.ajax({
	    	url  		: "/api/daily-statistics" ,
	    	method 		: 'GET' , 
	    	data 		: "createAt="+createAt , 			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	dataType 	: "json",	
	    	success 	: function(obj) {
								console.log("응답:" + obj);
								console.log(obj['recordDate']);
								console.log(obj['avgDifficulty']);
								console.log(obj['avgSpeed']);
								console.log(obj['avgMaterial']);
								console.log(obj['population']);
			}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });
	});
	
	//----------------------------------------------------------------------------------
	//월별 통계 보기
	//----------------------------------------------------------------------------------
	$("#monthlyStatistics-btn").click( function() {  
		month = $("monthlyStatistics_month").val();
	    $.ajax({
	    	url  		: "/api/monthly-statistics" ,
	    	method 		: 'GET' , 
	    	data 		: "month="+month , 			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	dataType 	: "json",	
	    	success 	: function(obj) {
								console.log("응답:" + obj);
								console.log(obj['recordDate']);
								console.log(obj['avgDifficulty']);
								console.log(obj['avgSpeed']);
								console.log(obj['avgMaterial']);
								console.log(obj['population']);
			}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });
	});

	//----------------------------------------------------------------------------------
	//기간별 통계 보기
	//----------------------------------------------------------------------------------
	$("#periodStatistics-btn").click( function() {  
		startDate = $("periodStatistics_startDate").val();
		endDate = $("periodStatistics_endDate").val();
	    $.ajax({
	    	url  		: "/api/period-statistics" ,
	    	method 		: 'GET' , 
	    	data 		: "startDate="+startDate+"&endDate="+endDate , 			
	    	//contentType : "application/x-www-form-urlencoded; charset=UTF-8", 
	    	dataType 	: "json",	
	    	success 	: function(obj) {
								console.log("응답:" + obj);
								console.log(obj['startDate']);
								console.log(obj['endDate']);
								console.log(obj['avgDifficulty']);
								console.log(obj['avgSpeed']);
								console.log(obj['avgMaterial']);
								console.log(obj['population']);
			}   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });
	});

	
	
	
});
</script>
</body>
</html>