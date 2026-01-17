<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.fyp.model.Account"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Users - Admin</title>
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
            .status-active {
                color: #166534;
                background-color: #dcfce7;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: bold;
            }
            .status-inactive {
                color: #991b1b;
                background-color: #fee2e2;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: bold;
            }
            .nav-tabs .nav-link {
                color: #64748b;
                font-weight: 500;
            }
            .nav-tabs .nav-link.active {
                color: #0d6efd;
                border-color: #dee2e6 #dee2e6 #fff;
                font-weight: bold;
            }
        </style>

        <script>
            window.onload = function () {
                const urlParams = new URLSearchParams(window.location.search);

                // 1. Show Toast
                const alertType = urlParams.get('alert');
                if (alertType) {
                    const toast = new bootstrap.Toast(document.getElementById('actionToast'));
                    const msg = document.getElementById('toastMsg');
                    if (alertType === 'created')
                        msg.innerText = "Admin Created!";
                    else if (alertType === 'updated')
                        msg.innerText = "Status Updated!";
                    else if (alertType === 'deleted')
                        msg.innerText = "User Deleted!";
                    else if (alertType === 'error')
                        msg.innerText = "Action Failed!";
                    toast.show();
                }

                // 2. Persist Tab
                const activeTab = urlParams.get('tab');
                if (activeTab) {
                    const tabBtn = document.getElementById(activeTab + '-tab');
                    if (tabBtn) {
                        const tab = new bootstrap.Tab(tabBtn);
                        tab.show();
                    }
                }
            }
        </script>
    </head>
    <body>

        <div class="toast-container position-fixed bottom-0 end-0 p-3">
            <div id="actionToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body"><i class="bi bi-check-circle-fill me-2"></i> <span id="toastMsg">Success</span></div>
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
                <a href="AdminAssignServlet" class="nav-link"><i class="bi bi-person-lines-fill me-2"></i> Assign Student</a>
                <a href="AdminUsersServlet" class="nav-link active"><i class="bi bi-people-fill me-2"></i> Manage Account</a>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> Profile</a>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link text-danger mt-5"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
            </nav>
        </div>

        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">Manage Accounts</h3>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createAdminModal">
                    <i class="bi bi-person-plus-fill me-2"></i> Create New Admin
                </button>
            </div>

            <div class="table-card">

                <ul class="nav nav-tabs mb-3" id="userTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="admin-tab" data-bs-toggle="tab" data-bs-target="#adminContent" type="button" role="tab">Admins</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="supervisor-tab" data-bs-toggle="tab" data-bs-target="#supervisorContent" type="button" role="tab">Supervisors</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="student-tab" data-bs-toggle="tab" data-bs-target="#studentContent" type="button" role="tab">Students</button>
                    </li>
                </ul>

                <div class="tab-content" id="userTabsContent">
                    <% List<Account> users = (List<Account>) request.getAttribute("userList"); %>

                    <div class="tab-pane fade show active" id="adminContent" role="tabpanel">
                        <table class="table table-hover align-middle">
                            <thead class="table-light"><tr><th>ID</th><th>Name</th><th>Email</th><th>Status</th><th>Action</th></tr></thead>
                            <tbody>
                                <% if(users!=null) for(Account a : users) { if("Admin".equalsIgnoreCase(a.getRoleType())) {
                                boolean active = "Active".equalsIgnoreCase(a.getStatus()); %>
                                <tr>
                                    <td><%= a.getAccountId() %></td>
                                    <td><%= a.getFullName() %></td>
                                    <td><%= a.getEmail() %></td>
                                    <td><span class="<%= active ? "status-active":"status-inactive" %>"><%= active?"Active":"Inactive" %></span></td>
                                    <td>
                                        <form action="AdminUsersServlet" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="id" value="<%= a.getAccountId() %>">
                                            <input type="hidden" name="status" value="<%= a.getStatus() %>">
                                            <input type="hidden" name="tab" value="admin">
                                            <button class="btn btn-sm btn-outline-dark"><i class="bi bi-toggle-on"></i></button>
                                        </form>
                                        <form action="AdminUsersServlet" method="POST" style="display:inline;" onsubmit="return confirm('Delete Admin?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= a.getAccountId() %>">
                                            <input type="hidden" name="tab" value="admin">
                                            <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="supervisorContent" role="tabpanel">
                        <table class="table table-hover align-middle">
                            <thead class="table-light"><tr><th>ID</th><th>Name</th><th>Email</th><th>Status</th><th>Action</th></tr></thead>
                            <tbody>
                                <% if(users!=null) for(Account a : users) { if("Supervisor".equalsIgnoreCase(a.getRoleType())) {
                                boolean active = "Active".equalsIgnoreCase(a.getStatus()); %>
                                <tr>
                                    <td><%= a.getAccountId() %></td>
                                    <td><%= a.getFullName() %></td>
                                    <td><%= a.getEmail() %></td>
                                    <td><span class="<%= active ? "status-active":"status-inactive" %>"><%= active?"Active":"Inactive" %></span></td>
                                    <td>
                                        <form action="AdminUsersServlet" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="id" value="<%= a.getAccountId() %>">
                                            <input type="hidden" name="status" value="<%= a.getStatus() %>">
                                            <input type="hidden" name="tab" value="supervisor">
                                            <button class="btn btn-sm btn-outline-dark"><i class="bi bi-toggle-on"></i></button>
                                        </form>
                                        <form action="AdminUsersServlet" method="POST" style="display:inline;" onsubmit="return confirm('Delete Supervisor?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= a.getAccountId() %>">
                                            <input type="hidden" name="tab" value="supervisor">
                                            <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="studentContent" role="tabpanel">
                        <table class="table table-hover align-middle">
                            <thead class="table-light"><tr><th>ID</th><th>Name</th><th>Email</th><th>Status</th><th>Action</th></tr></thead>
                            <tbody>
                                <% if(users!=null) for(Account a : users) { if("Student".equalsIgnoreCase(a.getRoleType())) {
                                boolean active = "Active".equalsIgnoreCase(a.getStatus()); %>
                                <tr>
                                    <td><%= a.getAccountId() %></td>
                                    <td><%= a.getFullName() %></td>
                                    <td><%= a.getEmail() %></td>
                                    <td><span class="<%= active ? "status-active":"status-inactive" %>"><%= active?"Active":"Inactive" %></span></td>
                                    <td>
                                        <form action="AdminUsersServlet" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="id" value="<%= a.getAccountId() %>">
                                            <input type="hidden" name="status" value="<%= a.getStatus() %>">
                                            <input type="hidden" name="tab" value="student">
                                            <button class="btn btn-sm btn-outline-dark"><i class="bi bi-toggle-on"></i></button>
                                        </form>
                                        <form action="AdminUsersServlet" method="POST" style="display:inline;" onsubmit="return confirm('Delete Student? All their projects will be removed!');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= a.getAccountId() %>">
                                            <input type="hidden" name="tab" value="student">
                                            <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </div>

        <div class="modal fade" id="createAdminModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Create New Admin</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="AdminUsersServlet" method="POST">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="createAdmin">
                            <input type="hidden" name="tab" value="admin">
                            <div class="mb-3">
                                <label class="form-label">Full Name</label>
                                <input type="text" name="fullname" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Create Admin</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </body>
</html>