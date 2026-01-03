<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Project"%>
<%@page import="com.fyp.model.Milestone"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Track Milestone - FYP Tracker</title>
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
            .sidebar-brand {
                font-weight: bold;
                font-size: 1.2rem;
                margin-bottom: 30px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .nav-link {
                color: #6C757D;
                padding: 10px 15px;
                margin-bottom: 5px;
                border-radius: 10px;
                font-weight: 500;
                text-decoration: none;
            }
            .nav-link:hover {
                background-color: #f1f5f9;
                color: #2563EB;
            }
            .nav-link.active {
                background-color: #2563EB;
                color: white;
                box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2);
            }
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }

            .milestone-item {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
            }
            .milestone-text {
                display: flex;
                align-items: center;
                gap: 10px;
                font-weight: 500;
            }
            .badge-status {
                font-size: 0.7rem;
                padding: 5px 10px;
                border-radius: 5px;
            }
            .badge-na {
                background-color: #f8f9fa;
                color: #adb5bd;
            } /* Not Started */
            .badge-done {
                background-color: #d1e7dd;
                color: #0f5132;
            } /* Completed */

            .feedback-area {
                background-color: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.02);
                height: 100%;
            }
            textarea.form-control {
                background-color: #F8F9FA;
                border: none;
                resize: none;
            }
            textarea.form-control:focus {
                background-color: white;
                box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
            }
        </style>

        <script>
            function searchStudent() {
                const select = document.getElementById("studentSelect");
                const studentId = select.value;
                if (studentId) {
                    // Reload page with selected ID via Servlet
                    window.location.href = "SupervisorMilestoneServlet?studentId=" + studentId;
                } else {
                    alert("Please select a student.");
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
                <a href="${pageContext.request.contextPath}/SupervisorDashboardServlet" class="nav-link">
                    <i class="bi bi-grid-fill me-2"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/StudentListServlet" class="nav-link">
                    <i class="bi bi-people-fill me-2"></i> Student
                </a>
                <a href="${pageContext.request.contextPath}/SupervisorMilestoneServlet" class="nav-link active">
                    <i class="bi bi-list-check me-2"></i> Track Milestone
                </a>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link">
                    <i class="bi bi-person-fill me-2"></i> Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link mt-5 text-danger border-top pt-3">
                    <i class="bi bi-box-arrow-right me-2"></i> Logout
                </a>
            </nav>
        </div>

        <div class="main-content">
            <h3 class="mb-4">Project</h3>

            <div class="bg-white p-3 rounded shadow-sm mb-4">
                <p class="small fw-bold text-uppercase text-muted mb-2">STUDENT MILESTONE</p>
                <div class="input-group">
                    <select id="studentSelect" class="form-select border-0 bg-light">
                        <option value="">Select student</option>
                        <%
                            List<Project> students = (List<Project>) request.getAttribute("allStudents");
                            Project selected = (Project) request.getAttribute("selectedProject");
                            String selId = (selected != null) ? selected.getStudentId() : "";

                            if(students != null) {
                                for(Project p : students) {
                                    String isSel = p.getStudentId().equals(selId) ? "selected" : "";
                        %>
                        <option value="<%= p.getStudentId() %>" <%= isSel %>><%= p.getStudentName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <button class="btn btn-primary px-4" onclick="searchStudent()">Search</button>
                </div>
            </div>

            <% if (selected != null) { %>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="bg-white p-3 rounded shadow-sm d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="fw-bold mb-0 text-success"><%= request.getAttribute("statCompleted") %></h3>
                            <small class="text-muted">Completed Milestones</small>
                        </div>
                        <div class="bg-light p-2 rounded text-success"><i class="bi bi-check-circle-fill fs-4"></i></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="bg-white p-3 rounded shadow-sm d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="fw-bold mb-0 text-primary"><%= request.getAttribute("statTotal") %></h3>
                            <small class="text-muted">Total Milestones</small>
                        </div>
                        <div class="bg-light p-2 rounded text-primary"><i class="bi bi-list-check fs-4"></i></div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-6">
                    <div class="bg-white p-4 rounded shadow-sm" id="milestoneContainer">
                        <div class="d-flex justify-content-between mb-4">
                            <h5 class="fw-bold">Week 1 Milestones</h5>
                            <select class="form-select form-select-sm w-auto">
                                <option>Week 1</option>
                            </select>
                        </div>

                        <div class="milestone-list">
                            <%
                                List<Milestone> mList = (List<Milestone>) request.getAttribute("milestoneList");
                                if (mList != null && !mList.isEmpty()) {
                                    for(Milestone m : mList) {
                                        boolean isDone = "Completed".equalsIgnoreCase(m.getStatus());
                                        String badgeClass = isDone ? "badge-done" : "badge-na";
                                        String iconClass = isDone ? "bi-check-circle-fill text-success" : "bi-caret-right-fill text-muted";
                            %>
                            <div class="milestone-item">
                                <div class="milestone-text">
                                    <i class="bi <%= iconClass %>"></i> <%= m.getDescription() %>
                                </div>
                                <span class="badge-status <%= badgeClass %>"><%= m.getStatus() %></span>
                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <p class="text-muted">No milestones found for this week.</p>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="feedback-area">
                        <h5 class="fw-bold mb-2">Write The Feedback</h5>
                        <p class="text-muted small mb-3">Your thoughts are valuable in helping improve the student's progress.</p>

                        <form action="SupervisorFeedbackServlet" method="POST">
                            <input type="hidden" name="projectId" value="<%= selected.getProjectId() %>">
                            <input type="hidden" name="week" value="1">

                            <div class="mb-3">
                                <textarea name="feedbackContent" class="form-control" rows="8" placeholder="Enter your feedback here..." required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 py-2">Submit Feedback</button>
                        </form>
                    </div>
                </div>
            </div>

            <% } else { %>
            <div class="alert alert-info">Please select a student above to view their progress.</div>
            <% } %>

        </div>

    </body>
</html>