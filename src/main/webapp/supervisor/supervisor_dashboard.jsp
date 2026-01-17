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
            body {
                background-color: #F8F9FA;
                font-family: 'Segoe UI', sans-serif;
            }
            .sidebar {
                width: 250px;
                height: 100vh;
                position: fixed;
                background-color: #FFFFFF;
                border-right: 1px solid #eee;
                padding: 20px;
            }
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }
            .stat-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                border: none;
                box-shadow: 0 2px 5px rgba(0,0,0,0.02);
                height: 100%;
                transition: transform 0.2s;
            }
            .stat-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }
            .progress {
                height: 8px;
                border-radius: 4px;
                background-color: #e9ecef;
            }
            .status-badge {
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
            }
            .bg-active {
                background-color: #e0f2fe;
                color: #0369a1;
            }
            .bg-completed {
                background-color: #dcfce7;
                color: #15803d;
            }
        </style>
    </head>
    <body>

        <div class="sidebar">
            <div class="sidebar-brand text-primary fw-bold mb-4 fs-5">
                <i class="bi bi-mortarboard-fill"></i> FYP Tracker
            </div>
            <nav class="nav flex-column gap-2">
                <a href="${pageContext.request.contextPath}/SupervisorDashboardServlet" class="nav-link active bg-primary text-white rounded"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/StudentListServlet" class="nav-link text-secondary"><i class="bi bi-people-fill me-2"></i> Student Project</a>
                <a href="${pageContext.request.contextPath}/SupervisorMilestoneServlet" class="nav-link text-secondary"><i class="bi bi-list-check me-2"></i> Track Milestone</a>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link text-secondary"><i class="bi bi-person-fill me-2"></i> Profile</a>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link text-danger border-top pt-3 mt-4"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
            </nav>
        </div>

        <div class="main-content">
            <h3 class="mb-4 fw-bold">Dashboard Overview</h3>

            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="text-muted text-uppercase small fw-bold">Active Students</h6>
                                <h2 class="mb-0 fw-bold text-dark">${totalStudents}</h2>
                            </div>
                            <div class="bg-primary bg-opacity-10 p-2 rounded text-primary">
                                <i class="bi bi-people-fill fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="text-muted text-uppercase small fw-bold">Completed Projects</h6>
                                <h2 class="mb-0 fw-bold text-success">${completedProjects}</h2>
                            </div>
                            <div class="bg-success bg-opacity-10 p-2 rounded text-success">
                                <i class="bi bi-trophy-fill fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="text-muted text-uppercase small fw-bold">Due This Week</h6>
                                <h2 class="mb-0 fw-bold text-warning">${weekMilestones}</h2>
                            </div>
                            <div class="bg-warning bg-opacity-10 p-2 rounded text-warning">
                                <i class="bi bi-calendar-event-fill fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="text-muted text-uppercase small fw-bold">Total Milestones</h6>
                                <h2 class="mb-0 fw-bold text-info">${totalMilestones}</h2>
                            </div>
                            <div class="bg-info bg-opacity-10 p-2 rounded text-info">
                                <i class="bi bi-list-check fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-header bg-white py-3">
                    <h6 class="mb-0 fw-bold">Student Progress Tracking</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4">Student Name</th>
                                    <th>Project Title</th>
                                    <th>Progress</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Project> list = (List<Project>) request.getAttribute("projectList");
                                    if(list != null && !list.isEmpty()) {
                                        for(Project p : list) {
                                            String statusClass = "Completed".equalsIgnoreCase(p.getStatus()) ? "bg-completed" : "bg-active";
                                %>
                                <tr>
                                    <td class="ps-4 fw-bold"><%= p.getStudentName() %></td>
                                    <td><%= p.getTitle() %></td>
                                    <td style="width: 30%;">
                                        <div class="d-flex align-items-center">
                                            <div class="progress flex-grow-1 me-2">
                                                <div class="progress-bar" role="progressbar" style="width: <%= p.getProgress() %>%"
                                                     aria-valuenow="<%= p.getProgress() %>" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                            <span class="small fw-bold text-muted"><%= p.getProgress() %>%</span>
                                        </div>
                                    </td>
                                    <td><span class="status-badge <%= statusClass %>"><%= p.getStatus() %></span></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr><td colspan="4" class="text-center py-4 text-muted">No active students found.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>