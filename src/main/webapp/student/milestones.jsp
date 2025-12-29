<%-- 
    Document   : milestones
    Created on : 26 Dec 2025, 1:48:32 am
    Author     : Owner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Milestone"%>
<%@page import="com.fyp.dao.MilestoneDAO"%>
<!DOCTYPE html>
<html>
<head>
    <title>Project Milestones</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; }
        .sidebar { width: 250px; background-color: #f4f4f4; height: 100vh; padding: 20px; }
        .main-content { flex: 1; padding: 40px; }
        .week-btn { display: block; width: 100%; padding: 10px; margin-bottom: 5px; background: white; border: 1px solid #ccc; cursor: pointer; text-align: left; }
        .week-btn:hover { background-color: #e3f2fd; }
        .task-list { margin-top: 20px; }
        .task-item { background: #fff; padding: 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; }
        .input-group { display: flex; gap: 10px; margin-bottom: 20px; }
        input[type="text"] { flex: 1; padding: 10px; }
        button.add-btn { padding: 10px 20px; background-color: #0066cc; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h3>Weeks</h3>
        <button class="week-btn">Week 1</button>
        <button class="week-btn">Week 2</button>
        <button class="week-btn">Week 3</button>
        <br>
        <a href="../StudentDashboardServlet">Back to Dashboard</a>
    </div>

    <div class="main-content">
        <h2>Project Milestones (Week 1)</h2>
        
        <form action="../MilestoneServlet" method="POST">
            <div class="input-group">
                <input type="text" name="taskDesc" placeholder="I will do..." required>
                <input type="hidden" name="scheduleId" value="1"> 
                <input type="hidden" name="action" value="add">
                <button type="submit" class="add-btn">Add Task</button>
            </div>
        </form>

        <div class="task-list">
    <h3>Milestones</h3>
    <%
        MilestoneDAO dao = new MilestoneDAO();
        List<Milestone> milestones = dao.getMilestonesBySchedule(1);

        for(Milestone m : milestones) {
    %>
    <div class="task-item">
        <span><%= m.getDescription() %></span>

        <div style="display:flex; align-items:center; gap:10px;">
            <span style="color: <%= m.getStatus().equals("Completed") ? "green" : "red" %>; font-weight:bold;">
                <%= m.getStatus() %>
            </span>

            <% if(m.getStatus().equalsIgnoreCase("Pending")) { %>
                <form action="../MilestoneServlet" method="POST" style="margin:0;">
                    <input type="hidden" name="action" value="complete">
                    <input type="hidden" name="milestoneId" value="<%= m.getMilestoneId() %>">
                    <button type="submit" style="background-color: green; color: white; border: none; padding: 5px 10px; cursor: pointer;">
                        ✓
                    </button>
                </form>
            <% } %>
            </div>
        </div>
        <% } %>
    </div>
    </div>

</body>
</html>