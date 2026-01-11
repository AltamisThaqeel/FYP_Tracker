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
        .week-tabs .nav-link { border: 1px solid #e9ecef; margin-bottom: 8px; border-radius: 8px; text-align: center; color: #495057; background: white; cursor: pointer; }
        .week-tabs .nav-link.active { background-color: #2563EB; color: white; border-color: #2563EB; }
        .task-input { border: none; background: #f1f3f5; padding: 15px; border-radius: 8px; width: 100%; }
        .milestone-item { background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px; display: flex; align-items: center; }
    </style>

    <script>
        // Triggered when the toggle switch is clicked
        function toggleStatus(checkbox, milestoneId) {
            const status = checkbox.checked ? 'Completed' : 'Not Started';
            const projectId = "${currentProject.projectId}";
            const weekNum = "${selectedWeek}";
            
            // Redirect to Servlet to update status in DB
            window.location.href = "MilestoneServlet?action=complete&milestoneId=" + milestoneId + 
                                   "&status=" + status + "&projectId=" + projectId + "&weekNum=" + weekNum;
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
        <a href="../profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="feedback.jsp" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
        <a href="../LoginServlet" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <h3 class="mb-4">Project Milestone</h3>
    
    <div class="mb-4">
    <label class="small fw-bold text-muted mb-2">Select Project</label>
    <select class="form-select shadow-sm border-0 p-3" 
            style="background-color: #ffffff; border-radius: 10px; cursor: pointer;"
            onchange="window.location.href='${pageContext.request.contextPath}/MilestoneServlet?projectId=' + this.value">

        <c:forEach items="${projectList}" var="p">
            <option value="${p.projectId}" ${p.projectId == projectId ? 'selected' : ''}>
                ${p.projectName} </option>
        </c:forEach>

        <c:if test="${empty projectList}">
            <option disabled>No projects found</option>
        </c:if>
    </select>
    </div>
    <div class="row">
        <div class="col-md-2">
            <div class="nav flex-column nav-pills week-tabs">
                <c:forEach var="i" begin="1" end="${currentProject.numOfWeeks}">
                    <a href="MilestoneServlet?projectId=${currentProject.projectId}&week=${i}" 
                       class="nav-link ${selectedWeek == i ? 'active' : ''}">
                       Week ${i}
                    </a>
                </c:forEach>
            </div>
        </div>
        
        <div class="col-md-10">
            <div class="bg-white p-4 rounded shadow-sm">
                <h5 class="fw-bold mb-3">${currentProject.title}</h5>
                
                <form action="MilestoneServlet" method="POST" class="mb-4">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="projectId" value="${currentProject.projectId}">
                    <input type="hidden" name="weekNum" value="${selectedWeek}">
                    
                    <label class="fw-bold small mb-2">Add New Task for Week ${selectedWeek}</label>
                    <div class="d-flex gap-2">
                        <input type="text" name="taskDesc" class="task-input" placeholder="e.g., Design ERD Diagram..." required>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Add Task</button>
                    </div>
                </form>

                <h6 class="fw-bold mb-3">Milestones for Week ${selectedWeek}</h6>
                
                <div id="milestoneList">
                    <c:choose>
                        <c:when test="${empty milestones}">
                            <p class="text-muted italic">No tasks added for this week yet.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${milestones}" var="m">
                                <div class="milestone-item shadow-sm">
                                    <i class="bi bi-caret-right-fill text-muted me-3"></i>
                                    <span class="flex-grow-1">${m.description}</span>
                                    
                                    <span class="badge ${m.status == 'Completed' ? 'bg-success' : 'bg-light text-secondary'} me-3">
                                        ${m.status}
                                    </span>
                                    
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" 
                                               ${m.status == 'Completed' ? 'checked' : ''}
                                               onchange="toggleStatus(this, '${m.milestoneId}')">
                                    </div>
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