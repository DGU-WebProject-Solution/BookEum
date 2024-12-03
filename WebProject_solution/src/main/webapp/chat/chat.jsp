<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*" import="java.sql.*" import="java.io.*"
	import="java.time.*" import="java.time.format.DateTimeFormatter"%>
<%@ page import="dao.model.userDAO"%>
<%@ page import="dao.bean.Userbean"%>






<%
request.setCharacterEncoding("UTF-8");
Userbean user = (Userbean) session.getAttribute("user");
if (user == null) {
	out.println("<script type='text/javascript'>");
    out.println("alert('채팅을 이용하기 위해 먼저 로그인해 주세요.');");
    out.println("window.location.href = '../User/login.jsp';");
	out.println("</script>");
	return;
}

//사이드바의 채팅하기를 눌렀을 때
//roomId, yourId 없음 -> 채팅방 선택해야 됨
String myName = user.getName();
int myId = user.getId();
//넘길 파라미터 없음



//DB 연결 부분
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

//1. 책 찾기에서 채팅하기 버튼을 눌렀을 때
//2. 채팅 리스트에서 선택했을 때
//파라미터 불러올 때 null 처리하기
//yourId, roomId 넘김
int yourBookUserId = request.getParameter("yourBookUserId") != null ? Integer.parseInt(request.getParameter("yourBookUserId")) : 0;
int roomId = request.getParameter("roomId") != null ? Integer.parseInt(request.getParameter("roomId")) : 0;
String yourName = "";
boolean isSelectedRoom = false;

//내가 나와 채팅 불가능하게 예외 처리
if (myId == yourBookUserId) {
	out.println("<script type='text/javascript'>");
    out.println("alert('자기 자신과는 채팅할 수 없습니다..');");
    out.println("window.location.href = '../main/main.jsp';");
	out.println("</script>");
	return;
}


List<Map<String, String>> messages = new ArrayList<>();
//사용자 이름부터 가져오기 - bookdetail의 채팅하기 버튼으로 넘어왔을 때
if (yourBookUserId != 0) {
	isSelectedRoom = true;
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
		
		String sql = "select name from User where id = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, yourBookUserId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			yourName = rs.getString("name");
		}
	}catch (Exception e) {
		e.printStackTrace();
	} 
}
%>

<%

//채팅 보내기
String referer = request.getHeader("Referer");
String chatContent = "";
if (referer.contains("chat.jsp") && "POST".equalsIgnoreCase(request.getMethod())) {

	// 파라미터 가져오기
	chatContent = request.getParameter("chatContent");
	String roomIdParam = request.getParameter("roomId");
	yourBookUserId = Integer.parseInt(request.getParameter("yourBookUserId"));

	// Null 및 빈 값 확인
	if (chatContent != null && !chatContent.trim().isEmpty() && roomIdParam != null) {
		roomId = Integer.parseInt(roomIdParam);
		try {
	// DB 연결
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

	// SQL 쿼리
	String sql = "INSERT INTO Chat (roomId, chatContent, myBookUserId, yourBookUserId, createdAt) "
			+ "VALUES (?, ?, ?, ?, ?)";
	pstmt = conn.prepareStatement(sql);
	// 한국 시간으로 현재 시간 가져오기
	LocalDateTime nowInKorea = LocalDateTime.now(ZoneId.of("Asia/Seoul"));
	String formattedTime = nowInKorea.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

	// 파라미터 바인딩
	pstmt.setInt(1, roomId);
	pstmt.setString(2, chatContent);
	pstmt.setInt(3, myId);
	pstmt.setInt(4, yourBookUserId);
	pstmt.setString(5, formattedTime); // 한국 시간으로 설정된 createdAt 값

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
	}
}
//여기까지 채팅 전송

//채팅 가운데 부분 불러오기 -> roomId가 있을 경우 (선택되거나 애초에 그렇게 넘어왔을 때)








%>





















<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>책이음 채팅방</title>
<link rel="stylesheet" type="text/css" href="./chat.css">
<script src="./rightSidebar.js"></script>
<script type="text/javascript">

//사이드바
function toggleSidebar() {
	const sidebar = document.querySelector('.sidebar-right');
	sidebar.classList.toggle('show');
}
document.addEventListener('click', function(event) {
    const sidebar = document.querySelector('.sidebar-right');
    const sidebarButton = document.querySelector('.chat-btn'); // 사이드바 열기 버튼
    if (sidebar.classList.contains('show') && !sidebar.contains(event.target) && event.target !== sidebarButton) {
        sidebar.classList.remove('show'); // 사이드바 닫기
    }
});

//예약하기 모달
function openModal() {
    document.getElementById("modalOverlay").style.display = "flex";
}

function closeModal() {
    document.getElementById("modalOverlay").style.display = "none";
}

function submitReservation() {
    closeModal();
    alert("교환 일정이 예약되었습니다.");
}

//교환 완료 모달
function openReviewModal() {
    document.getElementById("reviewModalOverlay").style.display = "flex";
}

function closeReviewModal() {
    document.getElementById("reviewModalOverlay").style.display = "none";
}

function submitReview() {
    closeReviewModal();
    alert("후기가 제출되었습니다.");
}


//별점 설정 함수
function setRating(rating) {
    const stars = document.querySelectorAll('.star');
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('selected');
        } else {
            star.classList.remove('selected');
        }
    });
}
</script>
</head>
<body>
<jsp:include page="./sidebar.jsp" />
<script type="text/javascript">
let chatInserted = false; // 전역 변수로 설정

//메시지 전송 후 화면에 반영하는 함수
async function handleFormSubmit(event) {
    const chatContent = document.getElementById("chatMessage").value.trim();
    if (!chatContent) {
        alert("메시지를 입력해주세요.");
        return;
    }
    if (chatInserted) {
        alert("이미 메시지가 전송 중입니다. 잠시만 기다려주세요.");
        return;
    }
    chatInserted = true;

    try {
        // Form 데이터를 수집
        const formData = new FormData(event.target);

        // 서버로 POST 요청 전송
        const response = await fetch("chat.jsp", {
            method: "POST",
            body: formData,
        });

        if (response.ok) {
            const message = {
                chatContent: chatContent,
                createdAt: new Date().toLocaleString("ko-KR"), // 현재 시간
                myBookUserId: "<%= myId %>" // 현재 사용자 ID
            };

            // 입력 필드 초기화
            document.getElementById("chatMessage").value = "";
        } else {
        }
    } catch (error) {
        console.error("오류 발생:", error);
        alert("서버와 통신 중 오류가 발생했습니다.");
    } finally {
        chatInserted = false;
    }
}
</script>


	<div class="main-wrapper">
		<div class="main-content" id = "main-content">
			<div class="chat-header">
				<span class="chat-title"><%=yourName %></span>
				<div class="chat-buttons">
					<button class="chat-btn open-sidebar" onclick="toggleSidebar()">채팅
						목록 보기</button>
					<%
						if(isSelectedRoom) {
					%>
					<button class="chat-btn" onclick="openModal()">예약하기</button>
					<button class="chat-btn" onclick="openReviewModal()">교환 완료</button>
					<%
					}
					%>
				</div>
			</div>

<%
//채팅 가운데 화면도 가져와야 함
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
	
	String sql = "SELECT chatContent, createdAt, myBookUserId FROM Chat WHERE roomId = ? ORDER BY createdAt ASC";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, roomId);
	rs = pstmt.executeQuery();
	while (rs.next()) {
		Map<String, String> message = new HashMap<>();
		message.put("chatContent", rs.getString("chatContent"));
		message.put("createdAt", rs.getString("createdAt"));
		message.put("myBookUserId", rs.getString("myBookUserId"));
		messages.add(message);
	}
} catch(Exception e) {
	e.printStackTrace();
}
%>
			<div class="chat-messages">
				<%
				for (Map<String, String> message : messages) {
					String alignmentClass = message.get("myBookUserId").equals(String.valueOf(myId)) ? "right" : "left";
				%>
				<div class="message-<%=alignmentClass%>">
					<div class="bubble">
						<span class="message-text"><%=message.get("chatContent")%></span>
						<div class="message-time"><%=message.get("createdAt")%></div>
					</div>
				</div>
				<%
				}
				%>
			</div>
			<script type="text/javascript">
				const chatMessagesContainer = document.getElementById("main-content");
				chatMessagesContainer.scrollTop = chatMessagesContainer.scrollHeight;
			</script>

			<div class="chat-input">
				<form action="chat.jsp" method="POST" class="form-input" id="form-input">
					<input type="text" name="chatContent" id="chatMessage"
						placeholder="전송할 메시지를 입력하세요." class="input-box" required>
					<input type="hidden" name="yourBookUserId" value="<%=yourBookUserId%>">
					<input type="hidden" name="roomId" value="<%=roomId %>">
					<input type="submit" class="send-btn" value="전송">
				</form>
			</div>
		</div>
	</div>



	<!-- Right Sidebar -->
	<div class="sidebar-right">
		<div class="sidebar-right-header">
			<div class="header-logo">
				<img src="../images/logo.png" alt="Logo"> CHAT
			</div>
			<div class="account">
				<a href="../User/mypage.jsp"> <img src="../images/account.png"
					alt="Account Icon">
				</a>
				<%=myName %> 님 환영합니다
			</div>
		</div>
<%
//채팅 리스트 받아오기
List<Map<String, Object>> chatList = new ArrayList<>();

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

	String sql = "SELECT c.roomId, c.chatContent, c.createdAt, "
	+ "       c.yourBookUserId, yUser.name AS yourBookUserName, "
	+ "       c.myBookUserId, mUser.name AS myBookUserName " + "FROM Chat c "
	+ "LEFT JOIN User yUser ON c.yourBookUserId = yUser.id "
	+ "LEFT JOIN User mUser ON c.myBookUserId = mUser.id " + "JOIN ( "
	+ "    SELECT roomId, MAX(chatId) AS maxChatId " + "    FROM Chat "
	+ "    WHERE myBookUserId = ? OR yourBookUserId = ? " + "    GROUP BY roomId "
	+ ") sub ON c.roomId = sub.roomId AND c.chatId = sub.maxChatId " + "ORDER BY sub.maxChatId DESC";

	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, myId);
	pstmt.setInt(2, myId);
	rs = pstmt.executeQuery();

	while (rs.next()) {
		Map<String, Object> chatData = new HashMap<>();
		chatData.put("roomId", rs.getInt("roomId"));
		chatData.put("chatContent", rs.getString("chatContent"));
		chatData.put("createdAt", rs.getString("createdAt"));
		chatData.put("yourBookUserId", rs.getInt("yourBookUserId"));
		chatData.put("yourBookUserName", rs.getString("yourBookUserName"));
		chatData.put("myBookUserId", rs.getInt("myBookUserId"));
		chatData.put("myBookUserName", rs.getString("myBookUserName"));

		chatList.add(chatData);
	}
} catch (Exception e) {
	e.printStackTrace();
}

%>
		<div class="chat-list">
			<%
			for (Map<String, Object> chat : chatList) {
			%>
			<form action="chat.jsp" method="GET" class="chat-message">
			<%
				int returnId = myId; //내 아이디 말고 상대 아이디 넘겨줘야 함
				String yourHeaderName = myName;
				if ((Integer) chat.get("yourBookUserId") == myId) {
					returnId = (Integer) chat.get("myBookUserId"); 
				} else {
					returnId = (Integer) chat.get("yourBookUserId") ; 
				}
			%>
			<input type="hidden" name="yourBookUserId" value="<%=returnId %>">
			<input type="hidden" name="roomId" value="<%=chat.get("roomId") %>">
				<button type="submit" value="" class="chat-inner">
					<div class="profile-image-container">
						<%=chat.get("yourBookUserName")%>
						/<br>
						<%=chat.get("myBookUserName")%>
					</div>
					<div class="message-details">
						<div class="message-text"><%=chat.get("chatContent")%></div>
						<div class="message-time"><%=chat.get("createdAt")%></div>
					</div>
				</button>
			</form>
			<%
			}
			%>
		</div>
	</div>
	
	<!-- 예약하기 -->
		<div class="modal-overlay" id="modalOverlay">
			<div class="reservation-modal">
				<h2><%=yourName %>
					님과 예약
				</h2>
				<div class="modal-content">
					<div class="modal-row">
						<span>날짜</span>
						<div class="dropdown">
							<input type=date>
						</div>
					</div>
					<div class="modal-row">
						<span>시간</span>
						<div class="dropdown">
							<input type="time">
						</div>
					</div>
					<button class="complete-btn" onclick="submitReservation()">완료</button>
					<button class="complete-btn" onclick="closeModal()">취소</button>

				</div>
			</div>
		</div>
		<!-- 교환 완료 -->
		<div class="review-modal-overlay" id="reviewModalOverlay">
			<div class="review-modal">
				<h2>
					교환을 완료하시겠습니까?<br>
					<%=yourName %>님에 대한 후기를 남겨주세요.
				</h2>
				<div class="star-rating">
					<span class="star" onclick="setRating(1)">★</span> <span
						class="star" onclick="setRating(2)">★</span> <span class="star"
						onclick="setRating(3)">★</span> <span class="star"
						onclick="setRating(4)">★</span> <span class="star"
						onclick="setRating(5)">★</span>
				</div>
				<button class="complete-btn" onclick="submitReview()">후기
					보내기</button>
				<button class="complete-btn" onclick="closeReviewModal()">취소</button>
			</div>
		</div>
	</div>


	
</body>
</html>