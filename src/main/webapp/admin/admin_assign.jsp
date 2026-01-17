<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Account"%>
<%@page import="com.fyp.model.Project"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Assign Supervisor - Admin</title>
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
                background: #1e293b;
                color: white;
                padding: 20px;
            }
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }
            .nav-link {
                color: #cbd5e1;
                padding: 12px 15px;
                border-radius: 8px;
                margin-bottom: 5px;
                text-decoration: none;
                display: block;
            }
            .nav-link:hover, .nav-link.active {
                background-color: #334155;
                color: white;
            }
            .table-card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .badge-unassigned {
                background-color: #e5e7eb;
                color: #374151;
            }
            .badge-assigned {
                background-color: #dcfce7;
                color: #166534;
            }
        </style>

        <script>
            window.onload = function () {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('alert') === 'success') {
                    const toast = new bootstrap.Toast(document.getElementById('successToast'));
                    toast.show();
                }
            }

            // Updated Search to work with manual lookups
            function searchTable() {
                var input, filter, table, tr, td, i, txtValue;
                input = document.getElementById("searchInput");
                filter = input.value.toUpperCase();
                table = document.getElementById("assignTable");
                tr = table.getElementsByTagName("tr");

                for (i = 0; i < tr.length; i++) {
                    // Search Column 1 (Project/Student)
                    td = tr[i].getElementsByTagName("td")[1];
                    if (td) {
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
        </script>
    </head>
    <body>

        <div class="toast-container position-fixed bottom-0 end-0 p-3">
            <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body"><i class="bi bi-check-circle-fill me-2"></i> Assignment Updated!</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>

        <div class="sidebar">

            <div class="fw-bold mb-1 fs-4 text-white">
                <i class="bi bi-mortarboard-fill"></i> FYP Tracker
            </div>
            <div class="fw-bold mb-5 fs-6 text-white"><i class="bi bi-shield-lock-fill me-2"></i> Admin Panel</div>

            <nav>
                <a href="AdminDashboardServlet" class="nav-link"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
                <a href="AdminAssignServlet" class="nav-link active"><i class="bi bi-person-lines-fill me-2"></i> Assign Student</a>
                <a href="AdminUsersServlet" class="nav-link"><i class="bi bi-people-fill me-2"></i> Manage Account</a>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link "><i class="bi bi-person-fill me-2"></i> Profile</a>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link text-danger mt-5"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
            </nav>
        </div>

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-0">Assign Supervisors</h3>
                    <span class="text-muted small">Link students to their academic supervisors</span>
                </div>
            </div>

            <div class="table-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0">Project List</h5>
                    <div class="input-group" style="width: 350px;">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-search"></i></span>
                        <input type="text" id="searchInput" onkeyup="searchTable()" class="form-control border-start-0 bg-light" placeholder="Search ID, Project, or Student...">
                    </div>
                </div>

                <table class="table table-hover align-middle" id="assignTable">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 5%;">ID</th>
                            <th style="width: 35%;">Project / Student</th>
                            <th style="width: 25%;">Current Supervisor</th>
                            <th style="width: 35%;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Project> projs = (List<Project>) request.getAttribute("projectList");
                            List<Account> sups = (List<Account>) request.getAttribute("supervisorList");
                            List<Account> studs = (List<Account>) request.getAttribute("studentList");

                            if(projs != null && !projs.isEmpty()) {
                                for(Project p : projs) {

                                    // --- MANUAL LOOKUP FOR STUDENT NAME ---
                                    String studentName = "Unknown Student";
                                    if(studs != null) {
                                        for(Account s : studs) {
                                            if(s.getAccountId() == p.getStudentId()) {
                                                studentName = s.getFullName();
                                                break;
                                            }
                                        }
                                    }

                                    // --- MANUAL LOOKUP FOR SUPERVISOR NAME ---
                                    String supervisorName = "Unassigned";
                                    boolean isAssigned = false;
                                    if(p.getSupervisorId() > 0 && sups != null) {
                                        for(Account s : sups) {
                                            if(s.getAccountId() == p.getSupervisorId()) {
                                                supervisorName = s.getFullName();
                                                isAssigned = true;
                                                break;
                                            }
                                        }
                                    }
                        %>
                        <tr>
                            <td class="fw-bold text-muted"><%= p.getProjectId() %></td>

                            <td>
                                <div class="fw-bold text-primary"><%= p.getTitle() %></div>
                                <small class="text-muted"><i class="bi bi-person-fill me-1"></i><%= studentName %></small>
                            </td>

                            <td>
                                <% if(isAssigned) { %>
                                <span class="badge badge-assigned"><i class="bi bi-check-circle me-1"></i><%= supervisorName %></span>
                                    <% } else { %>
                                <span class="badge badge-unassigned">Unassigned</span>
                                <% } %>
                            </td>

                            <td>
                                <form action="AdminAssignServlet" method="POST" class="d-flex gap-2">
                                    <input type="hidden" name="projectId" value="<%= p.getProjectId() %>">

                                    <select name="supervisorId" class="form-select form-select-sm">
                                        <option value="" <%= !isAssigned ? "selected" : "" %>>Select Supervisor...</option>
                                        <% if(sups != null) {
                                            for(Account s : sups) {
                                                // Check if this specific supervisor matches current project
                                                boolean isCurrent = (s.getAccountId() == p.getSupervisorId());
                                        %>
                                        <option value="<%= s.getAccountId() %>" <%= isCurrent ? "selected" : "" %>>
                                            <%= s.getFullName() %>
                                        </option>
                                        <%  } } %>
                                    </select>
                                    <button type="submit" class="btn btn-primary btn-sm px-3">Assign</button>
                                </form>
                            </td>
                        </tr>
                        <%      }
                            } else {
                        %>
                        <tr><td colspan="4" class="text-center text-muted py-4">No projects found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </body>
</html>