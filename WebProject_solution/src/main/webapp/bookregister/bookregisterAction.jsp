<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.model.userDAO" %>
<%@ page import="dao.bean.Userbean" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%
    request.setCharacterEncoding("UTF-8");

    session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        out.println("<p>로그인이 필요합니다.</p>");
        response.sendRedirect("../User/login.jsp");
        return;
    }

    Userbean user = (Userbean) session.getAttribute("user");
    String emailId = user.getEmailId();
    if (emailId == null || emailId.isEmpty()) {
        out.println("<p>유효하지 않은 사용자 정보입니다.</p>");
        response.sendRedirect("../User/login.jsp");
        return;
    }

    String saveFolder = application.getRealPath("uploadimgs");
    File folder = new File(saveFolder);
    if (!folder.exists()) folder.mkdirs();

    String title = null, author = null, genreId = null, stateInfo = null;
    String excCondition = null, excPlace = null, excType = null;
    String image1 = null, image2 = null, image3 = null;

    try {
        MultipartRequest multi = new MultipartRequest(request, saveFolder, 10 * 1024 * 1024, "UTF-8", new DefaultFileRenamePolicy());
        title = multi.getParameter("title");
        author = multi.getParameter("author");
        genreId = multi.getParameter("genreId");
        stateInfo = multi.getParameter("stateInfo");
        excCondition = multi.getParameter("excCondition");
        excPlace = multi.getParameter("excPlace");
        excType = multi.getParameter("excType");
        image1 = multi.getFilesystemName("image1");
        image2 = multi.getFilesystemName("image2");
        image3 = multi.getFilesystemName("image3");

        // 필수 항목 확인
        if (title == null || title.isEmpty() ||
            author == null || author.isEmpty() ||
            genreId == null || genreId.isEmpty() ||
            stateInfo == null || stateInfo.isEmpty() ||
            excCondition == null || excCondition.isEmpty() ||
            excPlace == null || excPlace.isEmpty() ||
            excType == null || excType.isEmpty() ||
            image1 == null || image1.isEmpty() ||
            image2 == null || image2.isEmpty() ||
            image3 == null || image3.isEmpty()) {
            out.println("<script>alert('모든 항목을 입력해주셔야 등록이 가능합니다.'); history.back();</script>");
            return;
        }
    } catch (IOException e) {
        e.printStackTrace();
        out.println("<p>파일 업로드 처리 중 오류가 발생했습니다.</p>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
    Properties props = new Properties();

    try (FileInputStream fis = new FileInputStream(propertiesPath)) {
        props.load(fis);
    } catch (IOException e) {
        e.printStackTrace();
        out.println("<p>DB 설정 파일 읽기 중 오류가 발생했습니다.</p>");
        return;
    }

    String dbURL = props.getProperty("jdbc.url");
    String dbUser = props.getProperty("jdbc.username");
    String dbPass = props.getProperty("jdbc.password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String userQuery = "SELECT id FROM User WHERE emailId = ?";
        pstmt = conn.prepareStatement(userQuery);
        pstmt.setString(1, emailId);
        ResultSet rs = pstmt.executeQuery();

        int userId = 0;
        if (rs.next()) {
            userId = rs.getInt("id");
        } else {
            out.println("<p>유효하지 않은 사용자입니다.</p>");
            return;
        }
        rs.close();
        pstmt.close();

        String sql = "INSERT INTO Book (id, title, author, genreId, stateInfo, excCondition, excPlace, excType, image1, image2, image3) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        pstmt.setString(2, title);
        pstmt.setString(3, author);
        pstmt.setInt(4, Integer.parseInt(genreId));
        pstmt.setString(5, stateInfo);
        pstmt.setString(6, excCondition);
        pstmt.setString(7, excPlace);
        pstmt.setString(8, excType);
        pstmt.setBlob(9, new FileInputStream(new File(saveFolder, image1)));
        pstmt.setBlob(10, new FileInputStream(new File(saveFolder, image2)));
        pstmt.setBlob(11, new FileInputStream(new File(saveFolder, image3)));

        int result = pstmt.executeUpdate();
        if (result > 0) {
            out.println("<script>alert('책 등록이 성공적으로 완료되었습니다.'); location.href='../booksearch/booksearch.jsp';</script>");
        } else {
            out.println("<script>alert('책 등록에 실패했습니다.'); location.href='../bookregister/bookregister.jsp';</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>오류 발생: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
