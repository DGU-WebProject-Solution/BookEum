<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" import="java.util.*" import="java.io.*"%>
	<%@ page import="dao.model.userDAO" %>
	<%@ page import="dao.bean.Userbean" %>

<html>
<body>
<%
	session = request.getSession(false);
	Userbean user = (Userbean) session.getAttribute("user");
	
	String id = user.getEmailId();
    String pw = user.getPw();

    userDAO dao = userDAO.getInstance();
    String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
    boolean isSuccess = dao.unRegister(id, pw, propertiesPath);

    if(isSuccess) { // 회원 탈퇴 성공하면 메인 페이지로 
    	if (session != null) {
            session.invalidate(); // 세션 정보 제거 
        }
        response.sendRedirect("../main.jsp");
    } else { 
    	%>
    	<script type="text/javascript">
			alert("회원 탈퇴에 실패하였습니다.");
			history.back();
		</script>
		<%
    }
    %>
    </body>
    </html>
