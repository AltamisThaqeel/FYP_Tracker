<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - FYP Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #F8F9FA; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 250px; height: 100vh; position: fixed; background-color: #FFFFFF; border-right: 1px solid #eee; padding: 20px; }
        .nav-link { color: #6C757D; padding: 10px 15px; margin-bottom: 5px; border-radius: 10px; font-weight: 500; text-decoration: none; }
        .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
        .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        
        .project-header-card {
            background: linear-gradient(135deg, #2563EB, #1D4ED8);
            color: white; border-radius: 15px; padding: 25px;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.2);
        }
        .stat-card { background: white; border-radius: 12px; padding: 20px; border: none; box-shadow: 0 2px 5px rgba(0,0,0,0.02); height: 100%; }
        
        /* Empty State Styling */
        .empty-state { text-align: center; padding: 50px; background: white; border-radius: 15px; border: 2px dashed #ddd; color: #777; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand text-primary fw-bold fs-5 mb-4">
        <i class="bi bi-mortarboard-fill"></i> FYP Tracker
    </div>
    <nav class="nav flex-column">
        <a href="student_dashboard.jsp" class="nav-link active"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/CreateProjectServlet" class="nav-link"><i class="bi bi-folder-fill me-2"></i> My Project</a>
        <a href="milestones.jsp" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="../profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="feedback.jsp" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
        <a href="../LoginServlet" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <h3 class="fw-bold mb-4">Dashboard</h3>

    <% 
       // We use standard Java logic here if you don't have JSTL libraries installed
       Object projectObj = request.getAttribute("project");
       if (projectObj == null) { 
    %>
        <div class="empty-state">
            <i class="bi bi-folder-plus display-1 text-light-gray"></i>
            <h4 class="mt-3">No Active Project Found</h4>
            <p>You haven't registered a Final Year Project yet.</p>
            <a href="${pageContext.request.contextPath}/CreateProjectServlet" class="btn btn-primary mt-2">Create New Project</a>
        </div>

    <% } else { 
       // We assume the object is of type com.fyp.model.Project
       com.fyp.model.Project p = (com.fyp.model.Project) projectObj;
    %>

        <div class="project-header-card mb-4">
            <div class="d-flex justify-content-between">
                <div>
                    <h4 class="fw-bold"><%= p.getProjectName() %></h4>
                    
                    <p class="mb-1 opacity-75">
                        <i class="bi bi-person-badge me-2"></i> Supervisor: <%= p.getSupervisorName() %>
                    </p>
                    
                    <small class="opacity-75">
                        <i class="bi bi-calendar-event me-2"></i> 
                        Status: <%= p.getStatus() %>
                    </small>
                </div>
                <span class="badge bg-light text-primary align-self-start px-3 py-2"><%= p.getStatus() %></span>
            </div>
            
            <div class="mt-4">
                <div class="d-flex justify-content-between small mb-1 fw-bold">
                    <span>Overall Progress</span>
                    <span><%= p.getProgress() %>%</span>
                </div>
                <div class="progress" style="height: 8px;">
                    <div class="progress-bar bg-white" role="progressbar" 
                         style="width: <%= p.getProgress() %>%; opacity: 0.9;" 
                         aria-valuenow="<%= p.getProgress() %>" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <h3 class="fw-bold mb-0">--</h3>
                    <small class="text-muted">Milestones</small>
                </div>
            </div>
            </div>

    <% } %> </div>

</body>
</html>