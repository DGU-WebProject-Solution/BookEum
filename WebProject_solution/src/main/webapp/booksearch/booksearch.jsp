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
    <link rel="stylesheet" type="text/css" href="booksearch.css">
</head>
<body>
<%
	session = request.getSession(false);
	Userbean user = (Userbean) session.getAttribute("user");
%>
    <div class="sidebar">
        <img src="./images/logo.png" alt="Logo" class="logo"><span>책이음</span>
        <ul>
            <li><a href="./booksearch.jsp"><img src="./images/sidebar1.png" alt="Search Icon"><span>책찾기</span></a></li>
            <li><a href="./bookregister.jsp"><img src="./images/sidebar2.png" alt="List Icon"><span>책등록</span></a></li>
            <li><a href="./chat.jsp"><img src="./images/sidebar3.png" alt="Chat Icon"><span>채팅하기</span></a></li>
        </ul>
    </div>

    <div class="main-wrapper">
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
        
        <div class="content-area">
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
            
            <div class="book-grid">
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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            String sql = "SELECT idBook, image1, title, author, excPlace FROM Book";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int bookId = rs.getInt("idBook");
                Blob imageBlob = rs.getBlob("image1");
                String title = rs.getString("title");
                String author = rs.getString("author");
                String excPlace = rs.getString("excPlace");

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
                <a href="../bookdetail/bookdetail.jsp?idBook=<%= bookId %>" class="book-card">
                    <img src="data:image/jpeg;base64,<%= base64Image != null ? base64Image : "" %>" alt="Book Image">
                    <div class="book-info">
                        <h3><%= title %></h3>
                        <p><%= author %></p>
                        <p><%= excPlace %></p>
                    </div>
                </a>
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
    </div>
</body>
</html>
