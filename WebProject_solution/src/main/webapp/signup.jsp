<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Sign Up</title>
	<link rel="stylesheet" type="text/css" href="user.css">
</head>
<body>
	<div>
		<div class = "title-container">
				<h1 class="title-special">Sign Up</h1>
		</div>
		<form action="" method="post">
		
			아이디
	        <div class="form-group">
	            <input type="text" name="username" placeholder="아이디를 입력하세요." required>
	        </div>
	        
			비밀번호
	        <div class="form-group">
	            <input type="password" name="password" placeholder="비밀번호를 입력하세요." required>
	        </div>
			
			이름
	        <div class="form-group">
	            <input type="text" name="name" placeholder="이름" required>
	        </div>
			
			생년월일
	        <div class="form-group birth-date-group">
	            <input type="text" name="year" placeholder="년" maxlength="4">
	            <input type="text" name="month" placeholder="월" maxlength="2">
	            <input type="text" name="day" placeholder="일" maxlength="2">
	        </div>
	
	        주소
	        <div class="form-group address-group">
	            <input type="text" name="city" placeholder="시/군">
	            <input type="text" name="district" placeholder="구">
	        </div>
	
	        <button type="submit" class="submit-button">회원 가입</button>
    	</form>
	</div>
</body>
</html>