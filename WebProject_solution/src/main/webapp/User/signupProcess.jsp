<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="dao.model.userDAO" %>
<%@ page import="dao.bean.Userbean" %>

<html>
<body>
    <% 
        request.setCharacterEncoding("UTF-8"); 
        String propertiesPath = application.getRealPath("./WEB-INF/db.properties");
        String emailId = request.getParameter("id");
        
        Userbean userBean = new Userbean();
        userBean.setPassword(request.getParameter("password"));
        userBean.setName(request.getParameter("name"));
        userBean.setBirth(request.getParameter("birth"));
        userBean.setAddressCity(request.getParameter("city"));
        userBean.setAddressGu(request.getParameter("district"));
        userBean.setEmailId(emailId);
        
        userDAO dao = userDAO.getInstance();
        
        if (!dao.isIdExist(emailId, propertiesPath)) {
            dao.signup(userBean, propertiesPath);
            
            // 회원가입 성공 알림창 표시
            out.println("<script type='text/javascript'>");
            out.println("alert('회원가입이 완료되었습니다. 로그인 후 메인 화면으로 이동합니다.');");
            out.println("</script>");
            
            // 회원가입 후 자동 로그인 처리
            Userbean loggedInUser = dao.logIn(new Userbean(), emailId, request.getParameter("password"), propertiesPath);
            if (loggedInUser != null) {
                session.setAttribute("user", loggedInUser); // 세션에 로그인 정보 저장
                out.println("<script type='text/javascript'>");
                out.println("location.href = '../main/main.jsp';"); // 메인 화면으로 이동
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('로그인 중 문제가 발생했습니다. 다시 시도해주세요.');");
                out.println("location.href = 'signup.jsp';"); // 회원가입 페이지로 이동
                out.println("</script>");
            }
        } else {
    %>
        <script type="text/javascript">
            alert("이미 존재하는 아이디입니다.");
            history.back();
        </script>
    <% 
        }
    %>
</body>
</html>
