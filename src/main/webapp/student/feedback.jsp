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
        
        @keyframes feedbackSlideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .feedback-card:nth-child(1) { animation-delay: 0.1s; }
        .feedback-card:nth-child(2) { animation-delay: 0.2s; }
        .feedback-card:nth-child(3) { animation-delay: 0.3s; }
        .feedback-card:nth-child(4) { animation-delay: 0.4s; }
        .feedback-card:nth-child(n+5) { animation-delay: 0.5s; }
        .feedback-card {
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background: white;
            border-radius: 12px; /* Slightly rounder for modern look */
        }
        
        @keyframes pulseGreen {
            0% { box-shadow: 0 0 0 0 rgba(0, 200, 81, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(0, 200, 81, 0); }
            100% { box-shadow: 0 0 0 0 rgba(0, 200, 81, 0); }
        }

        .badge-dot {
            animation: pulseGreen 2s infinite;
        }

        .animate-feedback {
            opacity: 0;
            animation: feedbackSlideIn 0.5s ease-out forwards;
        }
        .feedback-card { 
            background: white; border-radius: 10px; padding: 20px; margin-bottom: 15px; 
            border-left: 5px solid #ccc; transition: all 0.3s ease;
        }
        .feedback-card.unread { border-left-color: #00C851; }
        .badge-dot { height: 10px; width: 10px; background-color: #00C851; border-radius: 50%; display: inline-block; margin-left: 5px; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function markAsRead(button, feedbackId, date, week, content) {
            const card = button.closest('.feedback-card');

            // Add a temporary subtle highlight during the request
            card.style.backgroundColor = "#f0fff4";

            fetch('StudentFeedbackServlet?action=markRead&id=' + feedbackId)
                .then(response => {
                    if (response.ok) {
                        // Smoothly remove unread styles
                        card.classList.remove('unread');
                        card.style.backgroundColor = "white";

                        const statusDiv = card.querySelector('.status-text');
                        statusDiv.style.opacity = '0';

                        setTimeout(() => {
                            statusDiv.innerHTML = 'Read';
                            statusDiv.classList.replace('text-success', 'text-muted');
                            statusDiv.style.opacity = '1';

                            // FIX: Update button to function as View Details with parameters
                            button.classList.replace('btn-primary', 'btn-outline-secondary');
                            button.innerText = "View Details";

                            // We use a wrapper function to pass the variables
                            button.onclick = function() { 
                                viewDetails(date, week, content); 
                            };
                        }, 300);
                    }
                });
        }

        function viewDetails(date, week, content) {
            // Fill the modal with data
            document.getElementById('modalDate').innerText = date;
            document.getElementById('modalWeek').innerText = 'Week ' + week;
            document.getElementById('modalContent').innerText = content;

            // Show the modal using Bootstrap's API
            var modalEl = document.getElementById('feedbackModal');
            var myModal = bootstrap.Modal.getOrCreateInstance(modalEl); 
            myModal.show();
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
        <div class="feedback-card animate-feedback ${f.status == 'Unread' ? 'unread' : ''} shadow-sm">
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
                                    onclick="markAsRead(this, '${f.feedbackId}', '${f.dateGiven}', '${f.weekNumber}', '${f.content}')">
                                Check As Read
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-outline-secondary btn-sm px-4 rounded-pill w-100" 
                                    onclick="viewDetails('${f.dateGiven}', '${f.weekNumber}', '${f.content}')">
                                View Details
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
<div class="modal fade" id="feedbackModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
            <div class="modal-header bg-light" style="border-radius: 15px 15px 0 0;">
                <h5 class="modal-title fw-bold text-dark">
                    <i class="bi bi-chat-left-text text-primary me-2"></i>Feedback Details
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <small class="text-uppercase fw-bold text-muted" style="font-size: 0.7rem;">Date Provided</small>
                    <p id="modalDate" class="fw-medium text-dark mb-0"></p>
                </div>
                <div class="mb-3">
                    <small class="text-uppercase fw-bold text-muted" style="font-size: 0.7rem;">Week Number</small>
                    <p><span id="modalWeek" class="badge bg-primary bg-opacity-10 text-primary px-3"></span></p>
                </div>
                <hr class="opacity-10">
                <div>
                    <small class="text-uppercase fw-bold text-muted" style="font-size: 0.7rem;">Supervisor's Comments</small>
                    <div id="modalContent" class="mt-2 p-3 bg-light rounded text-secondary" style="white-space: pre-wrap; line-height: 1.6;"></div>
                </div>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-secondary px-4 rounded-pill" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>