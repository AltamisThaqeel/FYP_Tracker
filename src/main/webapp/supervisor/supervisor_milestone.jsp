<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Project"%>
<%@page import="com.fyp.model.Milestone"%>
<%@page import="com.fyp.model.Feedback"%>
<%@page import="com.fyp.model.Account"%>

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
            /* Sidebar Z-Index is 100 */
            .sidebar {
                width: 250px;
                height: 100vh;
                position: fixed;
                background: white;
                border-right: 1px solid #eee;
                padding: 20px;
                z-index: 100;
            }
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }

            /* --- CRITICAL FIX: Make Toast Z-Index Higher than Sidebar (9999) --- */
            .toast-container {
                z-index: 9999 !important;
            }

            /* Other styles */
            .nav-link {
                padding: 10px 15px;
                font-weight: 500;
                transition: all 0.2s;
            }
            .nav-link:hover {
                background-color: #f1f5f9;
                color: #2563EB !important;
            }
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
            .form-control:focus {
                box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
            }
        </style>

        <script>
            function searchStudent() {
                const studentId = document.getElementById("studentSelect").value;
                if (studentId)
                    window.location.href = "SupervisorMilestoneServlet?studentId=" + studentId;
            }

            function changeProject(projectId) {
                const studentId = "<%= (request.getAttribute("selectedProject") != null) ? ((Project)request.getAttribute("selectedProject")).getStudentId() : "" %>";
                if (studentId && projectId) {
                    window.location.href = "SupervisorMilestoneServlet?studentId=" + studentId + "&projectId=" + projectId;
                }
            }

            function changeWeek(week) {
                const studentId = "<%= (request.getAttribute("selectedProject") != null) ? ((Project)request.getAttribute("selectedProject")).getStudentId() : "" %>";
                const projectId = "<%= (request.getAttribute("selectedProject") != null) ? ((Project)request.getAttribute("selectedProject")).getProjectId() : "" %>";
                if (studentId) {
                    window.location.href = "SupervisorMilestoneServlet?studentId=" + studentId + "&projectId=" + projectId + "&week=" + week;
                }
            }

            // --- FIXED TOAST SCRIPT ---
            window.onload = function () {
                // Check URL for alert=success
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('alert') === 'success') {
                    console.log("Success parameter found. Showing toast."); // Check browser console
                    const toastEl = document.getElementById('successToast');
                    if (toastEl) {
                        const toast = new bootstrap.Toast(toastEl);
                        toast.show();
                    }
                }
            }
        </script>
    </head>
    <body>

        <div class="toast-container position-fixed bottom-0 end-0 p-3">
            <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body fs-6">
                        <i class="bi bi-check-circle-fill me-2"></i> Feedback sent successfully!
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        </div>

        <div class="sidebar">
            <div class="sidebar-brand text-primary fw-bold mb-4 fs-5">
                <i class="bi bi-mortarboard-fill"></i> FYP Tracker
            </div>
            <nav class="nav flex-column gap-2">
                <a href="${pageContext.request.contextPath}/SupervisorDashboardServlet" class="nav-link text-secondary"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/StudentListServlet" class="nav-link text-secondary"><i class="bi bi-people-fill me-2"></i> Student Project</a>
                <a href="${pageContext.request.contextPath}/SupervisorMilestoneServlet" class="nav-link active bg-primary text-white rounded"><i class="bi bi-list-check me-2"></i> Track Milestone</a>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link text-secondary"><i class="bi bi-person-fill me-2"></i> Profile</a>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link text-danger border-top pt-3 mt-4"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
            </nav>
        </div>

        <div class="main-content">

            <h3 class="fw-bold mb-4 text-start">Milestone Tracker</h3>

            <div class="row justify-content-center mb-5">
                <div class="col-md-10 col-lg-8">
                    <div class="input-group bg-white p-2 rounded shadow-sm">
                        <select id="studentSelect" class="form-select border-0 form-select-lg">
                            <option value="">Select Student to Track...</option>
                            <%
                                List<Account> studentAccounts = (List<Account>) request.getAttribute("studentList");
                                Project selected = (Project) request.getAttribute("selectedProject");
                                String selStudentId = (selected != null) ? String.valueOf(selected.getStudentId()) : "";

                                if(studentAccounts != null) {
                                    for(Account acc : studentAccounts) {
                                        String sId = String.valueOf(acc.getAccountId());
                            %>
                            <option value="<%= sId %>" <%= sId.equals(selStudentId) ? "selected" : "" %>><%= acc.getFullName() %></option>
                            <% } } %>
                        </select>
                        <button class="btn btn-primary px-4 fw-bold" onclick="searchStudent()">SEARCH</button>
                    </div>
                </div>
            </div>

            <% if (selected != null) {
               int currentWeek = (Integer) request.getAttribute("selectedWeek");
               Integer tWeeks = (Integer) request.getAttribute("totalWeeks");
               int maxWeeks = (tWeeks != null) ? tWeeks : 14;

               // Name Lookup
               String selectedName = "ID: " + selected.getStudentId();
               if(studentAccounts != null) {
                   for(Account acc : studentAccounts) {
                       if(acc.getAccountId() == selected.getStudentId()) {
                           selectedName = acc.getFullName();
                           break;
                       }
                   }
               }
            %>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="stats-card border-blue">
                        <p class="text-muted small text-uppercase fw-bold mb-1">Selected Student</p>
                        <h5 class="fw-bold text-dark mb-3"><%= selectedName %></h5>

                        <div class="form-group">
                            <label class="small text-muted mb-1">Current Project:</label>
                            <select class="form-select form-select-sm" onchange="changeProject(this.value)">
                                <%
                                    List<Project> studentProjects = (List<Project>) request.getAttribute("studentProjects");
                                    if(studentProjects != null) {
                                        for(Project sp : studentProjects) {
                                %>
                                <option value="<%= sp.getProjectId() %>"
                                        <%= (sp.getProjectId() == selected.getProjectId()) ? "selected" : "" %>>
                                    <%= sp.getTitle() %>
                                </option>
                                <%      }
                                    }
                                %>
                            </select>
                        </div>
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
                                <% for(int i=1; i<=maxWeeks; i++) { %>
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
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold mb-0">Feedback</h6>
                            <select class="form-select form-select-sm w-auto" onchange="changeWeek(this.value)">
                                <% for(int i=1; i<=maxWeeks; i++) { %>
                                <option value="<%= i %>" <%= (i == currentWeek) ? "selected" : "" %>>Week <%= i %></option>
                                <% } %>
                            </select>
                        </div>

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