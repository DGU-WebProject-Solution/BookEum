<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" import="java.util.*" import="java.io.*"%>
	<%@ page import="dao.model.userDAO" %>
	<%@ page import="dao.bean.Userbean" %>

<html>
<body>
<%
	
	String id = request.getParameter("id");
    String pw = request.getParameter("password");
    
    session = request.getSession(false);
    Userbean user = (Userbean) session.getAttribute("user");
    
	if (user != null) {
		response.sendRedirect("../main/main.jsp");
		return;
	}
	
	user = new Userbean();
    userDAO dao = userDAO.getInstance();
    String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
    user = dao.logIn(user, id, pw, propertiesPath);
    if(user != null) {
        session.setAttribute("user", user); // 세션에 유저 정보 전체 저장 
        response.sendRedirect("../main/main.jsp");
 
    } else {
    	%>
    	<script type="text/javascript">
			alert("아이디 또는 비밀번호가 일치하지 않습니다.");
			history.back();
		</script>
		<%
    }
    %>
    </body>
    </html>
