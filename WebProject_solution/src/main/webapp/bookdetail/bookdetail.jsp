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

int yourBookId = Integer.parseInt(request.getParameter("idBook"));
int yourBookUserId = 0;
String yourBookUserName = "";
double avgRate = 0.0;
int intAvgRate = (int) Math.round(avgRate);

try {
   Class.forName("com.mysql.cj.jdbc.Driver");
   conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

   String sql = "SELECT id FROM Book WHERE idBook = ?";
   pstmt = conn.prepareStatement(sql);
   pstmt.setInt(1, yourBookId);
   rs = pstmt.executeQuery();

   if (rs.next()) {
      yourBookUserId = rs.getInt("id");
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

try {
   Class.forName("com.mysql.cj.jdbc.Driver");
   conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

   String sql = "select name, avgRate from User where id = ?";
   pstmt = conn.prepareStatement(sql);
   pstmt.setInt(1, yourBookUserId);
   rs = pstmt.executeQuery();
   if (rs.next()){
      yourBookUserName = rs.getString("name");
      avgRate = rs.getDouble("avgRate");
      intAvgRate = (int)Math.round(avgRate);
   }
} catch (Exception e) {
   e.printStackTrace();
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

    <!-- Main Wrapper to hold content and right sidebar -->
    <div class="main-wrapper">
        <!-- Main Content -->
        <div class="main-content">
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                    String sql = "SELECT * FROM Book WHERE idBook = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, yourBookId);
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

   <div class="sidebar-right">
      <div class="account">
         <% if (user != null) { %>
         <a href="../User/mypage.jsp"> <img src="../images/account.png"
            alt="Account Icon">
         </a> ${user.name} 님 환영합니다
         <% } else { %>
         <img src="../images/account.png" alt="Account Icon"> <a
            href="../User/login.jsp" class="login-button">로그인하기</a>
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

                    if (!rs.next()) {
                        // 등록된 책이 없을 때 메시지 표시
                        out.println("<option value='' disabled>등록된 책이 없습니다</option>");
                    } else {
                        // 등록된 책이 있을 경우 책 제목 표시
                        while (rs.next()) {
                            int idBook = rs.getInt("idBook");
                            String bookTitle = rs.getString("title");
            %>
               <option value="<%= idBook %>"><%= bookTitle %></option>
               <%
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
               %>
            </select>
         </div>

         
         <%
    boolean isBookRegistered = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String sql = "SELECT idBook FROM Book WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, user.getId());
        rs = pstmt.executeQuery();

        if (rs.next()) {
            isBookRegistered = true; // 책이 등록된 경우
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<% if (isBookRegistered) { %>
    <!-- 책이 등록되었을 때 "채팅하기" 버튼 표시 -->
          <div id="bookDetails">
            <p>책을 선택하면 상세 정보가 여기에 표시됩니다.</p>
         </div>

<% } else { %>
    <!-- 책이 등록되지 않았을 때 "등록하기" 버튼 표시 -->
         <div id="bookDetails">
            <p>책을 먼저 등록해주세요</p>
         </div>

<% } %>
         
         
         
         
         
      </div>
      
      <%
      int myBookId = 0;
      %>
      <script>
    document.getElementById("bookDropdown").addEventListener("change", function () {
        var selectedBookId = this.value;
        myBookId = selectedBookId;
        document.getElementById("myBookId").value = selectedBookId;

        // Ajax를 통해 선택된 책 ID를 서버로 전송
        fetch("bookdetailAction.jsp?idBook=" + selectedBookId)
            .then(response => response.text())
            .then(data => {
                // bookDetails 영역에 서버 응답 데이터 표시
                document.getElementById("bookDetails").innerHTML = data;
                myBookId = selectedBookId;
            })
            .catch(error => {
                console.error("Error fetching book details:", error);
            });
    });
</script>

         <!-- 버튼 변경 -->
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String sql = "SELECT idBook FROM Book WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, user.getId());
        rs = pstmt.executeQuery();

        if (rs.next()) {
            isBookRegistered = true; // 책이 등록된 경우
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<%
if (isBookRegistered) { 
	int roomId = 0;
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

		String sql = "SELECT roomId " + "FROM Chat " + "WHERE (myBookUserId = ? AND yourBookUserId = ?) "
		+ "   OR (myBookUserId = ? AND yourBookUserId = ?) and myBookId = ? and yourBookId = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, user.getId()); // 첫 번째 조건의 myBookUserId
		pstmt.setInt(2, yourBookUserId); // 첫 번째 조건의 yourBookUserId
		pstmt.setInt(3, yourBookUserId); // 두 번째 조건의 myBookUserId
		pstmt.setInt(4, user.getId()); // 두 번째 조건의 yourBookUserId
		pstmt.setInt(5, myBookId);
		pstmt.setInt(6, yourBookId);
		
		rs = pstmt.executeQuery();

		if (rs.next()) {
			roomId = rs.getInt("roomId");
		}
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<p>오류 발생: " + e.getMessage() + "</p>");
	}
	if (roomId == 0) {
		try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

	String sql = "SELECT count(*) FROM Chat";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();

	if (rs.next()) {
		roomId = rs.getInt(1);
		roomId++;
	} else {
		roomId = 1;
	}
		} catch (Exception e) {
	e.printStackTrace();
	out.println("<p>오류 발생: " + e.getMessage() + "</p>");
		}
	}
%>
    <!-- 책이 등록되었을 때 "채팅하기" 버튼 표시 -->
          <div class="book-button">
         <form action="../chat/chat.jsp" method="POST">
            <input type="hidden" name="yourBookUserId" value="<%=yourBookUserId%>">
            <input type="hidden" name="roomId" value="<%=roomId%>">
            <input type="hidden" name="myBookId" id="myBookId" value="<%=myBookId%>">
            <input type="hidden" name="yourBookId" value="<%=yourBookId %>">
            <input class = "chat-button" type="submit" value="채팅하기">
         </form>
      </div>

<% } else { %>
    <!-- 책이 등록되지 않았을 때 "등록하기" 버튼 표시 -->
          <div class="book-button">
       <form action="../bookregister/bookregister.jsp">
            <input class = "chat-button" type="submit" value="등록하기">
         </form>

      </div>

<% } %>

<!-- Popup Section -->
<div id="popup" class="popup-overlay">
    <div class="popup-content">
        <a href="#" class="close-button">&times;</a>
        <img src="../images/review.png" alt="User Image">
        <p><%= yourBookUserName %> 님</p>

        <div class="stars">
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
        </div>
        
        <p>평균 평점: <%= avgRate %></p> <!-- avgRate 값 표시 -->
    </div>
</div>

      </div>
   </div>
   <script>
    document.querySelector('.close-button').addEventListener('click', function (e) {
        e.preventDefault(); // 기본 동작 방지
        const popup = document.getElementById('popup');
        popup.style.display = 'none'; // 팝업 숨기기

        // 브라우저 히스토리에서 해시 제거
        if (history.pushState) {
            history.pushState("", document.title, window.location.pathname + window.location.search);
        } else {
            // pushState가 지원되지 않는 경우 해시 제거
            window.location.hash = "";
        }
    });
</script>
   
</body>
</html>
