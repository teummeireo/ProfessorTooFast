<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>


<c:if test = "${sessionScope.role != 'USER'}">
	<script>
		alert("일반 사용자만 사용가능합니다");
		location.href = "${pageContext.request.contextPath}/statistics";
	</script>
</c:if>