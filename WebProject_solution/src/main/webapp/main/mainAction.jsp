<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%
    String title = request.getParameter("title");
    if (title == null || title.trim().isEmpty()) {
        response.sendRedirect("main.jsp");
        return;
    }

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

        String sql = "SELECT idBook FROM Book WHERE title = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int idBook = rs.getInt("idBook");
            response.sendRedirect("../bookdetail/bookdetail.jsp?idBook=" + idBook);
        } else {
            out.println("<script>alert('해당 제목의 책이 없습니다.'); location.href='main.jsp';</script>");
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
