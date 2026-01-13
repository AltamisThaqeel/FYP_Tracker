<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - FYP Tracker</title>
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
        
        /* --- DASHBOARD CARDS --- */
        .welcome-banner {
            background: linear-gradient(135deg, #2563EB, #1D4ED8);
            color: white; border-radius: 20px; padding: 40px;
            box-shadow: 0 10px 20px rgba(37, 99, 235, 0.2);
            position: relative; overflow: hidden;
        }
        .welcome-banner::after {
            content: ""; position: absolute; right: -50px; bottom: -50px;
            width: 200px; height: 200px; background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        
        .stat-card {
            background: white; border-radius: 15px; padding: 25px;
            border: 1px solid #f1f3f5; box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            height: 100%; transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-3px); }
        
        .progress-container { background: rgba(255,255,255,0.2); border-radius: 10px; height: 10px; overflow: hidden; margin-top: 15px; }
        .progress-fill { background: #FFFFFF; height: 100%; border-radius: 10px; }
        
        .empty-state {
            text-align: center; padding: 60px; background: white; 
            border-radius: 20px; border: 2px dashed #e9ecef; color: #6c757d;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand text-primary">
        <i class="bi bi-mortarboard-fill"></i> FYP Tracker
    </div>
    <nav class="nav flex-column">
        <a href="${pageContext.request.contextPath}/StudentDashboardServlet" class="nav-link active"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/CreateProjectServlet" class="nav-link"><i class="bi bi-folder-fill me-2"></i> My Project</a>
        <a href="${pageContext.request.contextPath}/MilestoneServlet" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="${pageContext.request.contextPath}/StudentFeedbackServlet" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
        <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold m-0">Student Dashboard</h4>
        <span class="text-muted small">${pageContext.session.getAttribute("user").fullName}</span>
    </div>

    <c:choose>
        <c:when test="${empty project}">
            <div class="empty-state shadow-sm">
                <div class="mb-4">
                    <i class="bi bi-folder-plus display-1 text-primary opacity-25"></i>
                </div>
                <h3 class="fw-bold text-dark">No Project Found</h3>
                <p class="text-muted mb-4">You haven't registered your Final Year Project yet.<br>Start by creating a proposal to unlock all features.</p>
                <a href="${pageContext.request.contextPath}/CreateProjectServlet" class="btn btn-primary rounded-pill px-5 py-2 shadow-sm">
                    <i class="bi bi-plus-lg me-2"></i>Create New Project
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <div class="row g-4">
                
                <div class="col-12">
                    <div class="welcome-banner">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h2 class="fw-bold mb-3">${project.projectName}</h2>
                                
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="badge bg-white text-primary px-3 py-1 rounded-pill fw-bold">
                                        ${project.status}
                                    </span>
                                    <span class="badge bg-white bg-opacity-25 text-white px-3 py-1 rounded-pill">
                                        ${project.categoryName}
                                    </span>
                                </div>
                            </div>
                            
                            <div class="col-md-4 text-end">
                                <h1 class="display-4 fw-bold mb-0">${project.progress}%</h1>
                                <small class="opacity-75">Completion Rate</small>
                            </div>
                        </div>
                        
                        <div class="progress-container">
                            <div class="progress-fill" style="width: ${project.progress}%;"></div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card d-flex align-items-center gap-3">
                        <div class="bg-success bg-opacity-10 p-3 rounded-circle text-success">
                            <i class="bi bi-calendar-check fs-4"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold mb-0">${project.numOfWeeks} Weeks</h5>
                            <small class="text-muted">Total Duration</small>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="stat-card d-flex align-items-center gap-3">
                        <div class="bg-warning bg-opacity-10 p-3 rounded-circle text-warning">
                            <i class="bi bi-lightbulb fs-4"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold mb-0">${project.projectType}</h5>
                            <small class="text-muted">Project Type</small>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card d-flex align-items-center gap-3">
                        <div class="bg-info bg-opacity-10 p-3 rounded-circle text-info">
                            <i class="bi bi-chat-dots fs-4"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold mb-0">Feedback</h5>
                            <small class="text-muted">Check Comments</small>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="stat-card">
                        <h6 class="fw-bold text-muted mb-3">PROJECT DESCRIPTION</h6>
                        <p class="text-secondary small" style="line-height: 1.6;">
                            ${project.description}
                        </p>
                        <hr class="my-4 opacity-25">
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/CreateProjectServlet?projectId=${project.projectId}" class="btn btn-outline-primary rounded-pill px-4">
                                <i class="bi bi-pencil-square me-2"></i>Edit Details
                            </a>
                            <a href="${pageContext.request.contextPath}/MilestoneServlet" class="btn btn-primary rounded-pill px-4">
                                <i class="bi bi-list-check me-2"></i>Update Milestones
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="stat-card">
                        <h6 class="fw-bold text-muted mb-3">KEY DATES</h6>
                        <ul class="list-unstyled small text-secondary">
                            <li class="mb-3 d-flex justify-content-between">
                                <span>Start Date:</span>
                                <span class="fw-bold text-dark">${project.startDate}</span>
                            </li>
                            <li class="mb-3 d-flex justify-content-between">
                                <span>End Date:</span>
                                <span class="fw-bold text-dark">${project.endDate}</span>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>