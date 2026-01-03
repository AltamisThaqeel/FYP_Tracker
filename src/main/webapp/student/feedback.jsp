<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback - FYP Tracker</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #F8F9FA; font-family: 'Segoe UI', sans-serif; }
        
        /* Sidebar Styling */
        .sidebar { width: 250px; height: 100vh; position: fixed; background-color: #FFFFFF; border-right: 1px solid #eee; padding: 20px; }
        .sidebar-brand { font-weight: bold; font-size: 1.2rem; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .nav-link { color: #6C757D; padding: 10px 15px; margin-bottom: 5px; border-radius: 10px; font-weight: 500; text-decoration: none; }
        .nav-link:hover { background-color: #f1f5f9; color: #2563EB; }
        .nav-link.active { background-color: #2563EB; color: white; box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2); }
        .main-content { margin-left: 250px; padding: 30px; }
        
        /* Feedback Specifics */
        .feedback-card { 
            background: white; border-radius: 10px; padding: 20px; margin-bottom: 15px; 
            border-left: 5px solid #ccc; /* Default Read Color */
            transition: all 0.3s ease;
        }
        .feedback-card.unread {
            border-left-color: #00C851; /* Green for Unread */
            background-color: #fff;
        }
        .badge-dot { 
            height: 10px; width: 10px; background-color: #00C851; border-radius: 50%; display: inline-block; margin-left: 5px; 
            opacity: 0; transition: opacity 0.3s;
        }
        .feedback-card.unread .badge-dot { opacity: 1; }
        
        /* Animation for removing item */
        .fade-out { opacity: 0; transform: translateX(20px); }
    </style>

    <script>
        function markAsRead(button) {
            // Find the parent card
            const card = button.closest('.feedback-card');
            
            // 1. Change Visual Style (Border color)
            card.classList.remove('unread');
            
            // 2. Update Status Text
            const statusDiv = card.querySelector('.status-text');
            statusDiv.innerHTML = 'Read';
            statusDiv.classList.remove('text-success');
            statusDiv.classList.add('text-muted');
            
            // 3. Change Button to "View" (Disabled for demo)
            button.classList.remove('btn-primary');
            button.classList.add('btn-outline-secondary');
            button.innerText = "View";
            button.onclick = function() { viewDetails(); }; // Change action
            
            // Optional: Show simple notification
            // alert("Marked as read");
        }

        function viewDetails() {
            alert("Opening detailed feedback view... (This would open a modal in a full app)");
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
        <a href="milestones.jsp" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="feedback.jsp" class="nav-link active"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
        <a href="logout.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <h3 class="mb-4">Feedback</h3>
    
    <div class="feedback-card unread shadow-sm">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h6 class="fw-bold mb-1">
                    Date: 12/12/2025 | Sunday 
                    <span class="badge bg-light text-dark ms-2 border">Week 30</span>
                </h6>
                <p class="mb-2 mt-2 text-secondary">
                    The progress is good overall, and most features are working well. However, the database connection seems unstable during high load...
                </p>
            </div>
            <div class="text-end" style="min-width: 140px;">
                <div class="status-text text-success small fw-bold mb-2">
                    Unread <span class="badge-dot"></span>
                </div>
                <button class="btn btn-primary btn-sm px-4 rounded-pill w-100" onclick="markAsRead(this)">
                    Check As Read
                </button>
            </div>
        </div>
    </div>

    <div class="feedback-card shadow-sm">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h6 class="fw-bold mb-1 text-muted">
                    Date: 05/12/2025 | Sunday 
                    <span class="badge bg-light text-muted ms-2 border">Week 29</span>
                </h6>
                <p class="mb-2 mt-2 text-muted">
                    Please refine the ERD diagram before proceeding to implementation. The relationship between 'User' and 'Project' needs to be 1:M.
                </p>
            </div>
            <div class="text-end" style="min-width: 140px;">
                <div class="status-text text-muted small fw-bold mb-2">Read</div>
                <button class="btn btn-outline-secondary btn-sm px-4 rounded-pill w-100" onclick="viewDetails()">
                    View
                </button>
            </div>
        </div>
    </div>

    <div class="feedback-card shadow-sm">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h6 class="fw-bold mb-1 text-muted">
                    Date: 28/11/2025 | Sunday 
                    <span class="badge bg-light text-muted ms-2 border">Week 28</span>
                </h6>
                <p class="mb-2 mt-2 text-muted">
                    Proposal approved. You may proceed with the requirement gathering phase.
                </p>
            </div>
            <div class="text-end" style="min-width: 140px;">
                <div class="status-text text-muted small fw-bold mb-2">Read</div>
                <button class="btn btn-outline-secondary btn-sm px-4 rounded-pill w-100" onclick="viewDetails()">
                    View
                </button>
            </div>
        </div>
    </div>
</div>

</body>
</html>