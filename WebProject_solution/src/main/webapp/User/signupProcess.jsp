<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="dao.model.userDAO" %>
<%@ page import="dao.bean.Userbean" %>

<html>
<body>
	<% request.setCharacterEncoding("UTF-8"); %>
 	<%
 		String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
 		String emailId = request.getParameter("id");
    	
	 	Userbean userBean = new Userbean();
	    userBean.setPw(request.getParameter("password"));
	    userBean.setName(request.getParameter("name"));
	    userBean.setBirth(request.getParameter("birth"));
	    userBean.setAddressCity(request.getParameter("city"));
	    userBean.setAddressGu(request.getParameter("district"));
	    userBean.setEmailId(request.getParameter("id"));
	    
	    userDAO dao = userDAO.getInstance();
	    if(!dao.isIdExist(emailId, propertiesPath)) {
	    	dao.signup(userBean, propertiesPath); 
	    %>
	    	<h2>회원가입이 완료되었습니다.</h2> <br>
 			<a href="login.jsp" >로그인 페이지로 이동하기</a>
 			<a href="main.jsp" >메인 화면으로 이동하기</a>
	    	<%
	    } else { %>
	    <script type="text/javascript">
			alert("이미 존재하는 아이디입니다.");
			history.back();
    	</script>   	
	    <%}

 	%>
</body>
</html>