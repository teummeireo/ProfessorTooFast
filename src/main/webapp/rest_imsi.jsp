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
<input type="text" name="loginId" id="register_loginId"> 
<input type="text" name="password" id="register_password"> 
<input type="text" name="nickname" id="register_nickname">
<input type="text" name="joinCode" id="register_joinCode">
<input type="button" id="register-btn" value="registerTransfer">
</form>
<hr><br>

<form id="login">
<input type="text" name="loginId" id="login_loginId"> 
<input type="text" name="password" id="login_password"> 
<input type="button" id="login-btn" value="loginTransfer">
</form>
<hr><br>

<form id="logout">
<input type="button" id="logout-btn" value="logoutTransfer">
</form>
<hr><br>

<form id="surveyInsert">
<input type="text" name="userId" id="surveyInsert_userId"> 
<input type="text" name="difficulty" id="surveyInsert_difficulty"> 
<input type="text" name="speed" id="surveyInsert_speed">
<input type="text" name="material" id="surveyInsert_material">
<input type="text" name="questions" id="surveyInsert_questions">
<input type="text" name="comments" id="surveyInsert_comments">
<input type="button" id="surveyInsert-btn" value="surveyInsertTransfer">
</form>
<hr><br>

<form id="userInfo">
<input type="text" name="userId" id="userInfo_userId">
<input type="button" id="userInfo-btn" value="userInfoTransfer">
</form>
<hr><br>

<form id="checkLoginId">
<input type="text" name="loginId" id="checkLoginId_loginId">
<input type="button" id="checkLoginId-btn" value="checkLoginIdTransfer">
</form>
<hr><br>

<form id="checkNickname">
<input type="text" name="nickname" id="checkNickname_nickname">
<input type="button" id="checkNickname-btn" value="checkNicknameTransfer">
</form>
<hr><br>

<form id="mySurveys">
<input type="text" name="userId" id="mySurveys_userId">
<input type="button" id="mySurveys-btn" value="mySurveysTransfer">
</form>
<hr><br>

<form id="dailySurveys">
<input type="text" name="createAt" id="dailySurveys_createAt">
<input type="button" id="dailySurveys-btn" value="dailySurveysTransfer">
</form>
<hr><br>

<form id="dailyStatistics">
<input type="text" name="createAt" id="dailyStatistics_createAt">
<input type="button" id="dailyStatistics-btn" value="dailyStatisticsTransfer">
</form>
<hr><br>


<form id="monthlyStatistics">
<input type="text" name="month" id="monthlyStatistics_month">
<input type="button" id="monthlyStatistics-btn" value="monthlyStatisticsTransfer">
</form>
<hr><br>

<form id="periodStatistics">
<input type="text" name="startDate" id="periodStatistics_startDate">
<input type="text" name="endDate" id="periodStatistics_endDate">
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
	
		var registerFormData = $("#register").serialize();

	    $.ajax({
	    	url  		: "/api/users" ,
	    	method 		: 'POST' , 
	    	data 		: registerFormData , 			
	    	contentType : "application/json; charset=UTF-8",
	    	//dataType 	: "String", 	
	    	success 	: function(res) { console.log("응답:" + res) }   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });	    		
	});
	
	//----------------------------------------------------------------------------------
	//로그인
	//----------------------------------------------------------------------------------
	$("#login-btn").click( function() {
		
		var loginFormData = $("#login").serialize();

	    $.ajax({
	    	url  		: "/api/login" ,
	    	method 		: 'POST' , 
	    	data 		: loginFormData , 			
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
		
		var surveyInsertFormData = $("#surveyInsert").serialize();

	    $.ajax({
	    	url  		: "/api/surveys" ,
	    	method 		: 'POST' , 
	    	data 		: surveyInsertFormData , 			
	    	contentType : "application/json; charset=UTF-8",
	    	//dataType 	: "String", 	
	    	success 	: function(res) { console.log("응답:" + res) }   ,
	    	error 		: function(err) { console.log("에러:" + err) }  
	    });	    		
	});	
	
	//----------------------------------------------------------------------------------
	//유저 정보
	//----------------------------------------------------------------------------------
	$("userInfo-btn").click( function() {  
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
	$("checkLoginId-btn").click( function() {  
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
	$("checkNickname-btn").click( function() {  
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
	$("mySurveys-btn").click( function() {  
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
	$("dailySurveys-btn").click( function() {  
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
	$("dailyStatistics-btn").click( function() {  
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
	$("monthlyStatistics-btn").click( function() {  
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
	$("periodStatistics-btn").click( function() {  
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