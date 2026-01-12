<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Project"%>
<%@page import="com.fyp.model.Milestone"%>
<%@page import="com.fyp.model.Feedback"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Track Milestone</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
                body {
        background-color: #f3f4f6;
        font-family: 'Segoe UI', sans-serif;
        }
                .sidebar {
        width: 250px;
        height: 100vh;
        position: fixed;
        background: white;
        border-right: 1px solid #eee;
        padding: 20px;
        }
                .main-content {
        margin-left: 250px;
        padding: 30px;
        }
                .nav-link {
        color: #64748b;
        padding: 10px 15px;
        margin-bottom: 5px;
        border-radius: 8px;
        font-weight: 500;
        }
                .nav-link.active {
        background-color: #2563EB;
        color: white;
        box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
        }

                /* Stats Card Design */
                .stats-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        height: 100%;
        border-left: 5px solid transparent;
        }
                .border-blue {
        border-left-color: #2563EB;
        }
                .border-green {
        border-left-color: #10B981;
        }

                .milestone-card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        overflow: hidden;
        }
                .milestone-row {
        padding: 15px 20px;
        border-bottom: 1px solid #f1f5f9;
        display: flex;
        justify-content: space-between;
        align-items: center;
        }
                .milestone-row:last-child {
        border-bottom: none;
        }

                .badge-status {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
        }
                .status-completed {
        background-color: #dcfce7;
        color: #15803d;
        }
                .status-pending {
        background-color: #f3f4f6;
        color: #6b7280;
        }
        </style>
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
            // Search Student Logic
            function searchStudent() {
                const studentId = document.getElementById("studentSelect").value;
                if (studentId)
                    window.location.href = "SupervisorMilestoneServlet?studentId=" + studentId;
            }

            // Change Week Logic
            function changeWeek(week) {
                const studentId = "<%= (request.getAttribute("selectedProject") != null) ? ((Project)request.getAttribute("selectedProject")).getStudentId() : "" %>";
                if (studentId) {
                    window.location.href = "SupervisorMilestoneServlet?studentId=" + studentId + "&week=" + week;
                }
            }

            // Popup Logic
            window.onload = function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('alert') === 'success') {
                    const toast = new bootstrap.Toast(document.getElementById('successToast'));
                    toast.show();
                }
            }
        </script>
    </head>
    <body>

        <div class="toast-container position-fixed bottom-0 end-0 p-3">
            <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="bi bi-check-circle-fill me-2"></i> Feedback sent successfully!
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>

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
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold mb-0">Milestone Tracker</h3>
                        <div class="input-group w-auto bg-white p-1 rounded shadow-sm">
                            <select id="studentSelect" class="form-select border-0">
                                <option value="">Select Student...</option>
                                <%
                                    List<Project> students = (List<Project>) request.getAttribute("allStudents");
                                    Project selected = (Project) request.getAttribute("selectedProject");
                                    String selId = (selected != null) ? String.valueOf(selected.getStudentId()) : "";
                                    if(students != null) {
                                        for(Project p : students) {
                                            String sId = String.valueOf(p.getStudentId());
                                %>
                                <option value="<%= sId %>" <%= sId.equals(selId) ? "selected" : "" %>><%= p.getStudentName() %></option>
                                <% } } %>
                            </select>
                            <button class="btn btn-primary" onclick="searchStudent()">Go</button>
                        </div>
                    </div>

                    <% if (selected != null) {
                       int currentWeek = (Integer) request.getAttribute("selectedWeek");
                    %>

                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="stats-card border-blue">
                                <p class="text-muted small text-uppercase fw-bold mb-1">Selected Student</p>
                                <h5 class="fw-bold text-dark mb-0"><%= selected.getStudentName() %></h5>
                                <small class="text-secondary"><%= selected.getTitle() %></small>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="stats-card border-green">
                                <p class="text-muted small text-uppercase fw-bold mb-1">Total Completed</p>
                                <div class="d-flex align-items-center gap-2">
                                    <h2 class="fw-bold text-success mb-0"><%= request.getAttribute("statCompleted") %></h2>
                                    <i class="bi bi-check-circle-fill text-success fs-4"></i>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="stats-card" style="border-left-color: #6b7280;">
                                <p class="text-muted small text-uppercase fw-bold mb-1">Total Milestones</p>
                                <div class="d-flex align-items-center gap-2">
                                    <h2 class="fw-bold text-dark mb-0"><%= request.getAttribute("statTotal") %></h2>
                                    <i class="bi bi-flag-fill text-secondary fs-4"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-md-7">
                            <div class="milestone-card">
                                <div class="p-3 border-bottom bg-light d-flex justify-content-between align-items-center">
                                    <h6 class="fw-bold mb-0">Milestone List</h6>
                                    <select class="form-select form-select-sm w-auto" onchange="changeWeek(this.value)">
                                        <% for(int i=1; i<=14; i++) { %>
                                        <option value="<%= i %>" <%= (i == currentWeek) ? "selected" : "" %>>Week <%= i %></option>
                                        <% } %>
                                    </select>
                                </div>

                                <div class="list-group list-group-flush">
                                    <%
                                        List<Milestone> mList = (List<Milestone>) request.getAttribute("milestoneList");
                                        if (mList != null && !mList.isEmpty()) {
                                            for(Milestone m : mList) {
                                                boolean isDone = "Completed".equalsIgnoreCase(m.getStatus());
                                    %>
                                    <div class="milestone-row">
                                        <div class="d-flex align-items-center gap-3">
                                            <i class="bi <%= isDone ? "bi-check-circle-fill text-success" : "bi-circle text-muted" %>"></i>
                                            <span class="<%= isDone ? "text-decoration-line-through text-muted" : "fw-medium" %>">
                                                <%= m.getDescription() %>
                                            </span>
                                        </div>
                                        <span class="badge-status <%= isDone ? "status-completed" : "status-pending" %>"><%= m.getStatus() %></span>
                                    </div>
                                    <% } } else { %>
                                    <div class="p-4 text-center text-muted">No milestones found for Week <%= currentWeek %></div>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="stats-card">
                                <h6 class="fw-bold mb-3">Feedback for Week <%= currentWeek %></h6>
                                <form action="${pageContext.request.contextPath}/SupervisorFeedbackServlet" method="POST">
                                    <input type="hidden" name="projectId" value="<%= selected.getProjectId() %>">
                                    <input type="hidden" name="studentId" value="<%= selected.getStudentId() %>">
                                    <input type="hidden" name="week" value="<%= currentWeek %>">

                                    <% Feedback fb = (Feedback) request.getAttribute("currentFeedback"); %>
                                    <textarea name="feedbackContent" class="form-control bg-light mb-3" rows="6"
                                              placeholder="Write feedback..." required><%= (fb != null) ? fb.getContent() : "" %></textarea>

                                    <button class="btn btn-primary w-100">
                                        <i class="bi bi-send-fill me-2"></i> <%= (fb != null) ? "Update Feedback" : "Send Feedback" %>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
    </body>
</html>