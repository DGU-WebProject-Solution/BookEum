<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.model.userDAO" %>
<%@ page import="dao.bean.Userbean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Register</title>
    <link rel="stylesheet" type="text/css" href="bookregister.css">
</head>
<body>
<%
    session = request.getSession(false);
    Userbean user = (Userbean) session.getAttribute("user");

    // 로그인 체크
    if (user == null) {
        out.print("<script>alert('로그인이 필요한 서비스입니다'); window.location='../User/login.jsp';</script>");
        return; // 페이지가 계속 로드되지 않도록 return
    }
%>
    <!-- Sidebar -->
    <div class="sidebar">
        <a href="../main/main.jsp">
            <img src="../images/logo.png" alt="Logo" class="logo">
            <span>책이음</span>
        </a>
        <ul> 
            <li>
                <a href="../booksearch/booksearch.jsp">
                    <img src="../images/sidebar1.png" alt="Search Icon">
                    <span>책찾기</span>
                </a>
            </li>
            <li>
                <a href="../bookregister/bookregister.jsp">
                    <img src="../images/sidebar2.png" alt="Register Icon">
                    <span>책등록</span>
                </a>
            </li>
            <li>
                <a href="../chat/chat.jsp">
                    <img src="../images/sidebar3.png" alt="Chat Icon">
                    <span>채팅하기</span>
                </a>
            </li>
        </ul>
    </div>

    <!-- Main Wrapper -->
    <div class="main-wrapper">
        <div class="main-content">
            <div class="book-registration">
                <!-- Book Information Form -->
                <form class="book-info-form" action="bookregisterAction.jsp" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="title">책 제목</label>
                        <input type="text" id="title" name="title" placeholder="책 제목을 입력해주세요" required>
                    </div>
                    <div class="form-group">
                        <label for="author">책 저자</label>
                        <input type="text" id="author" name="author" placeholder="책 저자를 입력해주세요" required>
                    </div>
                    <div class="form-group">
                        <label for="genre">장르 선택</label>
                        <select name="genreId" id="genre" required>
                            <option value="">장르 선택</option>
                            <option value="1">소설</option>
                            <option value="2">자기개발</option>
                            <option value="3">에세이</option>
                            <option value="4">역사서</option>
                            <option value="5">과학서</option>
                            <option value="6">여행서</option>
                            <option value="7">아동도서</option>
                            <option value="8">자서전</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="stateInfo">책 상태</label>
                        <textarea id="stateInfo" name="stateInfo" placeholder="신뢰할 수 있는 거래를 위해 자세히 적어주세요" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="excCondition">교환 조건</label>
                        <textarea id="excCondition" name="excCondition" placeholder="원하는 교환 조건을 적어주세요" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="excPlace">교환 장소</label>
                        <input type="text" id="excPlace" name="excPlace" placeholder="거래 희망 장소를 적어주세요" required>
                    </div>
                    <div class="form-group">
                        <label for="excType">선호하는 거래방식</label>
                        <input type="text" id="excType" name="excType" placeholder="선호하는 거래 방식을 적어주세요 (예: 직거래, 택배)" required>
                    </div>
                    <div class="form-group">
                        <label for="image1">메인 사진</label>
                        <input type="file" id="image1" name="image1" accept="image/*" required>
                    </div>
                    <div class="form-group">
                        <label for="image2">사진 1</label>
                        <input type="file" id="image2" name="image2" accept="image/*">
                    </div>
                    <div class="form-group">
                        <label for="image3">사진 2</label>
                        <input type="file" id="image3" name="image3" accept="image/*">
                    </div>
                    <div class="button-wrapper">
                        <button type="submit" class="register-button">등록하기</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
