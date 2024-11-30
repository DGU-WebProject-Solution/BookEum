<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*" import="java.sql.*" import="java.io.*"%>
<%@ page import="dao.model.userDAO"%>
<%@ page import="dao.bean.Userbean"%>

	<%
	request.setCharacterEncoding("UTF-8");
	int yourBookId = 0;
	//내가 교환하고 싶은 책의 아이디
	int yourBookUserId = 0;
	//내가 교환하고 싶은 책의 주인의 아이디
	String yourBookUserName = "";
	//내가 교환하고 싶은 책의 사용자 이름	
	int myBookId = 0;
	int allChatCnt = 0;
	int myChatCnt = 0;
	int myChatNum = 0;
	
	String referer = request.getHeader("Referer");
	if (referer.contains("bookdetail/bookdetail.jsp")) {
		yourBookId = Integer.parseInt(request.getParameter("yourBookId"));
		//내가 교환하고 싶은 책의 아이디
		yourBookUserId = Integer.parseInt(request.getParameter("yourBookUserId"));
		//내가 교환하고 싶은 책의 주인의 아이디
		yourBookUserName = request.getParameter("yourBookUserName");
		//내가 교환하고 싶은 책의 사용자 이름	
		myBookId = Integer.parseInt(request.getParameter("myBookId"));
		//내가 교환할 책의 아이디
	}
	Userbean user = (Userbean) session.getAttribute("user");
	int userId = user.getId();
	if (userId == yourBookUserId) {
		response.sendRedirect(referer);
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

		String sql = "SELECT count(*) FROM Chat";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			allChatCnt = rs.getInt(1);
		}
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<p>오류 발생: " + e.getMessage() + "</p>");
	}

	if (allChatCnt == 0) {
		allChatCnt++;
		myChatNum = allChatCnt;
	} else {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			String sql = "SELECT count(*) FROM Chat where myBookUserId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				myChatCnt = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
			out.println("<p>오류 발생: " + e.getMessage() + "</p>");
		}
		if (myChatCnt == 0) {
			allChatCnt++;
			myChatNum = allChatCnt;
		} else {
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

				String sql = "SELECT roomId FROM Chat where myBookUserId = ?, yourBookUserId = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, yourBookUserId);
				rs = pstmt.executeQuery();

				if (rs.next()) {
					myChatCnt = rs.getInt("roomId");
				}
			} catch (Exception e) {
				e.printStackTrace();
				out.println("<p>오류 발생: " + e.getMessage() + "</p>");
			}
			if (myChatCnt == 0) {
				allChatCnt++;
				myChatNum = allChatCnt;
			}
		}
	}
	
	
	//채팅 전송 부분
	if(referer.contains("chat.jsp") && "POST".equalsIgnoreCase(request.getMethod())) {

		// 파라미터 가져오기
        String chatContent = request.getParameter("chatContent");
        String roomIdParam = request.getParameter("roomId");
        String myBookParam = request.getParameter("myBookId");
        String yourBookParam = request.getParameter("yourBookId");

		yourBookUserId = Integer.parseInt(request.getParameter("yourBookUserId"));
		//내가 교환하고 싶은 책의 주인의 아이디
		yourBookUserName = request.getParameter("yourBookUserName");
		//내가 교환하고 싶은 책의 사용자 이름	

		// Null 및 빈 값 확인
        if (chatContent != null && !chatContent.trim().isEmpty() &&
            roomIdParam != null && myBookParam != null && yourBookParam != null) {

            myChatNum = Integer.parseInt(roomIdParam);
            myBookId = Integer.parseInt(myBookParam);
            yourBookId = Integer.parseInt(yourBookParam);

            try {
                // DB 연결
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                // SQL 쿼리
                String sql = "INSERT INTO Chat (roomId, myBook, yourBook, chatContent, chatTime, createdAt) " +
                             "VALUES (?, ?, ?, ?, NOW(), NOW())";
                pstmt = conn.prepareStatement(sql);

                // 파라미터 바인딩
                pstmt.setInt(1, myChatNum);
                pstmt.setInt(2, myBookId);
                pstmt.setInt(3, yourBookId);
                pstmt.setString(4, chatContent);

                // 데이터베이스에 저장
                int rowsInserted = pstmt.executeUpdate();
                if (rowsInserted > 0) {
                    out.println("<p>메시지가 성공적으로 전송되었습니다.</p>");
                } else {
                    out.println("<p>메시지 전송에 실패했습니다.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
            } finally {
                // 리소스 정리
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } else {
            out.println("<p>유효한 데이터가 입력되지 않았습니다.</p>");
        }
	
	
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Book Exchange</title>
<link rel="stylesheet" type="text/css" href="./chat.css">
<script type="text/javascript">
		function toggleSidebar() {
    		const sidebar = document.querySelector('.sidebar-right');
    		sidebar.classList.toggle('show');
		}
		// 사이드바 외부 클릭 감지
		document.addEventListener('click', function(event) {
		    const sidebar = document.querySelector('.sidebar-right');
		    const sidebarButton = document.querySelector('.chat-btn'); // 사이드바 열기 버튼
		    if (sidebar.classList.contains('show') && !sidebar.contains(event.target) && event.target !== sidebarButton) {
		        sidebar.classList.remove('show'); // 사이드바 닫기
		    }
		});
		function openModal() {
	        document.getElementById("modalOverlay").style.display = "flex";
	    }

	    // 모달 닫기 함수
	    function closeModal() {
	        document.getElementById("modalOverlay").style.display = "none";
	    }

	    // 외부 클릭으로 모달 닫기
	    document.getElementById("modalOverlay").addEventListener("click", function(event) {
	    	const modal = document.querySelector('.reservation-modal');
	    	if (event.target === this || !modal.contains(event.target)) {
	            closeModal();
	        }
	    });
	    // 후기 모달 열기 함수
	    function openReviewModal() {
	        document.getElementById("reviewModalOverlay").style.display = "flex";
	    }

	    // 후기 모달 닫기 함수
	    function closeReviewModal() {
	        document.getElementById("reviewModalOverlay").style.display = "none";
	    }

	    // 별점 설정 함수
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

	    // 후기 제출 함수
	    function submitReview() {
	        // 리뷰 제출 로직 추가 가능
	        closeReviewModal();
	        alert("후기가 제출되었습니다.");
	    }

	    function submitReservation() {
	        // 리뷰 제출 로직 추가 가능
	        closeModal();
	        alert("교환 일정이 예약되었습니다.");
	    }

	    // 외부 클릭으로 모달 닫기
	    document.getElementById("reviewModalOverlay").addEventListener("click", function(event) {
	        const modal = document.querySelector('.review-modal');
	        if (event.target === this || !modal.contains(event.target)) {
	            closeReviewModal();
	        }
	    });
	    
	    document.addEventListener("DOMContentLoaded", function () {
	        const chatListItems = document.querySelectorAll(".chat-message");
	        chatListItems.forEach((item, index) => {
	            item.addEventListener("click", () => loadChatRoom(index));
	        });
	    });

	    function loadChatRoom(roomId) {
	        const chatRooms = [
	            {
	                title: "네 그때 뵙겠습니다.",
	                userName: "이수민",
	                messages: [
	                    { text: "안녕하세요! 교환을 진행하고 싶습니다.", time: "3시간 전", user: false },
	                    { text: "네, 그때 뵙겠습니다.", time: "3시간 전", user: true }
	                ]
	            },
	            {
	                title: "확인했습니다.",
	                userName: "김해솔",
	                messages: [
	                    {
	                    	text: "책 상태는 어떤가요?",
	                    	time: "2시간 전",
	                    	user: false,
	                    },
	                    {
	                    		text: "상태는 양호합니다!",
	                    		time: "2시간 전",
	                    		user: true,
	                    },
	                ]
	            }
	        ];

	        const selectedRoom = chatRooms[roomId];
	        if (!selectedRoom) {
	            console.error("Invalid roomId or no messages found"); // 오류 메시지 출력
	            return;
	        }
	        const mainContent = document.querySelector('.main-content');

	        selectedRoom.messages.forEach((message, index) => {
	            const alignmentClass = message.user ? "message-right" : "message-left";
	            chatHTML += `
		        <div class="chat-messages">
	                <div class="message-${alignmentClass}">
	                    <div class="bubble">
	                        <span class="message-text">${message.text}</span>
	                        <div class="message-time">${message.time}</div>
	                    </div>
	                </div>
	            `;
	        });
	        
	        mainContent.innerHTML = chatHTML;
	    }
	    
	    function validateForm() {
	        const chatContent = document.getElementById("chatContent").value.trim();
	        if (!chatContent) {
	            alert("메시지를 입력해주세요.");
	            return false;
	        }
	        return true;
	    }
	</script>
</head>
<body>
	<!-- Sidebar -->
	<div class="sidebar">
		<img src="../images/logo.png" alt="Logo" class="logo"><span>책이음</span>

		<ul>
			<li><img src="../images/sidebar1.png" alt="Search Icon"><span>책찾기</span></li>
			<li><img src="../images/sidebar2.png" alt="List Icon"><span>책등록</span></li>
			<li><img src="../images/sidebar3.png" alt="Chat Icon"><span>채팅하기</span></li>
		</ul>
	</div>

	<!-- Main Wrapper to hold content and right sidebar -->
	<div class="main-wrapper">
		<!-- Main Content -->
		<div class="main-content">
			<div class="chat-header">
				<span class="chat-title"><%=yourBookUserName%></span>
				<div class="chat-buttons">
					<button class="chat-btn open-sidebar" onclick="toggleSidebar()">채팅
						목록 보기</button>
					<button class="chat-btn" onclick="openModal()">예약하기</button>
					<button class="chat-btn" onclick="openReviewModal()">교환 완료</button>
				</div>
			</div>
			<div class="chat-input">
				<form action="chat.jsp" method="POST" onSubmit="return validateForm()">
					<input type="text" name="chatContent" id="chatMessage" placeholder="전송할 메시지를 입력하세요."
						class="input-box" required>
					<input type="hidden" name="yourBookId" value="<%=yourBookId%>">
					<input type="hidden" name="yourBookUserId" value="<%=yourBookUserId%>">
					<input type="hidden" name="yourBookUserName" value="<%=yourBookUserName%>">
					<input type="hidden" name="myChatNum" value="<%=myChatNum%>">
					<input type="hidden" id="myBookId" name="myBookId" value="">
					<button class="send-btn">전송</button>
				</form>
			</div>
		</div>

		<!-- 예약하기 -->
		<div class="modal-overlay" id="modalOverlay">
			<div class="reservation-modal">
				<h2><%= yourBookUserName %>
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
					교환을 완료하시겠습니까?<br><%= yourBookUserName %>
					님에 대한 후기를 남겨주세요.
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

	<!-- Right Sidebar -->
	<div class="sidebar-right">

		<!-- 로고와 CHAT 문구 들어가야 함 -->
		<div class="sidebar-right-header">
			<div class="header-logo">
				<img src="../images/logo.png" alt="Logo"> CHAT
			</div>
			<div class="account">
				<img src="../images/account.png" alt="Account Icon"
					class="mypage-icon"> ${user.name}
			</div>
		</div>

		<!-- Chat List Section -->
		<div class="chat-list">
			<%
                // Sample messages for chat list; replace with dynamic content as needed.
                String[] lastChats = {"네 그때 뵙겠습니다.", "확인했습니다.", "좋은 하루 되세요!", "감사합니다.", "교환 원합니다."};
                for (int i = 0; i < lastChats.length; i++) {
            %>
			<div class="chat-message" onclick="loadChatRoom(<%=i%>)">
				<div class="profile-image-container">
					<div class="profile-circle">프로필</div>
					<div class="book-rectangle">책 이미지</div>
				</div>
				<div class="message-details">
					<div class="message-time">${yourBookUserName}</div>
					<div class="message-text"><%= lastChats[i] %></div>
				</div>
			</div>
			<%
                }
            %>
		</div>
	</div>
</body>
</html>
