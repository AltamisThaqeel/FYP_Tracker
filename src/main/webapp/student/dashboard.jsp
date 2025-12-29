<%-- 
    Document   : dashboard
    Created on : 26 Dec 2025, 12:59:34 am
    Author     : Owner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.fyp.model.Account"%>
<%@page import="com.fyp.model.Project"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; margin: 0; }
        .sidebar { width: 250px; background-color: white; height: 100vh; position: fixed; padding: 20px; border-right: 1px solid #ddd; }
        .content { margin-left: 270px; padding: 40px; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .header { display: flex; justify-content: space-between; align-items: center; }
        .status-badge { background-color: #e3f2fd; color: #1976d2; padding: 5px 10px; border-radius: 15px; font-size: 12px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>FYP Tracker</h2>
        <p>Menu</p>
        <a href="#">Dashboard</a><br><br>
        <a href="student/milestones.jsp">My Project / Milestones</a><br><br>
        <a href="../logout.jsp">Logout</a>
    </div>

    <div class="content">
        <% 
            Account user = (Account) session.getAttribute("user");
            Project project = (Project) request.getAttribute("project");
        %>

        <div class="header">
            <h1>Welcome, Student</h1>
        </div>

        <div class="card">
            <% if (project != null) { %>
                <div style="display:flex; justify-content:space-between;">
                    <h2><%= project.getTitle() %></h2>
                    <span class="status-badge"><%= project.getStatus() %></span>
                </div>
                <p><strong>Description:</strong> <%= project.getDescription() %></p>
                <p><strong>Start Date:</strong> <%= project.getStartDate() %> | <strong>End Date:</strong> <%= project.getEndDate() %></p>
            <% } else { %>
                <h2>No Project Found</h2>
                <p>You have not started a project yet.</p>
                <button onclick="location.href='create_project.jsp'">Create New Project</button>
            <% } %>
        </div>
    </div>

</body>
</html>