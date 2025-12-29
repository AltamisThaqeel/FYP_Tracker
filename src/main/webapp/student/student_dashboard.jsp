<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - FYP Tracker</title>
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
        .project-header-card {
            background: linear-gradient(135deg, #2563EB, #1D4ED8);
            color: white; border-radius: 15px; padding: 25px;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.2);
        }
        .progress-bar-custom { background-color: rgba(255,255,255,0.3); height: 8px; border-radius: 4px; margin-top: 15px; }
        .progress-fill { background-color: white; height: 100%; width: 66%; border-radius: 4px; transition: width 1s ease-in-out; }
        
        .stat-card { 
            background: white; border-radius: 12px; padding: 20px; border: none; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.02); height: 100%;
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-5px); }

        .timeline-placeholder { 
            border: 1px dashed #ccc; height: 200px; display: flex; align-items: center; justify-content: center; 
            background: #fff; border-radius: 12px; color: #aaa;
        }
        
        .milestone-list-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 15px; background: white; border-bottom: 1px solid #f8f9fa;
        }
        .milestone-list-item:last-child { border-bottom: none; }
    </style>

    <script>
        function submitReport() {
            // Simulate report submission
            if(confirm("Are you sure you want to submit the weekly progress report?")) {
                alert("Report submitted successfully to Supervisor: Dr. Sarah Johnson.");
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
        <a href="student_dashboard.jsp" class="nav-link active"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="create_project.jsp" class="nav-link"><i class="bi bi-folder-fill me-2"></i> My Project</a>
        <a href="milestones.jsp" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="feedback.jsp" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
        <a href="login.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">Dashboard</h3>
        <button class="btn btn-primary btn-sm rounded-pill px-4 py-2" onclick="submitReport()">
            <i class="bi bi-send me-2"></i> Submit Report
        </button>
    </div>

    <div class="project-header-card mb-4">
        <div class="d-flex justify-content-between">
            <div>
                <h4 class="fw-bold">AI-Powered Healthcare Diagnosis System</h4>
                <p class="mb-1 opacity-75"><i class="bi bi-person-badge me-2"></i> Supervisor: Dr. Sarah Johnson</p>
                <small class="opacity-75"><i class="bi bi-calendar-event me-2"></i> Started: Jan 2024 | Due: Dec 2024</small>
            </div>
            <span class="badge bg-light text-primary align-self-start px-3 py-2">In Progress</span>
        </div>
        <div class="mt-4">
            <div class="d-flex justify-content-between small mb-1 fw-bold">
                <span>Overall Progress</span>
                <span>66%</span>
            </div>
            <div class="progress-bar-custom"><div class="progress-fill"></div></div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <h3 class="fw-bold mb-0">8/12</h3>
                <small class="text-muted">Milestones Completed</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <h3 class="fw-bold mb-0 text-warning">4</h3>
                <small class="text-muted">Weeks Remaining</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <h3 class="fw-bold mb-0 text-success">3</h3>
                <small class="text-muted">Upcoming Tasks</small>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <h3 class="fw-bold mb-0 text-danger">1</h3>
                <small class="text-muted">New Feedback</small>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-7">
            <h5 class="mb-3 fw-bold">Progress Timeline</h5>
            <div class="timeline-placeholder">
                <div class="text-center">
                    <i class="bi bi-graph-up display-4"></i>
                    <p class="mt-2 small">Interactive Chart.js Graph will load here</p>
                </div>
            </div>
        </div>
        <div class="col-md-5">
            <h5 class="mb-3 fw-bold">Recent Milestones</h5>
            <div class="card border-0 shadow-sm overflow-hidden">
                <div class="milestone-list-item">
                    <span><i class="bi bi-check-circle-fill text-muted me-2"></i> ERD Diagram</span>
                    <span class="badge bg-success">Completed</span>
                </div>
                <div class="milestone-list-item">
                    <span><i class="bi bi-check-circle-fill text-muted me-2"></i> UI Mockups</span>
                    <span class="badge bg-success">Completed</span>
                </div>
                <div class="milestone-list-item">
                    <span><i class="bi bi-circle text-muted me-2"></i> System Implementation</span>
                    <span class="badge bg-light text-dark">Not Started</span>
                </div>
                <div class="milestone-list-item">
                    <span><i class="bi bi-circle text-muted me-2"></i> Testing Phase</span>
                    <span class="badge bg-light text-dark">Not Started</span>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>