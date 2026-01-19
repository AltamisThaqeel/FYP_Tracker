<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Account"%>
<%@page import="com.fyp.model.Project"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
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

            /* --- SIDEBAR NAV LINKS (Scoped) --- */
            .sidebar .nav-link {
                color: #cbd5e1;
                padding: 12px 15px;
                border-radius: 8px;
                margin-bottom: 5px;
                text-decoration: none;
                display: block;
            }
            .sidebar .nav-link:hover, .sidebar .nav-link.active {
                background-color: #334155;
                color: white;
            }

            /* --- TAB BUTTONS (Blue Active State) --- */
            .nav-tabs .nav-link {
                color: #64748b;
                font-weight: 500;
                border-radius: 8px 8px 0 0;
            }
            .nav-tabs .nav-link.active {
                background-color: #0d6efd !important;
                color: white !important;
                border-color: #0d6efd !important;
            }

            .stat-card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                height: 100%;
            }
            .table-card {
                background: white;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                margin-top: 30px;
            }
        </style>

        <script>
            // FUNCTION TO SEARCH ALL TABLES
            function searchAllTables() {
                var input, filter, tables, tr, td, i, j, txtValue;
                input = document.getElementById("systemSearchInput");
                filter = input.value.toUpperCase();

                // Get all tables in the tab content
                tables = document.querySelectorAll(".tab-content table");

                // Loop through each table (Supervisors, Students, Projects)
                tables.forEach(function (table) {
                    tr = table.getElementsByTagName("tr");

                    // Loop through all rows (skip header row 0)
                    for (i = 1; i < tr.length; i++) {
                        var found = false;
                        // Search all columns in the row
                        td = tr[i].getElementsByTagName("td");
                        for (j = 0; j < td.length; j++) {
                            if (td[j]) {
                                txtValue = td[j].textContent || td[j].innerText;
                                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                    found = true;
                                    break;
                                }
                            }
                        }
                        // Toggle row display
                        if (found) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                });
            }
        </script>
    </head>
    <body>

        <div class="sidebar">
            <div class="fw-bold mb-1 fs-4 text-white">
                <i class="bi bi-mortarboard-fill"></i> FYP Tracker
            </div>
            <div class="fw-bold mb-5 fs-6 text-white"><i class="bi bi-shield-lock-fill me-2"></i> Admin Panel</div>
            <nav>
                <a href="AdminDashboardServlet" class="nav-link active"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
                <a href="AdminAssignServlet" class="nav-link"><i class="bi bi-person-lines-fill me-2"></i> Assign Student</a>
                <a href="AdminUsersServlet" class="nav-link"><i class="bi bi-people-fill me-2"></i> Manage Account</a>
                <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-link "><i class="bi bi-person-fill me-2"></i> Profile</a>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link text-danger mt-5"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
            </nav>
        </div>



        <div class="main-content">
            <h3 class="fw-bold mb-4">Admin Dashboard Overview</h3>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <i class="bi bi-person-square text-primary fs-3"></i>
                            <h6 class="text-muted mb-0">Total Students</h6>
                        </div>
                        <h2 class="fw-bold text-dark"><%= request.getAttribute("statStudent") %></h2>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <i class="bi bi-person-video3 text-success fs-3"></i>
                            <h6 class="text-muted mb-0">Total Supervisors</h6>
                        </div>
                        <h2 class="fw-bold text-dark"><%= request.getAttribute("statSupervisor") %></h2>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <i class="bi bi-kanban text-warning fs-3"></i>
                            <h6 class="text-muted mb-0">Projects</h6>
                        </div>
                        <div class="d-flex justify-content-between">
                            <div>
                                <small class="text-muted text-uppercase fw-bold" style="font-size: 0.7rem;">Total</small>
                                <h3 class="fw-bold text-dark mb-0"><%= request.getAttribute("statProjectTotal") %></h3>
                            </div>
                            <div class="text-end">
                                <small class="text-muted text-uppercase fw-bold" style="font-size: 0.7rem;">Completed</small>
                                <h3 class="fw-bold text-success mb-0"><%= request.getAttribute("statProjectCompleted") %></h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0">System Directories</h5>

                    <div class="input-group" style="width: 300px;">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-search"></i></span>
                        <input type="text" id="systemSearchInput" onkeyup="searchAllTables()" class="form-control border-start-0 bg-light" placeholder="Search...">
                    </div>
                </div>

                <ul class="nav nav-tabs mb-3" id="adminTabs" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" id="sup-tab" data-bs-toggle="tab" data-bs-target="#supervisors" type="button">Supervisors</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="stu-tab" data-bs-toggle="tab" data-bs-target="#students" type="button">Students</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="proj-tab" data-bs-toggle="tab" data-bs-target="#projects" type="button">Projects</button>
                    </li>
                </ul>

                <div class="tab-content" id="adminTabsContent">

                    <div class="tab-pane fade show active" id="supervisors">
                        <table class="table table-hover">
                            <thead class="table-light"><tr><th>ID</th><th>Name</th><th>Email</th></tr></thead>
                            <tbody>
                                <% List<Account> sups = (List<Account>) request.getAttribute("supervisorList");
                               if(sups != null) for(Account a : sups) { %>
                                <tr><td><%= a.getAccountId() %></td><td><%= a.getFullName() %></td><td><%= a.getEmail() %></td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="students">
                        <table class="table table-hover">
                            <thead class="table-light"><tr><th>ID</th><th>Name</th><th>Email</th></tr></thead>
                            <tbody>
                                <% List<Account> stus = (List<Account>) request.getAttribute("studentList");
                               if(stus != null) for(Account a : stus) { %>
                                <tr><td><%= a.getAccountId() %></td><td><%= a.getFullName() %></td><td><%= a.getEmail() %></td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="projects">
                        <table class="table table-hover">
                            <thead class="table-light"><tr><th>ID</th><th>Title</th><th>Status</th></tr></thead>
                            <tbody>
                                <% List<Project> projs = (List<Project>) request.getAttribute("projectList");
                                   if(projs != null) for(Project p : projs) {
                                       String badge = "Completed".equalsIgnoreCase(p.getStatus()) ? "bg-success" : "bg-primary";
                                %>
                                <tr>
                                    <td><%= p.getProjectId() %></td>
                                    <td><%= p.getTitle() %></td>
                                    <td><span class="badge <%= badge %>"><%= p.getStatus() %></span></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>

    </body>
</html>