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
                <form method="GET" action="booksearch.jsp">
                    <select name="genreId" class="filter-dropdown">
                        <option value="">전체 장르</option>
                        <option value="1" <%= "1".equals(request.getParameter("genreId")) ? "selected" : "" %>>소설</option>
                        <option value="2" <%= "2".equals(request.getParameter("genreId")) ? "selected" : "" %>>자기개발</option>
                        <option value="3" <%= "3".equals(request.getParameter("genreId")) ? "selected" : "" %>>에세이</option>
                        <option value="4" <%= "4".equals(request.getParameter("genreId")) ? "selected" : "" %>>역사서</option>
                        <option value="5" <%= "5".equals(request.getParameter("genreId")) ? "selected" : "" %>>과학서</option>
                        <option value="6" <%= "6".equals(request.getParameter("genreId")) ? "selected" : "" %>>여행서</option>
                        <option value="7" <%= "7".equals(request.getParameter("genreId")) ? "selected" : "" %>>아동도서</option>
                        <option value="8" <%= "8".equals(request.getParameter("genreId")) ? "selected" : "" %>>자서전</option>
                    </select>
                    <input type="text" name="author" 
       value="<%= request.getParameter("author") != null ? request.getParameter("author") : "" %>" 
       class="filter-input" 
       placeholder="저자명">

                    <input type="text" name="title" 
       value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>" 
       class="filter-input" 
       placeholder="제목">

<input type="text" name="addressCity" 
       value="<%= request.getParameter("addressCity") != null ? request.getParameter("addressCity") : "" %>" 
       class="filter-input" 
       placeholder="시/도">

<input type="text" name="addressGu" 
       value="<%= request.getParameter("addressGu") != null ? request.getParameter("addressGu") : "" %>" 
       class="filter-input" 
       placeholder="구/군">

                    <button class="filter-button search-button">🔍</button>
                </form>
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

                    String selectedGenreId = request.getParameter("genreId");
                    String author = request.getParameter("author");
                    String title = request.getParameter("title");
                    String sido = request.getParameter("sido");
                    String gungu = request.getParameter("gungu");

                    String sql = "SELECT b.idBook, b.image1, b.title, b.author, b.excPlace " +
                                 "FROM Book b " +
                                 "INNER JOIN Genre g ON b.genreId = g.genreId WHERE 1=1";

                    List<Object> parameters = new ArrayList<>();

                    if (selectedGenreId != null && !selectedGenreId.isEmpty()) {
                        sql += " AND b.genreId = ?";
                        parameters.add(Integer.parseInt(selectedGenreId));
                    }
                    if (author != null && !author.isEmpty()) {
                        sql += " AND b.author LIKE ?";
                        parameters.add("%" + author + "%");
                    }
                    if (title != null && !title.isEmpty()) {
                        sql += " AND b.title LIKE ?";
                        parameters.add("%" + title + "%");
                    }
                    if (sido != null && !sido.isEmpty()) {
                        sql += " AND b.excPlace LIKE ?";
                        parameters.add("%" + sido + "%");
                    }
                    if (gungu != null && !gungu.isEmpty()) {
                        sql += " AND b.excPlace LIKE ?";
                        parameters.add("%" + gungu + "%");
                    }

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                        pstmt = conn.prepareStatement(sql);

                        for (int i = 0; i < parameters.size(); i++) {
                            pstmt.setObject(i + 1, parameters.get(i));
                        }

                        rs = pstmt.executeQuery();

                        if (!rs.isBeforeFirst()) { // 데이터가 없을 때
                %>
                            <script>
                                showAlertAndRedirect("검색 결과가 없습니다.", "booksearch.jsp");
                            </script>
                <%
                        }

                        while (rs.next()) {
                            int bookId = rs.getInt("idBook");
                            Blob imageBlob = rs.getBlob("image1");
                            String bookTitle = rs.getString("title");
                            String bookAuthor = rs.getString("author");
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

                        <a href="<%= (user != null) ? "../bookdetail/bookdetail.jsp?idBook=" + bookId : "#" %>" class="book-card" 
                            <% if (user == null) { %> 
                                onclick="showLoginAlert(event);" 
                            <% } %>>
                            
                            <img src="data:image/jpeg;base64,<%= base64Image != null ? base64Image : "" %>" alt="Book Image">
                            <div class="book-info">
                                <h3><%= bookTitle %></h3>
                                <p><%= bookAuthor %></p>
                                <p><%= excPlace %></p>
                            </div>
                        </a>
                        
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

    <script>
        function showAlertAndRedirect(message, redirectUrl) {
            alert(message);
            window.location.href = redirectUrl;
        }

        function showLoginAlert(event) {
            event.preventDefault();
            alert("로그인 후 이용 가능합니다.");
            window.location.href = "../User/login.jsp";
        }
    </script>
</body>
</html>
