<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Milestones - FYP Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #F8F9FA; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 250px; height: 100vh; position: fixed; background-color: #FFFFFF; border-right: 1px solid #eee; padding: 20px; }
        .sidebar-brand { font-weight: bold; font-size: 1.2rem; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .nav-link { color: #6C757D; padding: 10px 15px; margin-bottom: 5px; border-radius: 10px; font-weight: 500; text-decoration: none; }
        .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
        .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        
        /* --- DESIGN UPDATES --- */
        .project-selector-bar { background: white; padding: 15px 25px; border-radius: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; }
        
        .week-tabs .nav-link { 
            border: none; margin-bottom: 8px; border-radius: 10px; 
            text-align: left; padding: 12px 20px; 
            color: #6c757d; background: transparent; font-weight: 600; 
            transition: all 0.2s ease;
        }
        .week-tabs .nav-link:hover { background-color: #e9ecef; color: #2563EB; }
        .week-tabs .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        
        .task-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .task-input { border: 2px solid #f1f3f5; background: #f8f9fa; padding: 12px 20px; border-radius: 30px; width: 100%; transition: 0.3s; }
        .task-input:focus { border-color: #2563EB; background: white; outline: none; }
        
        .milestone-item { 
            background: #ffffff; padding: 15px 20px; border-radius: 12px; margin-bottom: 12px; 
            border: 1px solid #f1f3f5; display: flex; align-items: center; 
            transition: transform 0.2s ease;
        }
        .milestone-item:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .milestone-item.completed { border-left: 5px solid #198754; background-color: #f8fffb; }
    </style>

    <script>
        // Updated Function: Sets the hidden input value and submits the form
        function submitStatusUpdate(checkbox, milestoneId) {
            const statusInput = document.getElementById('status_input_' + milestoneId);
            statusInput.value = checkbox.checked ? 'Completed' : 'Not Started';
            
            // Submit the form that wraps this checkbox
            checkbox.form.submit();
        }
    </script>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand text-primary">
        <i class="bi bi-mortarboard-fill"></i> FYP Tracker
    </div>
    <nav class="nav flex-column">
        <a href="${pageContext.request.contextPath}/StudentDashboardServlet" class="nav-link"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/CreateProjectServlet" class="nav-link"><i class="bi bi-folder-fill me-2"></i> My Project</a>
        <a href="${pageContext.request.contextPath}/MilestoneServlet" class="nav-link active"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="${pageContext.request.contextPath}/StudentFeedbackServlet" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Supervisor Feedback</a>
        <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    
    <div class="project-selector-bar mb-4">
        <div class="d-flex align-items-center gap-3">
            <div class="bg-primary bg-opacity-10 p-2 rounded-circle text-primary">
                <i class="bi bi-folder2-open fs-5"></i>
            </div>
            <div>
                <small class="text-muted fw-bold d-block text-uppercase" style="font-size: 0.75rem;">Current Workspace</small>
                <select class="form-select border-0 bg-transparent fw-bold text-dark p-0 shadow-none" 
                        style="cursor: pointer; font-size: 1.1rem;"
                        onchange="window.location.href='${pageContext.request.contextPath}/MilestoneServlet?projectId=' + this.value">
                    
                    <c:forEach items="${projectList}" var="p">
                        <option value="${p.projectId}" ${p.projectId == projectId ? 'selected' : ''}>
                            ${p.projectTitle}
                        </option>
                    </c:forEach>
                    
                    <c:if test="${empty projectList}">
                        <option disabled>No projects found</option>
                    </c:if>
                </select>
            </div>
        </div>
        <div>
            <span class="badge bg-primary rounded-pill px-3 py-2">
                <i class="bi bi-calendar-week me-1"></i> Week ${selectedWeek}
            </span>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-md-3 col-lg-2">
            <h6 class="text-muted fw-bold mb-3 px-2 small">TIMELINE</h6>
            <div class="nav flex-column nav-pills week-tabs">
                <c:forEach var="i" begin="1" end="${currentProject.numOfWeeks}">
                    <a href="${pageContext.request.contextPath}/MilestoneServlet?projectId=${currentProject.projectId}&week=${i}" 
                       class="nav-link ${selectedWeek == i ? 'active' : ''} d-flex justify-content-between align-items-center">
                       <span>Week ${i}</span>
                       <c:if test="${selectedWeek == i}">
                           <i class="bi bi-chevron-right small"></i>
                       </c:if>
                    </a>
                </c:forEach>
            </div>
        </div>
        
        <div class="col-md-9 col-lg-10">
            <div class="task-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold m-0 text-dark">Tasks & Deliverables</h5>
                    <span class="text-muted small">
                        <i class="bi bi-check2-circle text-success"></i> Auto-saved
                    </span>
                </div>

                <form action="${pageContext.request.contextPath}/MilestoneServlet" method="POST" class="mb-4">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="projectId" value="${currentProject.projectId}">
                    <input type="hidden" name="weekNum" value="${selectedWeek}">
                    
                    <div class="d-flex gap-2">
                        <input type="text" name="taskDesc" class="task-input" placeholder="Type a new task and press Enter..." required>
                        <button type="submit" class="btn btn-primary rounded-circle shadow-sm" style="width: 45px; height: 45px;">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                    </div>
                </form>

                <div id="milestoneList">
                    <c:choose>
                        <c:when test="${empty milestones}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-clipboard-x display-4 opacity-25"></i>
                                <p class="mt-3 small">No tasks found for Week ${selectedWeek}.<br>Add one above to get started!</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${milestones}" var="m">
                                <div class="milestone-item shadow-sm ${m.status == 'Completed' ? 'completed' : ''}">
                                    
                                    <form action="${pageContext.request.contextPath}/MilestoneServlet" method="POST" style="display:inline; margin:0;">
                                        <input type="hidden" name="action" value="complete">
                                        <input type="hidden" name="milestoneId" value="${m.milestoneId}">
                                        <input type="hidden" name="projectId" value="${currentProject.projectId}">
                                        <input type="hidden" name="weekNum" value="${selectedWeek}">
                                        <input type="hidden" name="status" id="status_input_${m.milestoneId}" value="">
                                        
                                        <div class="form-check form-switch me-3">
                                            <input class="form-check-input" type="checkbox" style="cursor: pointer; width: 40px; height: 20px;"
                                                   ${m.status == 'Completed' ? 'checked' : ''}
                                                   onchange="submitStatusUpdate(this, '${m.milestoneId}')">
                                        </div>
                                    </form>
                                    
                                    <span class="flex-grow-1 ${m.status == 'Completed' ? 'text-decoration-line-through text-muted' : 'fw-medium text-dark'}">
                                        ${m.description}
                                    </span>
                                    
                                    <c:choose>
                                        <c:when test="${m.status == 'Completed'}">
                                            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">
                                                <i class="bi bi-check-lg me-1"></i> Completed
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3">
                                                <i class="bi bi-x-lg me-1"></i> Not Started
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>