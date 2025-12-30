<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Project"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Supervisor Dashboard - FYP Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #F8F9FA; font-family: 'Segoe UI', sans-serif; }
        
        /* Sidebar Styling */
        .sidebar { width: 250px; height: 100vh; position: fixed; background-color: #FFFFFF; border-right: 1px solid #eee; padding: 20px; }
        .sidebar-brand { font-weight: bold; font-size: 1.2rem; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .nav-link { color: #6C757D; padding: 10px 15px; margin-bottom: 5px; border-radius: 10px; font-weight: 500; text-decoration: none; }
        .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
        .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        
        /* Dashboard Specifics */
        .stat-card { 
            background: white; border-radius: 10px; padding: 20px; border: none; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.02); height: 100%; transition: transform 0.2s; cursor: pointer;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        
        /* Progress Bars */
        .progress { height: 10px; border-radius: 5px; background-color: #E9ECEF; }
        .progress-bar { background-color: #2563EB; border-radius: 5px; }
        
        /* Status Badges */
        .status-badge { padding: 8px 15px; border-radius: 20px; font-size: 0.8rem; width: 100px; display: inline-block; text-align: center; color: white; }
        .bg-progress { background-color: #2563EB; }
        .bg-delay { background-color: #DC3545; }
        .bg-completed { background-color: #00C851; }
        
        .student-row { padding: 10px; border-radius: 8px; transition: background 0.2s; }
        .student-row:hover { background-color: #f8f9fa; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand text-primary">
        <i class="bi bi-mortarboard-fill"></i> FYP Tracker
    </div>
    <nav class="nav flex-column">
    <a href="SupervisorDashboardServlet" class="nav-link active">
        <i class="bi bi-grid-fill me-2"></i> Dashboard
    </a>
    
    <a href="StudentListServlet" class="nav-link">
        <i class="bi bi-people-fill me-2"></i> Student
    </a>
    
    <a href="SupervisorMilestoneServlet" class="nav-link">
        <i class="bi bi-list-check me-2"></i> Track Milestone
    </a>
    
    <a href="profile.jsp" class="nav-link">
        <i class="bi bi-person-fill me-2"></i> Profile
    </a>
    
        <a href="logout.jsp" class="nav-link mt-5 text-danger border-top pt-3">
            <i class="bi bi-box-arrow-right me-2"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <h3 class="mb-4">Dashboard</h3>
    
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="d-flex justify-content-between">
                    <div>
                        <h3 class="fw-bold mb-0 text-warning">${totalStudents}</h3>
                        <small class="text-muted">Active Students</small>
                    </div>
                    <div class="bg-light rounded p-2 text-warning"><i class="bi bi-people fs-4"></i></div>
                </div>
            </div>
        </div>
        </div>

    <div class="row g-4">
        <div class="col-md-12">
            <div class="stat-card" style="cursor: default;">
                <h5 class="fw-bold mb-4">Student Status</h5>
                
                <%
                    List<Project> list = (List<Project>) request.getAttribute("projectList");
                    if(list != null) {
                        for(Project p : list) {
                            String badgeClass = "bg-progress"; // Default blue
                            if("Completed".equalsIgnoreCase(p.getStatus())) badgeClass = "bg-completed"; // Green
                            if("Pending".equalsIgnoreCase(p.getStatus())) badgeClass = "bg-delay"; // Red
                %>
                <div class="d-flex justify-content-between align-items-center mb-3 p-2 border-bottom">
                    <span class="fw-bold"><%= p.getStudentName() %></span> 
                    <span class="status-badge <%= badgeClass %>"><%= p.getStatus() %></span>
                </div>
                <%      }
                    }
                %>
            </div>
        </div>
    </div>
</div>

</body>
</html>