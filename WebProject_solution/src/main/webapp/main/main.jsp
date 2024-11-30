<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="dao.model.userDAO" %>
<%@ page import="dao.bean.Userbean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Exchange</title>
    <link rel="stylesheet" type="text/css" href="main.css">
    <script>
        function searchBook() {
            const searchInput = document.getElementById("searchInput").value.trim();
            if (searchInput === "") {
                alert("책 제목을 입력해주세요.");
                return false;
            }
            // 검색 폼 제출
            document.getElementById("searchForm").submit();
        }
    </script>
</head>
<body>
<%
   session = request.getSession(false);
   Userbean user = (Userbean) session.getAttribute("user");
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

<!-- Main Wrapper to hold content and right sidebar -->
<div class="main-wrapper">
    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <div class="header">
            <form id="searchForm" method="GET" action="mainAction.jsp" style="display: flex; align-items: center; width: 100%;">
                <img src="../images/search.png" alt="search">
                <input type="text" id="searchInput" name="title" placeholder="내가 읽고 싶었던 책을 검색해보세요!">
                <button type="button" onclick="searchBook()">검색</button>
            </form>
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
    <a href="../booksearch/booksearch.jsp">
        <img src="../images/more.png" alt="More Icon">

    </a>
</div>


            <div class="books">
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
                    Properties props = new Properties();

                    try (FileInputStream fis = new FileInputStream(propertiesPath)) {
                        props.load(fis);
                    } catch (IOException e) {
                        out.println("<p>DB 설정 파일 읽기 중 오류가 발생했습니다.</p>");
                    }

                    String dbURL = props.getProperty("jdbc.url");
                    String dbUser = props.getProperty("jdbc.username");
                    String dbPass = props.getProperty("jdbc.password");

                    // 최신 책 5개를 가져오기 위한 SQL 쿼리
                   String sql = "SELECT b.idBook, b.image1, b.title FROM Book b " +
             "ORDER BY b.idBook DESC LIMIT 5";  // idBook이 큰 순서대로 가져오기


                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                        pstmt = conn.prepareStatement(sql);

                        rs = pstmt.executeQuery();

                        if (!rs.isBeforeFirst()) { // 데이터가 없을 때
                %>
                            <script>
                                showAlertAndRedirect("최근 책 정보가 없습니다.", "booksearch.jsp");
                            </script>
                <%
                        }

                        while (rs.next()) {
                            String bookTitle = rs.getString("title");
                            Blob imageBlob = rs.getBlob("image1");

                            String base64Image = null;
                            if (imageBlob != null) {
                                InputStream inputStream = imageBlob.getBinaryStream();
                                ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                byte[] buffer = new byte[4096];
                                int bytesRead;
                                while ((bytesRead = inputStream.read(buffer)) != -1) {
                                    outputStream.write(buffer, 0, bytesRead);
                                }
                                byte[] imageBytes = outputStream.toByteArray();
                                base64Image = Base64.getEncoder().encodeToString(imageBytes);
                                inputStream.close();
                                outputStream.close();
                            }
                %>
                        <div class="book-item">
    <img src="data:image/jpeg;base64,<%= base64Image != null ? base64Image : "" %>" alt="<%= bookTitle %>">
    <p><%= bookTitle %></p>
    <button onclick="checkLogin(<%= user != null ? "true" : "false" %>, <%= rs.getInt("idBook") %>)">교환신청</button>
</div>

<script>
    function checkLogin(isLoggedIn, bookId) {
        if (!isLoggedIn) {
            alert("로그인이 필요한 서비스입니다.");
            window.location.href = "../User/login.jsp"; // 로그인 페이지로 이동
        } else {
            // 로그인이 되어 있으면 해당 책의 상세 페이지로 이동
            window.location.href = "../bookdetail/bookdetail.jsp?idBook=" + bookId;
        }
    }
</script>

                <%
                        }
                    } catch (Exception e) {
                        out.println("<p>데이터베이스 오류: " + e.getMessage() + "</p>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            out.println("<p>자원 해제 중 오류 발생: " + e.getMessage() + "</p>");
                        }
                    }
                %>
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
        <button class="genre-item" onclick="location.href='../booksearch/booksearch.jsp?genreId=1'">
            <img src="../images/genre.png" alt="Novel Icon"><p>소설</p>
        </button>
        <button class="genre-item" onclick="location.href='../booksearch/booksearch.jsp?genreId=2'">
            <img src="../images/genre.png" alt="Self-help Icon"><p>자기개발</p>
        </button>
        <button class="genre-item" onclick="location.href='../booksearch/booksearch.jsp?genreId=3'">
            <img src="../images/genre.png" alt="Essay Icon"><p>에세이</p>
        </button>
        <button class="genre-item" onclick="location.href='../booksearch/booksearch.jsp?genreId=4'">
            <img src="../images/genre.png" alt="History Icon"><p>역사서</p>
        </button>
        <button class="genre-item" onclick="location.href='../booksearch/booksearch.jsp?genreId=5'">
            <img src="../images/genre.png" alt="Science Icon"><p>과학서</p>
        </button>
        <button class="genre-item" onclick="location.href='../booksearch/booksearch.jsp?genreId=6'">
            <img src="../images/genre.png" alt="Travel Icon"><p>여행서</p>
        </button>
            <button class="genre-item" onclick="location.href='../booksearch/booksearch.jsp?genreId=7'">
        <img src="../images/genre.png" alt="Children's Book Icon"><p>아동도서</p>
    </button>
    <button class="genre-item" onclick="location.href='../booksearch/booksearch.jsp?genreId=8'">
        <img src="../images/genre.png" alt="Biography Icon"><p>자서전</p>
    </button>

    </div>
</div>
</body>
</html>
