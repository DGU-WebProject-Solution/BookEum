<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>LogIn</title>
	<link rel="stylesheet" type="text/css" href="user.css">
</head>
<body>
	<div>
        <h1 class="title-special">Log In</h1>
        <form>
        	<div class="form-group">
	            <input type="text" name="username" placeholder="ID">
	        </div>
	
	        <div class="form-group">
	            <input type="password" name="password" placeholder="Password">
	        </div>
        	<button class="submit-button">로그인</button>
        	<div class="footer-text">
        		아직 계정을 가지고 있지 않다면?
        		<a href="signup.jsp" >회원가입</a>
        	</div>
        </form>
    </div>
</body>
</html>