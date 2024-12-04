<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Properties" %>
<%@ page import="dao.bean.Userbean" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
request.setCharacterEncoding("utf-8");
	int yourBookUserId = Integer.parseInt(request.getParameter("yourBookUserId"));
	int roomId = Integer.parseInt(request.getParameter("roomId"));
	int myBookId = Integer.parseInt(request.getParameter("myBookId"));
	int yourBookId = Integer.parseInt(request.getParameter("yourBookId"));
	Userbean user = (Userbean) session.getAttribute("user");
	int myId = user.getId();
	int newRate = Integer.parseInt(request.getParameter("rating"));

	PreparedStatement pstmt = null;
	Connection conn = null;
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
	
	
	//상대 책 교환 테이블에 넣기
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
		
		String sql = "INSERT INTO ExchangedBook (giveUser, getUser, idBook, roomId) "
		+ "VALUES (?, ?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		
		// 파라미터 바인딩
		pstmt.setInt(1, yourBookUserId);
		pstmt.setInt(2, myId);
		pstmt.setInt(3, yourBookId);
		pstmt.setInt(4, roomId);

		// 데이터베이스에 저장
		int rowsInserted = pstmt.executeUpdate();
		if (rowsInserted > 0) {
		} else {
	out.println("<p>메시지 전송에 실패했습니다.</p>");
		}
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
	}
	
	//내 책 교환 테이블에 넣기
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
		
		String sql = "INSERT INTO ExchangedBook (giveUser, getUser, idBook, roomId) "
		+ "VALUES (?, ?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		
		// 파라미터 바인딩
		pstmt.setInt(1, myId);
		pstmt.setInt(2, yourBookUserId);
		pstmt.setInt(3, myBookId);
		pstmt.setInt(4, roomId);

		// 데이터베이스에 저장
		int rowsInserted = pstmt.executeUpdate();
		if (rowsInserted > 0) {
		} else {
			out.println("<p>메시지 전송에 실패했습니다.</p>");
		}
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
	} 
	
	
	Double avgRate = 0.0;
	int peopleCnt = 0;
	
	//사용자 별점 받아오기
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
		
		String sql = "select peopleCnt, avgRate from User where id = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, yourBookUserId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			peopleCnt = rs.getInt("peopleCnt");
			avgRate = rs.getDouble("avgRate");
		}
	}catch (Exception e) {
		e.printStackTrace();
	} 
	
	peopleCnt++;
	avgRate = (avgRate * peopleCnt + newRate) / peopleCnt;
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

		String sql = "UPDATE User " + "SET avgRate = ?, " + "    newRate = ?, " + "    peopleCnt = ? "
		+ "WHERE id = ?"; 
		pstmt = conn.prepareStatement(sql);

		// 파라미터 바인딩
		pstmt.setDouble(1, avgRate);
		pstmt.setInt(2, newRate);
		pstmt.setInt(3, peopleCnt);
		pstmt.setInt(4, yourBookUserId);

		// 데이터베이스에 저장
		int rowsInserted = pstmt.executeUpdate();
		if (rowsInserted > 0) {
		} else {
	out.println("<p>메시지 전송에 실패했습니다.</p>");
		}
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
	} finally {
		// 리소스 정리
		try {
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
%>
</body>
	<form id="redirectForm" action="chat.jsp" method="POST">
		<input type="hidden" name="yourBookUserId" value="<%=yourBookUserId%>">
		<input type="hidden" name="roomId" value="<%=roomId%>">
		<input type="hidden" name="myBookId" value="<%=myBookId%>">
		<input type="hidden" name="yourBookId" value="<%=yourBookId%>">
	</form>
	<script> 
		document.getElementById("redirectForm").submit();
	</script>
</html>