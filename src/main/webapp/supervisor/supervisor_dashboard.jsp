<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <a href="supervisor_dashboard.jsp" class="nav-link active"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="student_list.jsp" class="nav-link"><i class="bi bi-people-fill me-2"></i> Student</a>
        <a href="supervisor_milestone.jsp" class="nav-link"><i class="bi bi-list-check me-2"></i> Track Milestone</a>
        <a href="profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> Profile</a>
        <a href="login.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <h3 class="mb-4">Dashboard</h3>
    
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card" onclick="location.href='supervisor_milestone.jsp'">
                <div class="d-flex justify-content-between">
                    <div>
                        <h3 class="fw-bold mb-0">120/450</h3>
                        <small class="text-muted">Total Milestones</small>
                    </div>
                    <div class="bg-light rounded p-2 text-primary"><i class="bi bi-list-task fs-4"></i></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" onclick="location.href='student_list.jsp'">
                <div class="d-flex justify-content-between">
                    <div>
                        <h3 class="fw-bold mb-0 text-warning">12</h3>
                        <small class="text-muted">Active Students</small>
                    </div>
                    <div class="bg-light rounded p-2 text-warning"><i class="bi bi-people fs-4"></i></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="d-flex justify-content-between">
                    <div>
                        <h3 class="fw-bold mb-0 text-success">14/22</h3>
                        <small class="text-muted">On Track</small>
                    </div>
                    <div class="bg-light rounded p-2 text-success"><i class="bi bi-check-circle fs-4"></i></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="d-flex justify-content-between">
                    <div>
                        <h3 class="fw-bold mb-0 text-danger">2</h3>
                        <small class="text-muted">Projects Delayed</small>
                    </div>
                    <div class="bg-light rounded p-2 text-danger"><i class="bi bi-flag fs-4"></i></div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-6">
            <div class="stat-card" style="cursor: default;">
                <h5 class="fw-bold mb-4">Student Progress</h5>
                
                <div class="student-row mb-2">
                    <div class="d-flex justify-content-between mb-1"><span class="fw-bold">Muhamad Aiman</span> <span class="small text-muted">60%</span></div>
                    <div class="progress"><div class="progress-bar" style="width: 60%"></div></div>
                </div>
                <div class="student-row mb-2">
                    <div class="d-flex justify-content-between mb-1"><span class="fw-bold">Siti Sarah</span> <span class="small text-muted">40%</span></div>
                    <div class="progress"><div class="progress-bar bg-warning" style="width: 40%"></div></div>
                </div>
                <div class="student-row mb-2">
                    <div class="d-flex justify-content-between mb-1"><span class="fw-bold">Ahmad Ali</span> <span class="small text-muted">75%</span></div>
                    <div class="progress"><div class="progress-bar bg-success" style="width: 75%"></div></div>
                </div>
                <div class="student-row mb-2">
                    <div class="d-flex justify-content-between mb-1"><span class="fw-bold">Nurul Izzah</span> <span class="small text-muted">90%</span></div>
                    <div class="progress"><div class="progress-bar bg-success" style="width: 90%"></div></div>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="stat-card" style="cursor: default;">
                <h5 class="fw-bold mb-4">Student Status</h5>
                
                <div class="d-flex justify-content-between align-items-center mb-3 p-2 border-bottom">
                    <span class="fw-bold">Muhamad Aiman</span> <span class="status-badge bg-progress">In Progress</span>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3 p-2 border-bottom">
                    <span class="fw-bold">Ahmad Ali</span> <span class="status-badge bg-progress">In Progress</span>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3 p-2 border-bottom">
                    <span class="fw-bold">Siti Sarah</span> <span class="status-badge bg-delay">Delay</span>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3 p-2 border-bottom">
                    <span class="fw-bold">John Doe</span> <span class="status-badge bg-delay">Delay</span>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3 p-2 border-bottom">
                    <span class="fw-bold">Nurul Izzah</span> <span class="status-badge bg-completed">Completed</span>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>