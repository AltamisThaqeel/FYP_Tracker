<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback - FYP Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f3f4f6; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 250px; height: 100vh; position: fixed; background-color: #FFFFFF; border-right: 1px solid #eee; padding: 20px; }
        .sidebar-brand { font-weight: bold; font-size: 1.2rem; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .nav-link { color: #6C757D; padding: 10px 15px; margin-bottom: 5px; border-radius: 10px; font-weight: 500; text-decoration: none; }
        .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
        .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        
        .feedback-card { 
            background: white; border-radius: 10px; padding: 20px; margin-bottom: 15px; 
            border-left: 5px solid #ccc; transition: all 0.3s ease;
        }
        .feedback-card.unread { border-left-color: #00C851; }
        .badge-dot { height: 10px; width: 10px; background-color: #00C851; border-radius: 50%; display: inline-block; margin-left: 5px; }
    </style>

    <script>
        function markAsRead(button, feedbackId) {
            // Call the servlet to update the database status
            fetch('StudentFeedbackServlet?action=markRead&id=' + feedbackId)
                .then(response => {
                    if (response.ok) {
                        const card = button.closest('.feedback-card');
                        card.classList.remove('unread');
                        
                        const statusDiv = card.querySelector('.status-text');
                        statusDiv.innerHTML = 'Read';
                        statusDiv.classList.replace('text-success', 'text-muted');
                        
                        button.classList.replace('btn-primary', 'btn-outline-secondary');
                        button.innerText = "View";
                        button.onclick = function() { viewDetails(); };
                    }
                });
        }

        function viewDetails() {
            alert("Viewing full feedback details...");
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
        <a href="${pageContext.request.contextPath}/MilestoneServlet" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="${pageContext.request.contextPath}/StudentFeedbackServlet" class="nav-link active"><i class="bi bi-chat-left-text-fill me-2"></i> Supervisor Feedback</a>
        <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <h3 class="mb-4">Feedback from Supervisor</h3>
    
    <c:if test="${empty feedbackList}">
        <div class="alert alert-info">No feedback received yet.</div>
    </c:if>

    <c:forEach var="f" items="${feedbackList}">
        <div class="feedback-card ${f.status == 'Unread' ? 'unread' : ''} shadow-sm">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <h6 class="fw-bold mb-1 ${f.status == 'Read' ? 'text-muted' : ''}">
                        Date: ${f.dateGiven}
                        <span class="badge bg-light text-dark ms-2 border">Week ${f.weekNumber}</span>
                    </h6>
                    <p class="mb-2 mt-2 ${f.status == 'Read' ? 'text-muted' : 'text-secondary'}">
                        ${f.content}
                    </p>
                </div>
                <div class="text-end" style="min-width: 140px;">
                    <div class="status-text ${f.status == 'Unread' ? 'text-success' : 'text-muted'} small fw-bold mb-2">
                        ${f.status} <c:if test="${f.status == 'Unread'}"><span class="badge-dot"></span></c:if>
                    </div>
                    
                    <c:choose>
                        <c:when test="${f.status == 'Unread'}">
                            <button class="btn btn-primary btn-sm px-4 rounded-pill w-100" 
                                    onclick="markAsRead(this, ${f.feedbackId})">
                                Check As Read
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-outline-secondary btn-sm px-4 rounded-pill w-100" 
                                    onclick="viewDetails()">
                                View
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

</body>
</html>