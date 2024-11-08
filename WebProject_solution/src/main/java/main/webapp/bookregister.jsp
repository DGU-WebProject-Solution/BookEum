<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Register</title>
    <link rel="stylesheet" type="text/css" href="bookregister.css">
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
           <div class="book-registration">
            <div class="image-upload">
                <div class="upload-box"><img src="./images/camera.png" alt="Upload Icon"></div>
                <div class="upload-box"><img src="./images/camera.png" alt="Upload Icon"></div>
                <div class="upload-box"><img src="./images/camera.png" alt="Upload Icon"></div>
            </div>
            
            <!-- Book Information Form -->
            <form class="book-info-form">
                <div class="form-group">
                    <label for="title">책 제목</label>
                    <input type="text" id="title" placeholder="책 제목을 입력해주세요">
                </div>
                
                <div class="form-group">
                    <label for="author">책 저자</label>
                    <input type="text" id="author" placeholder="책 저자를 입력해주세요">
                </div>
                
                <div class="form-group">
                    <label for="condition">책 상태</label>
                    <textarea id="condition" placeholder="신뢰할 수 있는 거래를 위해 자세히 적어주세요"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="trade-conditions">교환 조건</label>
                    <textarea id="trade-conditions" placeholder="원하는 교환 조건을 적어주세요"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="trade-location">교환 장소</label>
                    <input type="text" id="trade-location" placeholder="거래 희망 장소를 적어주세요">
                </div>
                
                <div class="form-group">
                    <label for="trade-method">선호하는 거래방식</label>
                    <input type="text" id="trade-method" placeholder="선호하는 거래 방식을 적어주세요  예) 직거래, 택배">
                </div>
                 <div class="button-wrapper">
                <button type="submit" class="register-button">등록하기</button>
            </div></form>
        </div>
            
        
    </div>
    <!-- Right Sidebar -->
    <div class="sidebar-right">
        <div class="account">
            <img src="./images/account.png" alt="Account Icon"> 솔루션 님 환영합니다
        </div>
        
       </div>
    </div>
</body>
</html>