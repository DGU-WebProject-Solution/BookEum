<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Exchange</title>
    <link rel="stylesheet" type="text/css" href="booksearch.css">
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

    <!-- Main Content Wrapper -->
    <div class="main-wrapper">
        <!-- User Account Welcome Message at the top-right -->
        <div class="account">
            <img src="./images/account.png" alt="Account Icon"> 솔루션 님 환영합니다
        </div>
        
        <!-- Filters and Book Grid -->
        <div class="content-area">
            <!-- Filters -->
            <div class="filters">
                <select class="filter-dropdown">
                    <option value="">장르</option>
                    <option value="소설">소설</option>
                    <option value="자기개발">자기개발</option>
                    <option value="에세이">에세이</option>
                    <option value="역사서">역사서</option>
                    <option value="과학서">과학서</option>
                    <option value="여행서">여행서</option>
                    <option value="아동도서">아동도서</option>
                    <option value="자서전">자서전</option>
                </select>
                <input type="text" class="filter-input" placeholder="저자명">
                <input type="text" class="filter-input" placeholder="제목">
                <input type="text" class="filter-input" placeholder="시/도">
                <input type="text" class="filter-input" placeholder="구/군">
                <button class="filter-button search-button">🔍</button>
            </div>
            
            <!-- Book Grid -->
            <div class="book-grid">
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>모순</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>악마는 법정에 서지 않는다</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <!-- 추가적인 책 카드 예시 -->
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>돈의 속성</h3>
                        <p>저자명</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>모순</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>악마는 법정에 서지 않는다</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <!-- 추가적인 책 카드 예시 -->
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>돈의 속성</h3>
                        <p>저자명</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>모순</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>악마는 법정에 서지 않는다</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <!-- 추가적인 책 카드 예시 -->
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>돈의 속성</h3>
                        <p>저자명</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>모순</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>악마는 법정에 서지 않는다</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <!-- 추가적인 책 카드 예시 -->
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>돈의 속성</h3>
                        <p>저자명</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>모순</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>악마는 법정에 서지 않는다</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <!-- 추가적인 책 카드 예시 -->
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>돈의 속성</h3>
                        <p>저자명</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>모순</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>악마는 법정에 서지 않는다</h3>
                        <p>양귀자</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
                <!-- 추가적인 책 카드 예시 -->
                <div class="book-card">
                    <img src="./images/booksample.png" alt="Book Image">
                    <div class="book-info">
                        <h3>돈의 속성</h3>
                        <p>저자명</p>
                        <p>서울특별시 노원구</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
