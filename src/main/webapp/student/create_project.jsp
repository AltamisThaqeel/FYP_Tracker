<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.fyp.model.Account"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Security Check
    Account user = (Account) session.getAttribute("user");
    if (user == null) { response.sendRedirect("../login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Project - FYP Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #F8F9FA; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 250px; height: 100vh; position: fixed; background-color: #FFFFFF; border-right: 1px solid #eee; padding: 20px; }
        .nav-link { color: #6C757D; padding: 10px 15px; margin-bottom: 5px; border-radius: 10px; font-weight: 500; text-decoration: none; }
        .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
        .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        .form-control, .form-select { background-color: #f8f9fa; border: 1px solid #dee2e6; height: 45px; }

        /* --- NEW CSS FOR AUTO-EXPANDING TEXTAREAS --- */
        textarea.auto-expand {
            resize: none;       /* Disable manual resize handle */
            overflow-y: hidden; /* Hide scrollbar */
            min-height: 150px;  /* Minimum starting height */
            transition: height 0.2s ease;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand text-primary fw-bold fs-5 mb-4">
        <i class="bi bi-mortarboard-fill"></i> FYP Tracker
    </div>
    <nav class="nav flex-column">
        <a href="${pageContext.request.contextPath}/StudentDashboardServlet" class="nav-link"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/CreateProjectServlet" class="nav-link active"><i class="bi bi-folder-fill me-2"></i> My Project</a>
        <a href="${pageContext.request.contextPath}/MilestoneServlet" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="${pageContext.request.contextPath}/StudentFeedbackServlet" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Supervisor Feedback</a>
        <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    
    <div class="d-flex justify-content-between align-items-center mb-4 p-3 bg-white rounded shadow-sm">
        <div class="d-flex align-items-center gap-3">
            <h5 class="mb-0 fw-bold text-dark">Selected Project:</h5>
            <select class="form-select w-auto border-0 bg-light fw-bold text-primary" 
                    onchange="window.location.href='CreateProjectServlet?projectId='+this.value">
                <option value="" disabled selected>Select a project...</option>
                <c:choose>
                    <c:when test="${empty projectList}">
                        <option disabled>No projects found</option>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${projectList}" var="p">
                            <option value="${p.projectId}" ${p.projectId == currentProject.projectId ? 'selected' : ''}>
                                ${p.projectName}
                            </option>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </select>
        </div>
        <a href="${pageContext.request.contextPath}/CreateProjectServlet?action=new" class="btn btn-outline-primary px-4">
            <i class="bi bi-plus-lg me-2"></i>Create New Project
        </a>
    </div>

    <div class="card border-0 shadow-sm p-4">
        <h5 class="text-muted mb-4 border-bottom pb-3">
            ${currentProject != null ? 'Edit Existing Project' : 'Submit New Project Proposal'}
        </h5>
        
        <form action="${pageContext.request.contextPath}/CreateProjectServlet" method="POST">
            
            <c:if test="${currentProject != null}">
                <input type="hidden" name="projectId" value="${currentProject.projectId}">
            </c:if>

            <div class="row g-3">
                <div class="col-md-12">
                    <label class="form-label small fw-bold text-secondary">Project Title</label>
                    <input type="text" name="title" class="form-control" 
                           value="${currentProject.projectName}" placeholder="Enter title..." required>
                </div>

                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Category / Research Area</label>
                    <select name="category" class="form-select" required>
                        <option value="" disabled ${currentProject == null ? 'selected' : ''}>Select a category</option>
                        <option value="Machine Learning" ${currentProject.categoryName == 'Machine Learning' ? 'selected' : ''}>Machine Learning</option>
                        <option value="Internet of Things (IoT)" ${currentProject.categoryName == 'Internet of Things (IoT)' ? 'selected' : ''}>Internet of Things (IoT)</option>
                        <option value="Web Development" ${currentProject.categoryName == 'Web Development' ? 'selected' : ''}>Web Development</option>
                        <option value="Cybersecurity" ${currentProject.categoryName == 'Cybersecurity' ? 'selected' : ''}>Cybersecurity</option>
                        <option value="Data Science" ${currentProject.categoryName == 'Data Science' ? 'selected' : ''}>Data Science</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Project Type</label>
                    <select name="type" class="form-select" required>
                        <option value="Individual" ${currentProject.projectType == 'Individual' ? 'selected' : ''}>Individual Project</option>
                        <option value="Group" ${currentProject.projectType == 'Group' ? 'selected' : ''}>Group Project</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-bold text-secondary">Start Date</label>
                    <input type="date" name="startDate" class="form-control" value="${currentProject.startDate}" required>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-bold text-secondary">End Date</label>
                    <input type="date" name="endDate" class="form-control" value="${currentProject.endDate}" required>
                </div>

                <div class="col-md-4">
                    <label class="form-label small fw-bold text-secondary">Contact Phone</label>
                    <input type="text" name="phone" class="form-control" value="${currentProject.contactPhone}" placeholder="+6012..." required>
                </div>

                <div class="col-12">
                    <label class="form-label small fw-bold text-secondary">Project Description</label>
                    <textarea name="desc" class="form-control auto-expand" rows="6" 
                              placeholder="Describe the background..." 
                              oninput="autoResize(this)" required>${currentProject.description}</textarea>
                </div>

                <div class="col-12">
                    <label class="form-label small fw-bold text-secondary">Project Objectives</label>
                    <textarea name="objectives" class="form-control auto-expand" rows="6" 
                              placeholder="List your key goals here..." 
                              oninput="autoResize(this)" required>${currentProject.objective}</textarea>
                </div>

                <div class="col-12 text-end mt-4">
                    <c:choose>
                        <c:when test="${currentProject != null}">
                            <a href="${pageContext.request.contextPath}/CreateProjectServlet?action=new" class="btn btn-light text-muted me-2">Cancel</a>
                            <button type="submit" class="btn btn-warning px-5 rounded-pill text-white">Save Changes</button>
                        </c:when>
                        <c:otherwise>
                            <button type="reset" class="btn btn-light text-danger me-2">Clear Form</button>
                            <button type="submit" class="btn btn-primary px-5 rounded-pill">Submit Application</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // Function to calculate new height based on content
    function autoResize(textarea) {
        textarea.style.height = 'auto'; // Reset height momentarily to get correct scrollHeight
        textarea.style.height = textarea.scrollHeight + 'px'; // Set to full content height
    }

    // Run on page load to resize boxes if data is already inside (Edit Mode)
    window.addEventListener('load', function() {
        const textareas = document.querySelectorAll('.auto-expand');
        textareas.forEach(textarea => {
            autoResize(textarea);
        });
    });
</script>

</body>
</html>