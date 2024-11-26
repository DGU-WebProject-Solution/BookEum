<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="dao.model.userDAO" %>
	<%@ page import="dao.bean.Userbean" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>My Information</title>
	<link rel="stylesheet" type="text/css" href="user.css">
</head>
<body>
	<%
	
	session = request.getSession(false);
	Userbean user = (Userbean) session.getAttribute("user");
	
	// 생년월일 분리 
	String birth = user.getBirth(); 
	String[] birthParts = birth.split("-");
	String year = birthParts[0];  
	String month = birthParts[1]; 
	String day = birthParts[2];
	
	%>
		<div>
			<div class = "title-container">
				<h1 class="title-special">My Info</h1>
			</div>
			<form action="mypage.jsp" method="post">
		
			아이디
	        <div class="form-group">
	            <input type="text" name="id" value="${user.emailId}" placeholder="solution" disabled>
	        </div>
			
			이름
	        <div class="form-group">
	            <input type="text" name="name" value="${user.name}" placeholder="솔루션" disabled>
	        </div>
			
			생년월일
	        <div class="form-group birth-date-group">
	            <input type="text" name="year" value = <%= year %> placeholder="2002년" maxlength="4" disabled>
	            <input type="text" name="month" value = <%= month %> placeholder="01월" maxlength="2" disabled>
	            <input type="text" name="day" value = <%= day %> placeholder="01일" maxlength="2" disabled>
	        </div>
	
	        주소
	        <div class="form-group address-group">
	            <input type="text" name="city" value="${user.addressCity}" placeholder="서울시/군" disabled>
	            <input type="text" name="district" value="${user.addressGu}" placeholder="중구" disabled>
	        </div>
	
	        <button type="submit" class="check-button">확인</button>
    	</form>
	</div>
</body>
</html>