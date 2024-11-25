<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="dao.model.userDAO" %>
<%@ page import="dao.bean.Userbean" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>My Page</title>
	<link rel="stylesheet" type="text/css" href="mypage.css">
</head>
<body>
	<%
		session = request.getSession(false);
		Userbean user = (Userbean) session.getAttribute("user");
		
		// 별점 처리
		double starRate; 
    	int starRateInt;

    	if (user.getStarRate() != null) {
    		starRate = Double.parseDouble(user.getStarRate());
    		starRateInt = (int) starRate;
    	} else {
    		starRate = 0;
    		starRateInt = 0;
    	}
    	
	%>
    <div class="sidebar">
    	<a href="main.jsp" class="logo-link">
            <img src="../images/logo.png" alt="Logo" class="logo">
            <span>책이음</span>
        </a>
        
        <ul>
            <li><img src="../images/sidebar1.png" alt="Search Icon"><span>책찾기</span></li>
            <li><img src="../images/sidebar2.png" alt="List Icon"><span>책등록</span></li>
            <li><img src="../images/sidebar3.png" alt="Chat Icon"><span>채팅하기</span></li>
        </ul>
    </div>
    <div class = "container">
           <div class="profile-section">
           <h1 class="title-special">My Page</h1>
               <div class = "profile-img">
               	<img src = "../images/profile0.4.png">
               </div>
               <div class="profile-name">${user.name } 님</div>
               <div class="rating-star">
                   <span>
                   <%
                   		for(int i = 0; i< 5; i++) {
                   			if (i< starRateInt) out.print("⭐");
                   			else out.print("☆");
                   		}
                   %>
                   </span>
               </div>
               <div class="rating-font">
                   <span>평균 평점: ${user.starRate }</span>
               </div>
               <a href="myInfo.jsp">
    				<button type="button">
        					<img src="../images/info.png" alt="Info"/> &nbsp;내 정보&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    				</button>
				</a>
				<a href="logout.jsp">
    				<button><img src="../images/logoutSmall.png"/> 로그아웃 </button>
				</a>
				<a href="unregister.jsp">
    				<button><img src="../images/logoutSmall.png"/> 회원 탈퇴 </button>
				</a>
           </div>

           <div class = "record-wrapper">
           	<div class="tabs">
	               <div class="tab active">내가 제공한 책</div>
	               <div class="tab">내가 받은 책</div>
	           </div>
	           <div class = "book-box">
	           <div class="book-list">
	               <div class="book-item">
	                   <img src="../images/booksample1.png" alt="나를 견디는 시간">
	                   <p>나를 견디는 시간</p>
	               </div>
	               <div class="book-item">
	                   <img src="../images/booksample2.png" alt="안녕은 단정하게">
	                   <p>안녕은 단정하게</p>
	               </div>
	               <div class="book-item">
	                   <img src="../images/booksample3.png" alt="불안이라는 위안">
	                   <p>불안이라는 위안</p>
	               </div>
	           </div>
	           <div class="book-list">
	               <div class="book-item">
	                   <img src="../images/booksample1.png" alt="나를 견디는 시간">
	                   <p>나를 견디는 시간</p>
	               </div>
	               <div class="book-item">
	                   <img src="../images/booksample2.png" alt="안녕은 단정하게">
	                   <p>안녕은 단정하게</p>
	               </div>
	               <div class="book-item">
	                   <img src="../images/booksample3.png" alt="불안이라는 위안">
	                   <p>불안이라는 위안</p>
	               </div>
	           </div>
	           </div>
	      </div>
       </div>
</body>
</html>