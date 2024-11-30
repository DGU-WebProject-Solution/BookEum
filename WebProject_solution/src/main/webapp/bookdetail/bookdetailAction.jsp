<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>

<%
    // 선택한 책 ID를 가져오기
    String bookId = request.getParameter("idBook");
    if (bookId == null || bookId.isEmpty()) {
        out.println("<p>잘못된 요청입니다. 책 ID가 제공되지 않았습니다.</p>");
        return;
    }

    // 데이터베이스 연결 정보 읽기
    String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
    Properties props = new Properties();

    try (FileInputStream fis = new FileInputStream(propertiesPath)) {
        props.load(fis);
    } catch (IOException e) {
        out.println("<p>DB 설정 파일 읽기 중 오류가 발생했습니다.</p>");
        e.printStackTrace();
        return;
    }

    String dbURL = props.getProperty("jdbc.url");
    String dbUser = props.getProperty("jdbc.username");
    String dbPass = props.getProperty("jdbc.password");

    // DB 연결 및 데이터 조회
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // 책 정보 조회
        String sql = "SELECT * FROM Book WHERE idBook = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(bookId));
        rs = pstmt.executeQuery();

        // 책 정보 출력
        if (rs.next()) {
            Blob image1 = rs.getBlob("image1");
            String title = rs.getString("title");
            String author = rs.getString("author");
            String excPlace = rs.getString("excPlace");
            String excType = rs.getString("excType");

            String base64Image1 = image1 != null ? Base64.getEncoder().encodeToString(image1.getBytes(1, (int) image1.length())) : "./images/booksample.png";
%>
            <div class="book-details">
                <div class="book-images">
                    <img src="data:image/jpeg;base64,<%= base64Image1 %>" alt="Book Image 1">
                </div>
                <div>
                <h4>책 제목</h4><br>
                <%= title %>

                <h4>책 저자</h4><br>
               <%= author %>

                <h4>교환 장소</h4><br>
                <%= excPlace %>

                <h4>선호하는 거래방식</h4><br>
                <%= excType %>
            </div></div>
<%
        } else {
%>
            <p>선택한 책의 정보를 찾을 수 없습니다.</p>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>오류 발생: " + e.getMessage() + "</p>");
    } finally {
        // 자원 해제
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
