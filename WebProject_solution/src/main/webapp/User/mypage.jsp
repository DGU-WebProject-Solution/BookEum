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
	<title>My Page</title>
	<link rel="stylesheet" type="text/css" href="mypage.css">
</head>
<body>
	<%
		session = request.getSession(false);
		Userbean user = (Userbean) session.getAttribute("user");
		List<Map<String, String>> books = new ArrayList<>();
		List<Map<String, String>> gets = new ArrayList<>();

		// 평균 평점 가져오기
		double avgRate = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null, rs2 = null, rs3 = null;

		// DB 연결을 위한 properties 파일 경로
		String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
		Properties props = new Properties();

		// db.properties 파일 로드
		try (FileInputStream fis = new FileInputStream(propertiesPath)) {
			props.load(fis);
		} catch (IOException e) {
			out.println("<p>DB 설정 파일 읽기 중 오류가 발생했습니다.</p>");
		}

		// db.properties 파일에서 DB 연결 정보 읽기
		String dbURL = props.getProperty("jdbc.url");
		String dbUser = props.getProperty("jdbc.username");
		String dbPass = props.getProperty("jdbc.password");

		try {
			// DB 연결
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			// 사용자별 평균 평점 가져오기 SQL 쿼리
			//String sql = "SELECT AVG(rate) AS avgRate FROM BookRating WHERE Id = ?";
			String sql = "SELECT avgRate FROM User WHERE id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user.getId()); // user.getUserId()로 현재 로그인한 사용자의 ID를 전달
			rs = pstmt.executeQuery();

			if (rs.next()) {
				avgRate = rs.getDouble("avgRate");
			}
			
			// 사용자가 등록한 책 가져오기 
			String bookQuery = "SELECT idBook, title, image1 FROM Book WHERE id = ?";
			pstmt = conn.prepareStatement(bookQuery);
			pstmt.setInt(1, user.getId());  // 로그인한 사용자 ID
			rs2 = pstmt.executeQuery();

			while (rs2.next()) {
	            Map<String, String> book = new HashMap<>();
	            book.put("idBook", String.valueOf(rs2.getInt("idBook")));
	            book.put("title", rs2.getString("title"));
	            byte[] imageBytes = rs2.getBytes("image1");
	            if (imageBytes != null) {
	            	String base64Image = Base64.getEncoder().encodeToString(imageBytes);
		            book.put("imagePath", base64Image);
	            }
	            books.add(book);
	        }
			
			// 사용자가 받은 책 가져오기 
			String getBookQuery = "SELECT e.idBook as idBook, b.title as title, b.image1 as image FROM ExchangedBook e JOIN Book b ON e.idBook = b.idBook WHERE e.getUser = ?";
			pstmt = conn.prepareStatement(getBookQuery);
			pstmt.setInt(1, user.getId());  // 로그인한 사용자 ID
			rs3 = pstmt.executeQuery();

			while (rs3.next()) {
	            Map<String, String> get = new HashMap<>();
	            get.put("idBook", String.valueOf(rs3.getInt("idBook")));
	            get.put("title", rs3.getString("title"));
	            byte[] imageBytes = rs3.getBytes("image");
	            if (imageBytes != null) {
	            	String base64Image = Base64.getEncoder().encodeToString(imageBytes);
		            get.put("imagePath", base64Image);
	            }
	            gets.add(get);
	        }

			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (rs2 != null) rs2.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		
		
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
        <!-- Main Content -->
        <div class="main-content">
            <div class="profile-section">
                <h1 class="title-special">My Page</h1>
                <div class="profile-img">
                    <img src="../images/profile0.4.png">
                </div>
                <div class="profile-name">${user.name} 님</div>
                <div class="rating-star">
                    <span>
                        <%
                            int starRateInt = (int) avgRate; // 평균 평점을 정수로 변환
                            for (int i = 0; i < 5; i++) {
                                if (i < starRateInt) {
                                    out.print("⭐");
                                } else {
                                    out.print("☆");
                                }
                            }
                        %>
                    </span>
                </div>
                <div class="rating-font">
                    <span>평균 평점: <%= avgRate %></span>
                </div>
             <a href="myInfo.jsp">
    <button type="button" class="info-btn">
        <img src="../images/info.png" alt="Info" class="icon"/> 내 정보
    </button>
</a>
<a href="logout.jsp">
    <button class="logout-btn">
        <img src="../images/logoutSmall.png" class="icon"/> 로그아웃
    </button>
</a>
<a href="unregister.jsp">
    <button class="unregister-btn">
        <img src="../images/logoutSmall.png" class="icon"/> 회원 탈퇴
    </button>
</a>
            </div>
        </div> <!-- main-content 닫기 -->
    </div> <!-- main-wrapper 닫기 -->

    <div class="sidebar-right">
        <div class="record-wrapper">
            <div class="tabs">
                <div class="tab active" id="register">내가 등록한 책</div>
                <div class="tab" id="get">내가 받은 책</div>
            </div>
            <div class="book-box" id = "register-list">
                <div class="book-list">
                    <% if (books != null && !books.isEmpty()) { %>
                    <% 
                    for (Map<String, String> book : books) {
                        String bookId = book.get("idBook");
                        String title = book.get("title");
                        String image = book.get("imagePath");
                    %>
                    <div class="book-item">
                        <a href="../bookdetail/bookdetail.jsp?idBook=<%= bookId %>">
                            <img src="data:image/jpeg;base64,<%= image %>" alt="<%= title %>">
                            <p class="book-name"><%= title %></p>
                        </a>
                    </div>
                    <% 
                    }
                    %>
                <% } else { %>
                    <p class = "empty-text">등록한 책이 없습니다.</p>
                <% } %>

                </div>
            </div>
            <div class="book-box" id = "get-list">
                <div class="book-list">
                 
                <% if (gets != null && !gets.isEmpty()) { %>
                    <% 
                    for (Map<String, String> get : gets) {
                        String bookId = get.get("idBook");
                        String title = get.get("title");
                        String image = get.get("imagePath");
                    %>
                    <div class="book-item">
                        <a href="../bookdetail/bookdetail.jsp?idBook=<%= bookId %>">
                            <img src="data:image/jpeg;base64,<%= image %>" alt="<%= title %>">
                            <p class="book-name"><%= title %></p>
                        </a>
                    </div>
                    <% 
                    }
                    %>
                <% } else { %>
                    <p class = "empty-text">받은 책이 없습니다.</p>
                <% } %>

                </div>
            </div>
        </div>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        const tab1 = document.getElementById('register');
        const tab2 = document.getElementById('get');
        const bookList1 = document.getElementById('register-list');
        const bookList2 = document.getElementById('get-list');
        bookList2.style.display = 'none';

        // 내가 등록한 책 탭 클릭 시
        tab1.addEventListener('click', function () {
            // 탭 활성화
            tab1.classList.add('active');
            tab2.classList.remove('active');
            
            // 책 목록 표시
            bookList1.style.display = 'block';
            bookList2.style.display = 'none';
        });

        // 내가 받은 책 탭 클릭 시
        tab2.addEventListener('click', function () {
            // 탭 활성화
            tab2.classList.add('active');
            tab1.classList.remove('active');
            
            // 책 목록 표시
            bookList2.style.display = 'block';
            bookList1.style.display = 'none';
        });
    });

    </script>
</body>
</html>