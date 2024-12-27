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
    }
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
<button class="custom-button">Logout</button>

</body>
</html>