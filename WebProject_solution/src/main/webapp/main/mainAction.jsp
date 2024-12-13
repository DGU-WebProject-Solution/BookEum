<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String title = request.getParameter("title");
    if (title == null || title.trim().isEmpty()) {
        response.sendRedirect("main.jsp");
        return;
    }

    // booksearch.jsp로 검색어 전달
    response.sendRedirect("../booksearch/booksearch.jsp?title=" + java.net.URLEncoder.encode(title, "UTF-8"));
%>
