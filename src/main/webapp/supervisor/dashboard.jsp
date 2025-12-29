<%-- 
    Document   : dashboard
    Created on : 26 Dec 2025, 12:59:41 am
    Author     : Owner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Project"%>
<%@page import="com.fyp.model.Account"%>
<!DOCTYPE html>
<html>
<head>
    <title>Supervisor Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; display: flex; }
        .sidebar { width: 250px; background-color: white; height: 100vh; padding: 20px; border-right: 1px solid #ddd; }
        .content { flex: 1; padding: 40px; }
        .project-card { background: white; padding: 20px; margin-bottom: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 5px solid #0066cc; }
        .card-header { display: flex; justify-content: space-between; align-items: center; }
        .student-id { color: #666; font-size: 0.9em; margin-top: 5px; }
        .btn-view { background-color: #0066cc; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; font-size: 14px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h3>FYP Tracker</h3>
        <p>Supervisor Panel</p>
        <a href="#">Dashboard</a><br><br>
        <a href="../logout.jsp">Logout</a>
    </div>

    <div class="content">
        <h1>Student Projects</h1>
        
        <%
            List<Project> list = (List<Project>) request.getAttribute("projectList");
            
            if (list != null && !list.isEmpty()) {
                for (Project p : list) {
        %>
            <div class="project-card">
                <div class="card-header">
                    <h3><%= p.getTitle() %></h3>
                    <a href="SupervisorProgressServlet?projectId=<%= p.getProjectId() %>" class="btn-view">View Progress</a>
                </div>
                <div class="student-id">
                    <strong>Student ID:</strong> <%= p.getStudentId() %>
                </div>
                <p>
                    <strong>Status:</strong> <%= p.getStatus() %> <br>
                    <strong>Duration:</strong> <%= p.getStartDate() %> to <%= p.getEndDate() %>
                </p>
            </div>
        <% 
                }
            } else {
        %>
            <p>No students assigned yet.</p>
        <% } %>
    </div>

</body>
</html>