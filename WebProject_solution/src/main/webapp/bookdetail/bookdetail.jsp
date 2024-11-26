<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Exchange</title>
    <link rel="stylesheet" type="text/css" href="bookdetail.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <img src="./images/logo.png" alt="Logo" class="logo"><span>책이음</span>
        <ul>
            <li><img src="./images/sidebar1.png" alt="Search Icon"><span>책찾기</span></li>
            <li><img src="./images/sidebar2.png" alt="List Icon"><span>책등록</span></li>
            <li><img src="./images/sidebar3.png" alt="Chat Icon"><span>채팅하기</span></li>
        </ul>
    </div>

    <!-- Main Wrapper to hold content and right sidebar -->
    <div class="main-wrapper">
        <!-- Main Content -->
        <div class="main-content">
            <h1 class="title">악마는 법정에 서지 않는다 1</h1>
            <p>저자 : 양귀자</p>
            <p>교환자 : 이수민 <a href="#popup" class="button-link">사용자조회</a></p>
            <hr class="custom-hr">
            <div class="book-images">
                <img src="./images/booksample.png" alt="Book Image">
                <img src="./images/booksample.png" alt="Book Image">
                <img src="./images/booksample.png" alt="Book Image">
            </div>
            
            <h2>책 상태</h2>
            <p>여러 번 읽어서 책 모서리에 약간의 사용감이 있으며, 몇 페이지에 연필 메모가 있습니다. 내용 이해에는 전혀 문제 없습니다.</p>
            
            <h2>교환 조건</h2>
            <p>비슷한 장르의 책과 교환 원함. 소설, 에세이, 자기 계발서 등 비슷한 장르의 책과 교환을 원합니다.</p>
            
            <h2>교환 장소</h2>
            <p>서울시 중구 동국대학교</p>
            
            <h2>선호하는 거래방식</h2>
            <p>직거래</p>
        </div>
    </div>

    <!-- Right Sidebar -->
    <div class="sidebar-right">
        <div class="account">
            <img src="./images/account.png" alt="Account Icon"> 솔루션 님 환영합니다
        </div>
        
        <div class="my-book">
         <div class="dropdown-wrapper">
    <h2>내가 교환할 책
        <select class="dropdown">
            <option value="" disabled selected>▼</option>
            <option>책제목1</option>
            <option>책제목2</option>
        </select>
    </h2>
</div>

            <img src="./images/booksample.png" alt="My Book Image">
            <p><span class="label">제목:</span> <span class="value">모순</span></p>
            <p><span class="label">저자:</span> <span class="value">양귀자</span></p>
            <p><span class="label">교환 장소:</span> <span class="value">서울 특별시 도봉구 쌍문동</span></p>
            <p><span class="label">선호하는 거래방식:</span> <span class="value">도봉구 안에서 직거래를 선호합니다. 택배는 착불만 가능합니다.</span></p>
            <div class="book-button">
                <button class="chat-button">채팅하기</button>
            </div>
        </div>
    </div>

    <!-- Popup Section -->
    <div id="popup" class="popup-overlay">
        <div class="popup-content">
            <a href="#" class="close-button">&times;</a>
            <img src="./images/review.png" alt="User Image">
            <p>솔루션 님</p>
            <div class="stars">
                ★★★★☆
            </div>
            <p>평균 평점: 4.3</p>
        </div>
    </div>
</body>
</html>
