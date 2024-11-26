<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 변수 초기화
    String title = null;
    String author = null;
    String genre = null;
    String stateInfo = null; // 책 상태
    String excCondition = null; // 교환 조건
    String excPlace = null; // 교환 장소
    String excType = null; // 거래 방식
    String mainImage = null;
    String image1 = null;
    String image2 = null;
    int newIdBook = 0; // 새로 생성할 ID

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // db.properties 경로 설정
    String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
    Properties props = new Properties();

    try (FileInputStream fis = new FileInputStream(propertiesPath)) {
        props.load(fis);
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>DB 설정 파일 로드 실패</p>");
        return;
    }

    String dbURL = props.getProperty("jdbc.url");
    String dbUser = props.getProperty("jdbc.username");
    String dbPass = props.getProperty("jdbc.password");

    // 파일 저장 경로 설정
    String saveFolder = application.getRealPath("uploadimgs");
    File folder = new File(saveFolder);
    if (!folder.exists()) {
        folder.mkdirs();
    }

    try {
        // 파일 업로드 처리
        int maxSize = 20 * 1024 * 1024; // 최대 파일 크기 20MB로 설정
        MultipartRequest multi = new MultipartRequest(request, saveFolder, maxSize, "UTF-8", new DefaultFileRenamePolicy());

        // 폼 데이터 읽기
        title = multi.getParameter("title");
        author = multi.getParameter("author");
        genre = multi.getParameter("genre");
        stateInfo = multi.getParameter("stateInfo");
        excCondition = multi.getParameter("excCondition");
        excPlace = multi.getParameter("excPlace");
        excType = multi.getParameter("excType");

        // 업로드된 파일 이름 읽기
        mainImage = multi.getFilesystemName("image");
        image1 = multi.getFilesystemName("image1");
        image2 = multi.getFilesystemName("image2");

    } catch (IOException e) {
        out.println("<p>파일 업로드 중 오류가 발생했습니다.</p>");
        return;
    }

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // ID 계산: 테이블에서 현재 최대 `idBook` 값 조회
        String idQuery = "SELECT MAX(idBook) AS max_idBook FROM Book";
        pstmt = conn.prepareStatement(idQuery);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            newIdBook = rs.getInt("max_idBook") + 1; // 기존 최대값에 1을 더함
        } else {
            newIdBook = 0; // 테이블이 비어 있을 경우 ID를 0부터 시작
        }
        rs.close();
        pstmt.close();

        // 데이터 삽입
        String sql = "INSERT INTO Book (idBook, title, author, genre, stateInfo, excCondition, excPlace, excType, image, image1, image2) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, newIdBook); // 계산된 ID 값 설정
        pstmt.setString(2, title);
        pstmt.setString(3, author);
        pstmt.setString(4, genre);
        pstmt.setString(5, stateInfo);
        pstmt.setString(6, excCondition);
        pstmt.setString(7, excPlace);
        pstmt.setString(8, excType);
        pstmt.setString(9, mainImage);
        pstmt.setString(10, image1);
        pstmt.setString(11, image2);

        int result = pstmt.executeUpdate();
        if (result > 0) {
            out.println("<p>책 등록이 성공적으로 완료되었습니다.</p>");
            out.println("<a href='bookregister.jsp'>돌아가기</a>");
        } else {
            out.println("<p>책 등록에 실패했습니다.</p>");
            out.println("<a href='bookregister.jsp'>돌아가기</a>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>오류 발생: " + e.getMessage().replaceAll("'", "\\'") + "</p>");
        out.println("<a href='bookregister.jsp'>돌아가기</a>");
    } finally {
        // 리소스 정리
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
