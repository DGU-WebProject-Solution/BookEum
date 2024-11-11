<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Exchange</title>
    <link rel="stylesheet" type="text/css" href="./chatList.css">
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
        	<button class="chat-btn open-sidebar" onclick="toggleSidebar()">채팅 목록 보기</button>
        	<div class="select-inform-text">채팅방을 선택하시오.</div>
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
        	    <img src="../images/account.png" alt="Account Icon" class="mypage-icon"> 솔루션
        	</div>     	
    	</div>
        
        <!-- Chat List Section -->
        <div class="chat-list">
            <%
                // Sample messages for chat list; replace with dynamic content as needed.
                String[] messages = {"네 그때 뵙겠습니다.", "확인했습니다.", "다음에 봬요.", 
                                     "알겠습니다.", "좋은 하루 되세요!", "감사합니다.", "교환 원합니다.", "답장 주세요.", "안녕하세요~!", "네~ 감사합니다!"};
                for (String message : messages) {
            %>
	            <div class="chat-message">
        	        <div class="profile-image-container">
            	        <div class="profile-circle">프로필</div>
                	    <div class="book-rectangle">책 이미지</div>
	                </div>
    	            <div class="message-details">
        	            <div class="message-time">3시간 전</div>
            	        <div class="message-text"><%= message %></div>
                	</div>
            	</div>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>
