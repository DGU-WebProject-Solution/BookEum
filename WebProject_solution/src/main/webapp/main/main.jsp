<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.model.userDAO" %>
<%@ page import="dao.bean.Userbean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Exchange</title>
    <link rel="stylesheet" type="text/css" href="main.css">
</head>
<body>
<%
	session = request.getSession(false);
	Userbean user = (Userbean) session.getAttribute("user");
%>
<!-- Sidebar -->
<div class="sidebar">
    <a href="../main/main.jsp"><img src="../images/logo.png" alt="Logo" class="logo"><span>책이음</span></a>
    <ul>
        <li>
            <a href="../booksearch/booksearch.jsp">
                <img src="../images/sidebar1.png" alt="Search Icon"><span>책찾기</span>
            </a>
        </li>
        <li>
            <a href="../bookregister/bookregister.jsp">
                <img src="../images/sidebar2.png" alt="List Icon"><span>책등록</span>
            </a>
        </li>
        <li>
            <a href="../chat/chat.jsp">
                <img src="../images/sidebar3.png" alt="Chat Icon"><span>채팅하기</span>
            </a>
        </li>
    </ul>
</div>

<!-- Main Wrapper to hold content and right sidebar -->
<div class="main-wrapper">
    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <div class="header">
            <img src="../images/search.png" alt="search">
            <input type="text" placeholder="내가 읽고 싶었던 책을 검색해보세요!">
        </div>

        <!-- Title -->
        <h1 class="title-special">Happy reading,<br>Sweat dream</h1>
        <p>나만의 책을 찾고, 당신의 책을 나누세요. <br>간단한 교환으로 새로운 이야기가 시작됩니다.</p>
           <% if (user != null) { %>
            <a href="../User/logout.jsp" class="login">로그아웃하기</a>
        <% } else { %>
             <a href="../User/login.jsp" class="login">로그인하기</a>
        <% } %>
      

        <!-- Book Section -->
        <div class="book-section">
            <h2 class="new-title">new</h2>
            <div class="books">
                <div class="book-item">
                    <img src="../images/booksample1.png" alt="Book 1">
                    <p>불안이라는 위안</p>
                    <button>교환신청</button>
                </div>
                <div class="book-item">
                    <img src="../images/booksample2.png" alt="Book 2">
                    <p>너와 함께라면 흔들리는 순간조차 사랑</p>
                    <button>교환신청</button>
                </div>
                <div class="book-item">
                    <img src="../images/booksample3.png" alt="Book 3">
                    <p>나를 견디는 시간</p>
                    <button>교환신청</button>
                </div>
                <div class="book-item">
                    <img src="../images/booksample4.png" alt="Book 4">
                    <p>안녕은 단정하게</p>
                    <button>교환신청</button>
                </div>
                <div class="book-item">
                    <img src="../images/booksample4.png" alt="Book 4">
                    <p>안녕은 단정하게</p>
                    <button>교환신청</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Right Sidebar -->
<div class="sidebar-right">
    <div class="account">
        <% if (user != null) { %>
            <a href="../User/mypage.jsp">
                <img src="../images/account.png" alt="Account Icon">
            </a> ${user.name} 님 환영합니다
        <% } else { %>
            <img src="../images/account.png" alt="Account Icon">
            <a href="../User/login.jsp" class="login-button">로그인하기</a>
        <% } %>
    </div>
    
    <div class="recommendbook">
        <img src="../images/booksample4.png" alt="Today's Book" class="todays-book-img">
        <h2 class="todaybook">Today's Book</h2>
        <p class="book-title">"인생은 간결하게"</p>
        <p class="book-description">
            사람들은 타인에 대해 이야기하는 것을 좋아한다. 단순히 이야기하는 것을 넘어서 서슴지 않게 평가를 하기도 한다.
            한 개인을 평가하는 여러 척도가 있을 텐데 아마 성격은 가장 중요한 척도 중 하나가 아닐까.
        </p>
    </div>
    
    <h2 class="genre-title">Genre</h2>
    <div class="genres">
        <button class="genre-item"><img src="../images/genre.png" alt="Novel Icon"><p>소설</p></button>
        <button class="genre-item"><img src="../images/genre.png" alt="Self-help Icon"><p>자기개발</p></button>
        <button class="genre-item"><img src="../images/genre.png" alt="Essay Icon"><p>에세이</p></button>
        <button class="genre-item"><img src="../images/genre.png" alt="History Icon"><p>역사서</p></button>
        <button class="genre-item"><img src="../images/genre.png" alt="Science Icon"><p>과학서</p></button>
        <button class="genre-item"><img src="../images/genre.png" alt="Travel Icon"><p>여행서</p></button>
        <button class="genre-item"><img src="../images/genre.png" alt="Children's Book Icon"><p>아동도서</p></button>
        <button class="genre-item"><img src="../images/genre.png" alt="Biography Icon"><p>자서전</p></button>
    </div>
</div>
</body>
</html>
