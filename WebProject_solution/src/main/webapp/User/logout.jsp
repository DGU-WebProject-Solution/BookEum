<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Sign up</title>
	<link rel="stylesheet" type="text/css" href="user.css">
</head>
<body>
	<%

    if (session != null) {
        session.invalidate();
        response.sendRedirect("../main/main.jsp");
    } else {
    	%>
    	<script type="text/javascript">
			alert("이미 로그아웃이 완료되었습니다.");
			window.location.href = "../main/main.jsp";
		</script>
		<%
    }
    
	%>
   
</body>
</html>