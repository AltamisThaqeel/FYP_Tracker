<%-- 
    Document   : view_milestones
    Created on : 28 Dec 2025, 12:01:57 pm
    Author     : Owner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Milestone"%>
<!DOCTYPE html>
<html>
<head>
    <title>Review Milestones</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; display: flex; }
        .sidebar { width: 250px; background-color: white; height: 100vh; padding: 20px; border-right: 1px solid #ddd; }
        .content { flex: 1; padding: 40px; display: flex; gap: 20px; }
        
        /* Left Side: Milestones */
        .milestone-section { flex: 1; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .milestone-item { padding: 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; }
        
        /* Right Side: Feedback Form */
        .feedback-section { width: 350px; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); height: fit-content; }
        textarea { width: 100%; height: 150px; padding: 10px; margin-top: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-submit { background-color: #0066cc; color: white; width: 100%; padding: 10px; border: none; margin-top: 10px; cursor: pointer; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h3>FYP Tracker</h3>
        <p>Supervisor Panel</p>
        <a href="SupervisorDashboardServlet">Back to Dashboard</a>
    </div>

    <div class="content">
        
        <div class="milestone-section">
            <h2>Student Milestones (Week 1)</h2>
            <%
                List<Milestone> list = (List<Milestone>) request.getAttribute("milestoneList");
                if (list != null && !list.isEmpty()) {
                    for (Milestone m : list) {
            %>
                <div class="milestone-item">
                    <span><%= m.getDescription() %></span>
                    <span style="font-weight:bold; color: <%= m.getStatus().equals("Completed") ? "green" : "orange" %>;">
                        <%= m.getStatus() %>
                    </span>
                </div>
            <% 
                    }
                } else {
            %>
                <p>No milestones submitted for this week.</p>
            <% } %>
        </div>

        <div class="feedback-section">
            <h3>Write Feedback</h3>
            <p>Your thoughts are valuable in helping improve the project.</p>
            
            <form action="SupervisorFeedbackServlet" method="POST">
                <input type="hidden" name="projectId" value="<%= request.getAttribute("projectId") %>">
                <input type="hidden" name="week" value="1">
                
                <textarea name="feedbackContent" placeholder="Enter your feedback here..." required></textarea>
                <button type="submit" class="btn-submit">Submit Feedback</button>
            </form>
        </div>

    </div>

</body>
</html>
