<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.fyp.model.Account"%>
<%
    // Security Check
    Account user = (Account) session.getAttribute("user");
    if (user == null) { response.sendRedirect("../login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Project - FYP Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #F8F9FA; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 250px; height: 100vh; position: fixed; background-color: #FFFFFF; border-right: 1px solid #eee; padding: 20px; }
        .nav-link { color: #6C757D; padding: 10px 15px; margin-bottom: 5px; border-radius: 10px; font-weight: 500; text-decoration: none; }
        .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
        .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        .form-control, .form-select { background-color: #f8f9fa; border: 1px solid #dee2e6; height: 45px; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand text-primary fw-bold fs-5 mb-4">
        <i class="bi bi-mortarboard-fill"></i> FYP Tracker
    </div>
    <nav class="nav flex-column">
        <a href="${pageContext.request.contextPath}/StudentDashboardServlet" class="nav-link"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="create_project.jsp" class="nav-link active"><i class="bi bi-folder-fill me-2"></i> My Project</a>
        <a href="milestones.jsp" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="../profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="feedback.jsp" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
        <a href="../LoginServlet" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">Project Application</h3>
    </div>

    <div class="card border-0 shadow-sm p-4">
        <h5 class="text-muted mb-4 border-bottom pb-3">Submit new project proposal</h5>
        
        <form action="${pageContext.request.contextPath}/CreateProjectServlet" method="POST">
            <div class="row g-3">
                <div class="col-md-12">
                    <label class="form-label small fw-bold text-secondary">Project Title</label>
                    <input type="text" name="title" class="form-control" placeholder="Enter title..." required>
                </div>

                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Category / Research Area</label>
                    <select name="category" class="form-select" required>
                        <option value="" disabled selected>Select a category</option>
                        <option value="Machine Learning">Machine Learning</option>
                        <option value="Internet of Things (IoT)">Internet of Things (IoT)</option>
                        <option value="Web Development">Web Development</option>
                        <option value="Cybersecurity">Cybersecurity</option>
                        <option value="Data Science">Data Science</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Project Type</label>
                    <select name="type" class="form-select" required>
                        <option value="Individual">Individual Project</option>
                        <option value="Group">Group Project</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-bold text-secondary">Start Date</label>
                    <input type="date" name="startDate" class="form-control" required>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-bold text-secondary">End Date</label>
                    <input type="date" name="endDate" class="form-control" required>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-bold text-secondary">Contact Phone</label>
                    <input type="text" name="phone" class="form-control" placeholder="+6012..." required>
                </div>

                <div class="col-12">
                    <label class="form-label small fw-bold text-secondary">Project Description</label>
                    <textarea name="desc" class="form-control" rows="3" placeholder="Describe the background of your project..." required></textarea>
                </div>

                <div class="col-12">
                    <label class="form-label small fw-bold text-secondary">Project Objectives</label>
                    <textarea name="objectives" class="form-control" rows="3" placeholder="List your key goals here..." required></textarea>
                </div>

                <div class="col-12 text-end mt-4">
                    <button type="reset" class="btn btn-light text-danger me-2">Clear Form</button>
                    <button type="submit" class="btn btn-primary px-5 rounded-pill">Submit Application</button>
                </div>
            </div>
        </form>
    </div>
</div>

</body>
</html>