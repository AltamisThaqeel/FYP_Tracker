<%@page import="com.fyp.model.Account"%>
<%@page import="com.fyp.model.Student"%>
<%@page import="com.fyp.model.Supervisor"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Account user = (Account) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (user == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean isAdmin = "Admin".equalsIgnoreCase(role);
    String sidebarClass = isAdmin ? "sidebar admin-sidebar" : "sidebar";
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>FYP Tracker - User Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <style>
            body { background-color: #f3f4f6; font-family: 'Segoe UI', sans-serif; }
            .sidebar { width: 250px; height: 100vh; position: fixed; padding: 20px; background-color: #FFFFFF; border-right: 1px solid #eee; }
            .sidebar .nav-link { color: #6C757D; padding: 12px 15px; margin-bottom: 5px; border-radius: 8px; font-weight: 500; text-decoration: none; display: block; }
            .sidebar .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
            .sidebar .nav-link.active { background-color: #2563EB; color: white; }
            .sidebar .sidebar-brand { color: #0d6efd; font-weight: bold; font-size: 1.2rem; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
            .sidebar.admin-sidebar { background-color: #1e293b !important; color: #ffffff !important; }
            .sidebar.admin-sidebar .nav-link { color: #cbd5e1 !important; }
            .main-content { margin-left: 250px; padding: 30px; }
            .profile-card, .info-card { background: white; border-radius: 15px; border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.03); }
            .profile-img { width: 100px; height: 100px; border-radius: 50%; object-fit: cover; margin-bottom: 15px; border: 3px solid #e9ecef; }
            .section-title { font-size: 0.9rem; font-weight: bold; color: #333; margin-bottom: 15px; }
            .fancy-box {background: #ffffff;border-radius: 20px;border: 1px solid rgba(0, 0, 0, 0.05);padding: 30px;box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);transition: all 0.3s ease;}
            .fancy-box:hover {box-shadow: 0 15px 35px rgba(37, 99, 235, 0.08);transform: translateY(-2px);}
            .attribute-group {background: #f8fafc;border-radius: 12px;padding: 15px;height: 100%;border-left: 4px solid #2563eb; /* Blue accent line */}
            .info-label {font-size: 0.75rem;text-transform: uppercase;letter-spacing: 1px;font-weight: 700;color: #64748b;margin-bottom: 5px;display: block;}
            .info-value {font-size: 1rem;color: #1e293b;font-weight: 600;}
            
            /* Toggle visibility for Edit mode */
            .edit-mode { display: none; }
        </style>

        <script>
            function toggleEdit() {
                const viewElements = document.querySelectorAll('.view-mode');
                const editElements = document.querySelectorAll('.edit-mode');
                const editBtn = document.getElementById('editBtn');

                if (editBtn.innerText === "Edit Profile") {
                    viewElements.forEach(el => el.style.display = 'none');
                    editElements.forEach(el => el.style.display = 'block');
                    editBtn.innerText = "Cancel";
                    editBtn.classList.replace('btn-primary', 'btn-secondary');
                } else {
                    viewElements.forEach(el => el.style.display = 'block');
                    editElements.forEach(el => el.style.display = 'none');
                    editBtn.innerText = "Edit Profile";
                    editBtn.classList.replace('btn-secondary', 'btn-primary');
                }
            }
        </script>
    </head>
    <body>

        <div class="<%= sidebarClass %>">
            <% if(isAdmin) { %>
                <div class="fw-bold mb-1 fs-4 text-white"><i class="bi bi-mortarboard-fill"></i> FYP Tracker</div>
                <div class="fw-bold mb-5 fs-6 text-white"><i class="bi bi-shield-lock-fill me-2"></i> Admin Panel</div>
            <% } else { %>
                <div class="sidebar-brand"><i class="bi bi-mortarboard-fill"></i> FYP Tracker</div>
            <% } %>

            <nav class="nav flex-column">
                <c:choose>
                    <c:when test="${role == 'Student'}">
                        <a href="StudentDashboardServlet" class="nav-link"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
                        <a href="CreateProjectServlet" class="nav-link"><i class="bi bi-folder-fill me-2"></i> My Project</a>
                        <a href="MilestoneServlet" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
                        <a href="StudentFeedbackServlet" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
                    </c:when>
                    <c:when test="${role == 'Supervisor'}">
                        <a href="SupervisorDashboardServlet" class="nav-link"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
                        <a href="StudentListServlet" class="nav-link"><i class="bi bi-people-fill me-2"></i> Student Projects</a>
                        <a href="SupervisorMilestoneServlet" class="nav-link"><i class="bi bi-list-check me-2"></i> Track Milestone</a>
                    </c:when>
                    <c:when test="${role == 'Admin'}">
                        <a href="AdminDashboardServlet" class="nav-link"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
                        <a href="AdminAssignServlet" class="nav-link"><i class="bi bi-person-lines-fill me-2"></i> Assign</a>
                    </c:when>
                </c:choose>
                <a href="ProfileServlet" class="nav-link active"><i class="bi bi-person-fill me-2"></i> User Profile</a>
                <a href="logout.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
            </nav>
        </div>

        <div class="main-content">
            <h3 class="fw-bold mb-4">User Profile</h3>
            
            <c:if test="${param.status == 'success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    Profile updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="ProfileServlet" method="POST">
                <div class="row">
                    <div class="col-md-4">
                        <div class="card profile-card p-4">
                            <div class="text-center">
                                <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=random" class="profile-img" alt="Profile">
                                <h5 class="fw-bold mb-0">${user.fullName}</h5>
                                <p class="text-primary small">${role}</p>
                                <p class="text-muted small">Universiti Teknologi MARA</p>
                            </div>
                            <hr class="my-4">
                            <div class="contact-info">
                                <div class="mb-2"><i class="bi bi-envelope me-2"></i> ${user.email}</div>
                                <div class="view-mode"><i class="bi bi-telephone me-2"></i> ${not empty profileDetails.phoneNum ? profileDetails.phoneNum : 'Not set'}</div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-8">
                        <div class="fancy-box">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h5 class="fw-bold m-0"><i class="bi bi-person-lines-fill me-2 text-primary"></i>Personal Details</h5>
                                    <p class="text-muted small m-0">Manage your account settings and academic information</p>
                                </div>
                                <button type="button" id="editBtn" class="btn btn-primary rounded-pill px-4 shadow-sm" onclick="toggleEdit()">
                                    <i class="bi bi-pencil-square me-2"></i>Edit Profile
                                </button>
                            </div>

                            <div class="row g-4">
                                <%-- Full Name --%>
                                <div class="col-md-6">
                                    <div class="attribute-group">
                                        <label class="info-label">Full Name</label>
                                        <div class="view-mode info-value">${user.fullName}</div>
                                        <input type="text" name="fullName" class="form-control edit-mode" value="${user.fullName}" required>
                                    </div>
                                </div>

                                <%-- Email (Read Only) --%>
                                <div class="col-md-6">
                                    <div class="attribute-group" style="border-left-color: #cbd5e1;">
                                        <label class="info-label">Official Email</label>
                                        <div class="info-value text-muted">${user.email}</div>
                                    </div>
                                </div>

                                <%-- Role Specific Data --%>
                                <c:choose>
                                    <c:when test="${role == 'Student'}">
                                        <div class="col-md-6">
                                            <div class="attribute-group">
                                                <label class="info-label">Phone Number</label>
                                                <div class="view-mode info-value">${not empty profileDetails.phoneNum ? profileDetails.phoneNum : 'Not Set'}</div>
                                                <input type="text" name="phone" class="form-control edit-mode" value="${profileDetails.phoneNum}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="attribute-group">
                                                <label class="info-label">Enrollment Year</label>
                                                <div class="view-mode info-value">${profileDetails.enrollmentYear}</div>
                                                <input type="number" name="enrollmentYear" class="form-control edit-mode" value="${profileDetails.enrollmentYear}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="attribute-group">
                                                <label class="info-label">Specialization</label>
                                                <div class="view-mode info-value">${profileDetails.specialization}</div>
                                                <input type="text" name="specialization" class="form-control edit-mode" value="${profileDetails.specialization}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="attribute-group">
                                                <label class="info-label">Education Type</label>
                                                <div class="view-mode info-value">${profileDetails.educationType}</div>
                                                <input type="text" name="educationType" class="form-control edit-mode" value="${profileDetails.educationType}">
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="attribute-group">
                                                <label class="info-label">Mailing Address</label>
                                                <div class="view-mode info-value">${profileDetails.address}</div>
                                                <textarea name="address" class="form-control edit-mode" rows="2">${profileDetails.address}</textarea>
                                            </div>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <%-- Supervisor / Admin --%>
                                        <div class="col-md-6">
                                            <div class="attribute-group">
                                                <label class="info-label">Contact Number</label>
                                                <div class="view-mode info-value">${not empty profileDetails.phoneNum ? profileDetails.phoneNum : 'Not Set'}</div>
                                                <input type="text" name="phone" class="form-control edit-mode" value="${profileDetails.phoneNum}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="attribute-group">
                                                <label class="info-label">Academic Position</label>
                                                <div class="view-mode info-value">${profileDetails.position}</div>
                                                <input type="text" name="position" class="form-control edit-mode" value="${profileDetails.position}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="attribute-group" style="border-left-color: #cbd5e1;">
                                                <label class="info-label">Department Code</label>
                                                <div class="info-value">${profileDetails.departmentId}</div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="edit-mode mt-4 text-end">
                                <button type="submit" class="btn btn-success rounded-pill px-5 shadow-sm">
                                    <i class="bi bi-check-circle me-2"></i>Save Profile Changes
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>