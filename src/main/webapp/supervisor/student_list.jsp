<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %> <%@page import="java.util.List"%>
<%@page import="com.fyp.model.Project"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student List - FYP Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #F8F9FA; font-family: 'Segoe UI', sans-serif; }
        
        .sidebar { width: 250px; height: 100vh; position: fixed; background-color: #FFFFFF; border-right: 1px solid #eee; padding: 20px; }
        .sidebar-brand { font-weight: bold; font-size: 1.2rem; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .nav-link { color: #6C757D; padding: 10px 15px; margin-bottom: 5px; border-radius: 10px; font-weight: 500; text-decoration: none; }
        .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
        .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        
        .project-card { 
            background: white; border-radius: 10px; padding: 20px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.02); height: 100%; 
            transition: all 0.3s; cursor: pointer; border: 1px solid transparent;
        }
        .project-card:hover { transform: translateY(-5px); border-color: #2563EB; }
        
        .card-dates { font-size: 0.75rem; color: #adb5bd; float: right; }
        .card-type { font-size: 0.8rem; color: #6c757d; margin-bottom: 10px; display: block;}
        .student-name { font-weight: bold; font-size: 0.9rem; margin-top: 15px; text-transform: uppercase; }
        .student-id { font-size: 0.8rem; color: #6c757d; }
    </style>

    <script>
        function filterStudents() {
            const input = document.getElementById('searchInput').value.toUpperCase();
            const cards = document.getElementsByClassName('col'); // Get column wrappers
            
            for (let i = 0; i < cards.length; i++) {
                const nameDiv = cards[i].querySelector('.student-name');
                const name = nameDiv.textContent || nameDiv.innerText;
                
                if (name.toUpperCase().indexOf(input) > -1) {
                    cards[i].style.display = "";
                } else {
                    cards[i].style.display = "none";
                }
            }
        }

        function viewStudentDetails(name) {
            // In a real app, this would pass the ID in the URL
            if(confirm("View progress for " + name + "?")) {
                window.location.href = "supervisor_milestone.jsp";
            }
        }
    </script>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand text-primary">
        <i class="bi bi-mortarboard-fill"></i> FYP Tracker
    </div>
    <nav class="nav flex-column">
        <a href="supervisor_dashboard" class="nav-link">
            <i class="bi bi-grid-fill me-2"></i> Dashboard
        </a>
        <a href="StudentListServlet" class="nav-link active">
            <i class="bi bi-people-fill me-2"></i> Student
        </a>
        <a href="SupervisorMilestoneServlet" class="nav-link">
            <i class="bi bi-list-check me-2"></i> Track Milestone
        </a>
        <a href="../profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> Profile</a>
        <a href="../logout.jsp" class="nav-link mt-5 text-danger border-top pt-3">
            <i class="bi bi-box-arrow-right me-2"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="mb-0">Project List</h3>
            <p class="text-muted small mb-0 text-uppercase">Student information and project details</p>
        </div>
        <div class="input-group" style="width: 300px;">
            <input type="text" id="searchInput" class="form-control" placeholder="Search student name..." onkeyup="filterStudents()">
            <button class="btn btn-primary"><i class="bi bi-search"></i></button>
        </div>
    </div>

    <div class="row row-cols-1 row-cols-md-2 g-4">
        
        <%
            List<Project> list = (List<Project>) request.getAttribute("projectList");
            if(list != null) {
                for(Project p : list) {
        %>
        <div class="col">
            <div class="project-card" onclick="location.href='SupervisorMilestoneServlet?studentId=<%= p.getStudentId() %>'">
                <span class="card-dates"><%= p.getStartDate() %> - <%= p.getEndDate() %></span>
                
                <h6 class="fw-bold mb-1"><%= p.getTitle() %></h6>
                
                <span class="card-type">
                    <%= (p.getCategoryName() != null) ? p.getCategoryName() : "General" %> • Final Year Project
                </span>
                
                <p class="small text-muted mt-2 mb-3">
                    <%= (p.getDescription().length() > 100) ? p.getDescription().substring(0, 100) + "..." : p.getDescription() %>
                </p>
                <hr>
                <div class="student-name"><%= p.getStudentName() %></div>
                <div class="student-id"><%= p.getStudentId() %> | <%= p.getStudentPhone() %></div>
            </div>
        </div>
        <%      } 
            } else { 
        %>
            <p>No projects assigned yet.</p>
        <% } %>
        </div>
</div>

</body>
</html>