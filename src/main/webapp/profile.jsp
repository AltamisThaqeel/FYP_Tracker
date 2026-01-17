<%@page import="com.fyp.model.Account"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. GET USER & ROLE FROM SESSION
    Account user = (Account) session.getAttribute("user");
    String role = (String) session.getAttribute("role"); // "Student" or "Supervisor"

    // 2. SECURITY CHECK
    if (user == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>FYP Tracker - User Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <style>
            body {
                background-color: #F8F9FA;
                font-family: 'Segoe UI', sans-serif;
            }

            /* Sidebar Styling */
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
            .nav-link i {
                margin-right: 10px;
            }

            /* Main Content */
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }

            /* Cards */
            .profile-card, .info-card {
                background: white;
                border-radius: 15px;
                border: none;
                box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            }
            .profile-img {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
                margin-bottom: 15px;
                border: 3px solid #e9ecef;
            }
            .contact-item {
                font-size: 0.9rem;
                color: #6c757d;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .section-title {
                font-size: 0.9rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 15px;
            }
            .info-label {
                font-size: 0.85rem;
                color: #6c757d;
            }
            .info-value {
                font-size: 0.95rem;
                font-weight: 500;
                color: #333;
            }
            .btn-edit {
                background-color: #2563EB;
                color: white;
                border-radius: 8px;
                padding: 5px 15px;
                font-size: 0.9rem;
                transition: 0.3s;
            }
            .btn-edit:hover {
                background-color: #1d4ed8;
            }
        </style>

        <script>
            function handleEdit() {
                // Updated to use the correct getter
                const newName = prompt("Edit Full Name:", "<%= user.getFullName() %>");
                if (newName) {
                    document.getElementById("userNameDisplay").innerText = newName;
                    document.getElementById("mainNameDisplay").innerText = newName;
                    alert("Profile name updated (visual only)!");
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

                <%-- SCENARIO: STUDENT IS LOGGED IN --%>
                <% if ("Student".equalsIgnoreCase(role)) { %>
                <a href="${pageContext.request.contextPath}/StudentDashboardServlet" class="nav-link"><i class="bi bi-grid-fill"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/CreateProjectServlet" class="nav-link"><i class="bi bi-folder-fill"></i> My Project</a>
                <a href="${pageContext.request.contextPath}/MilestoneServlet" class="nav-link"><i class="bi bi-list-check"></i> Milestones</a>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link active"><i class="bi bi-person-fill"></i> User Profile</a>
                <a href="${pageContext.request.contextPath}/StudentFeedbackServlet" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right"></i> Logout</a>

                <%-- SCENARIO: SUPERVISOR IS LOGGED IN --%>
                <% } else if ("Supervisor".equalsIgnoreCase(role)) { %>
                <a href="${pageContext.request.contextPath}/SupervisorDashboardServlet" class="nav-link"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/StudentListServlet" class="nav-link"><i class="bi bi-people-fill"></i> Student Projects</a>
                <a href="${pageContext.request.contextPath}/SupervisorMilestoneServlet" class="nav-link"><i class="bi bi-list-check me-2"></i> Track Milestone</a>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link active"><i class="bi bi-person-fill"></i> User Profile</a>
                <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link mt-5 text-danger border-top pt-3">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
                <% } %>
            </nav>
        </div>

        <div class="main-content">
            <h3 class="fw-bold mb-4">User Profile</h3>

            <div class="row">
                <div class="col-md-4">
                    <div class="card profile-card p-4 h-100">
                        <div class="text-center">
                            <%-- FIXED: Used .getFullName() instead of .getName() --%>
                            <img src="https://ui-avatars.com/api/?name=<%= user.getFullName().replace(" ", "+") %>&background=random" class="profile-img" alt="Profile">

                            <h5 class="fw-bold mb-0" id="userNameDisplay"><%= user.getFullName() %></h5>
                            <p class="text-primary small"><%= role %></p>
                            <p class="text-muted small">Universiti Teknologi MARA</p>
                        </div>

                        <hr class="my-4">

                        <div class="contact-info">
                            <div class="contact-item"><i class="bi bi-envelope"></i> <%= user.getEmail() %></div>
                            <div class="contact-item"><i class="bi bi-geo-alt"></i> Shah Alam, Malaysia</div>
                            <div class="contact-item"><i class="bi bi-calendar"></i> Joined March 2024</div>
                        </div>

                        <hr class="my-4">

                        <div class="section-title">Quick Stats</div>
                        <div class="p-3 bg-light rounded mb-2 border-start border-4 border-primary">
                            <small class="text-muted d-block">Projects</small>
                            <span class="fw-bold text-dark">1 Active</span>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card info-card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0">Profile Information</h5>
                            <button class="btn btn-edit border-0" onclick="handleEdit()">Edit Profile</button>
                        </div>

                        <div class="section-title text-secondary">Personal Information</div>
                        <div class="row mb-4">
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Full Name</div>
                                <%-- FIXED: Used .getFullName() --%>
                                <div class="info-value" id="mainNameDisplay"><%= user.getFullName() %></div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <div class="info-label"><%= role.equals("Student") ? "Student ID" : "Staff ID" %></div>
                                <%-- FIXED: Used .getAccountId() instead of .getId() --%>
                                <div class="info-value"><%= user.getAccountId() %></div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <div class="info-label">Email</div>
                                <div class="info-value"><%= user.getEmail() %></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Account Status</div>
                                <div class="info-value text-success">Active</div>
                            </div>
                        </div>

                        <hr>

                        <div class="section-title text-secondary mt-3">Academic Information</div>
                        <div class="row mb-4">
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Faculty</div>
                                <div class="info-value">Faculty of Computer & Mathematical Sciences</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Program Code</div>
                                <div class="info-value">CS230</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Specialization</div>
                                <div class="info-value">Computer Science (Machine Learning)</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Education Type</div>
                                <div class="info-value">Bachelor's Degree</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>