<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<%@ page import="dao.model.userDAO" %>
<%@ page import="dao.bean.Userbean" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Exchange</title>
    <link rel="stylesheet" type="text/css" href="bookdetail.css">
</head>
<body>
<%
   session = request.getSession(false);
   Userbean user = (Userbean) session.getAttribute("user");
%>
    <!-- Sidebar -->
    <div class="sidebar">
    <a href="http://localhost:8080/WebProject_solution/main/main.jsp"><img src="../images/logo.png" alt="Logo" class="logo"><span>책이음</span></a>
    <ul>
        <li>
            <a href="http://localhost:8080/WebProject_solution/booksearch/booksearch.jsp">
                <img src="../images/sidebar1.png" alt="Search Icon"><span>책찾기</span>
            </a>
        </li>
        <li>
            <a href="http://localhost:8080/WebProject_solution/bookregister/bookregister.jsp">
                <img src="../images/sidebar2.png" alt="List Icon"><span>책등록</span>
            </a>
        </li>
        <li>
            <a href="http://localhost:8080/WebProject_solution/chat/chat.jsp">
                <img src="../images/sidebar3.png" alt="Chat Icon"><span>채팅하기</span>
            </a>
        </li>
    </ul>
</div>

    <!-- Main Wrapper to hold content and right sidebar -->
    <div class="main-wrapper">
        <!-- Main Content -->
        <div class="main-content">
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

                int bookId = Integer.parseInt(request.getParameter("idBook"));

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                    String sql = "SELECT * FROM Book WHERE idBook = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, bookId);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        Blob image1 = rs.getBlob("image1");
                        Blob image2 = rs.getBlob("image2");
                        Blob image3 = rs.getBlob("image3");
                        String title = rs.getString("title");
                        String author = rs.getString("author");
                        String stateInfo = rs.getString("stateInfo");
                        String excCondition = rs.getString("excCondition");
                        String excPlace = rs.getString("excPlace");
                        String excType = rs.getString("excType");

                        String base64Image1 = image1 != null ? Base64.getEncoder().encodeToString(image1.getBytes(1, (int) image1.length())) : "./images/booksample.png";
                        String base64Image2 = image2 != null ? Base64.getEncoder().encodeToString(image2.getBytes(1, (int) image2.length())) : "./images/booksample.png";
                        String base64Image3 = image3 != null ? Base64.getEncoder().encodeToString(image3.getBytes(1, (int) image3.length())) : "./images/booksample.png";
            %>
                        <h1 class="title"><%= title %></h1>
                        <p>저자: <%= author %></p>
                        <p>교환자: <a href="#popup" class="button-link">사용자조회</a></p>
                        <hr class="custom-hr">
                        <div class="book-images">
                            <img src="data:image/jpeg;base64,<%= base64Image1 %>" alt="Book Image 1">
                            <img src="data:image/jpeg;base64,<%= base64Image2 %>" alt="Book Image 2">
                            <img src="data:image/jpeg;base64,<%= base64Image3 %>" alt="Book Image 3">
                        </div>

                        <h2>책 상태</h2>
                        <p><%= stateInfo %></p>

                        <h2>교환 조건</h2>
                        <p><%= excCondition %></p>

                        <h2>교환 장소</h2>
                        <p><%= excPlace %></p>

                        <h2>선호하는 거래방식</h2>
                        <p><%= excType %></p>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>오류 발생: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </div>
    </div>

    <!-- Right Sidebar -->
    <div class="sidebar-right">
                 <div class="account">
        <% if (user != null) { %>
            <a href="http://localhost:8080/WebProject_solution/User/mypage.jsp">
                <img src="../images/account.png" alt="Account Icon">
            </a> ${user.name} 님 환영합니다
        <% } else { %>
            <img src="../images/account.png" alt="Account Icon">
            <a href="http://localhost:8080/WebProject_solution/User/login.jsp" class="login-button">로그인하기</a>
        <% } %>
    </div>
        
   <div class="my-book">
    <div class="dropdown-wrapper">
        <h2>내가 교환할 책</h2>
        <select id="bookDropdown" class="dropdown">
            <option value="" disabled selected>▼</option>
            <%  
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                    String sql = "SELECT idBook, title FROM Book WHERE id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, user.getId());
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int idBook = rs.getInt("idBook");
                        String bookTitle = rs.getString("title");
            %>
                        <option value="<%= idBook %>"><%= bookTitle %></option>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </select>
    </div>

    <!-- 책 상세 정보 표시 영역 -->
    <div id="bookDetails">
        <p>책을 선택하면 상세 정보가 여기에 표시됩니다.</p>
    </div>
</div>

<script>
    document.getElementById("bookDropdown").addEventListener("change", function () {
        var selectedBookId = this.value;

        // Ajax를 통해 선택된 책 ID를 서버로 전송
        fetch("bookdetailAction.jsp?idBook=" + selectedBookId)
            .then(response => response.text())
            .then(data => {
                // bookDetails 영역에 서버 응답 데이터 표시
                document.getElementById("bookDetails").innerHTML = data;
            })
            .catch(error => {
                console.error("Error fetching book details:", error);
            });
    });
</script>

      
            <div class="book-button">
                  <button class="chat-button" onclick="location.href='http://localhost:8080/WebProject_solution/chat/chat.jsp';">
        채팅하기
    </button>
            </div>
        </div>
    </div>

    <!-- Popup Section -->
    <div id="popup" class="popup-overlay">
        <div class="popup-content">
            <a href="#" class="close-button">&times;</a>
            <img src="../images/review.png" alt="User Image">
            <p>솔루션 님</p>
            <div class="stars">
                ★★★★☆
            </div>
            <p>평균 평점: 4.3</p>
        </div>
    </div>
</body>
</html>