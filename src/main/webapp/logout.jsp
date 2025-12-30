<%-- 
    Document   : logout
    Created on : 31 Dec 2025, 2:05:43 am
    Author     : Owner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Destroy the session (Logs the user out on the server)
    if (session != null) {
        session.invalidate();
    }

    // 2. Redirect back to the Login Page
    response.sendRedirect("login.jsp");
%>