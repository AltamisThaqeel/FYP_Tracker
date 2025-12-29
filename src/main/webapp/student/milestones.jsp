<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Milestones - FYP Tracker</title>
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
        
        /* Milestone Specifics */
        .week-tabs .nav-link {
            border: 1px solid #e9ecef; margin-bottom: 8px; border-radius: 8px; 
            text-align: center; color: #495057; background: white; cursor: pointer;
        }
        .week-tabs .nav-link:hover { background-color: #f8f9fa; }
        .week-tabs .nav-link.active {
            background-color: #2563EB; color: white; border-color: #2563EB;
        }
        .task-input { border: none; background: #f1f3f5; padding: 15px; border-radius: 8px; width: 100%; }
        .milestone-item { background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px; display: flex; align-items: center; }
        
        /* Animation for new tasks */
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .new-task { animation: fadeIn 0.3s ease-out; }
    </style>

    <script>
        // Function to Add a New Task to the list
        function addTask() {
            const input = document.getElementById("newTaskInput");
            const taskText = input.value.trim();
            
            if (taskText === "") {
                alert("Please enter a task description.");
                return;
            }

            // Create the new milestone HTML structure
            const listContainer = document.getElementById("milestoneList");
            const newItem = document.createElement("div");
            newItem.className = "milestone-item shadow-sm new-task";
            newItem.innerHTML = `
                <i class="bi bi-caret-right-fill text-muted me-3"></i>
                <span class="flex-grow-1">${taskText}</span>
                <span class="badge bg-light text-secondary me-3">Not Started</span>
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" onchange="toggleStatus(this)">
                </div>
            `;

            // Add to list and clear input
            listContainer.appendChild(newItem);
            input.value = "";
        }

        // Function to toggle status text when switch is clicked
        function toggleStatus(checkbox) {
            const badge = checkbox.closest('.milestone-item').querySelector('.badge');
            if (checkbox.checked) {
                badge.className = "badge bg-success me-3";
                badge.innerText = "Completed";
            } else {
                badge.className = "badge bg-light text-secondary me-3";
                badge.innerText = "Not Started";
            }
        }

        // Function to switch active week (Visual only for demo)
        function selectWeek(element) {
            document.querySelectorAll('.week-tabs .nav-link').forEach(el => el.classList.remove('active'));
            element.classList.add('active');
            // In a real app, this would fetch that week's data
        }
    </script>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand text-primary">
        <i class="bi bi-mortarboard-fill"></i> FYP Tracker
    </div>
    <nav class="nav flex-column">
        <a href="student_dashboard.jsp" class="nav-link"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="create_project.jsp" class="nav-link"><i class="bi bi-folder-fill me-2"></i> My Project</a>
        <a href="milestones.jsp" class="nav-link active"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="feedback.jsp" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
        <a href="login.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <h3 class="mb-4">Project Milestone</h3>
    
    <div class="row">
        <div class="col-md-2">
            <div class="nav flex-column nav-pills week-tabs">
                <a class="nav-link" onclick="selectWeek(this)">Week 1</a>
                <a class="nav-link" onclick="selectWeek(this)">Week 2</a>
                <a class="nav-link" onclick="selectWeek(this)">Week 3</a>
                <a class="nav-link active" onclick="selectWeek(this)">Week 4</a>
                <a class="nav-link" onclick="selectWeek(this)">Week 5</a>
                <a class="nav-link" onclick="selectWeek(this)">Week 6</a>
            </div>
        </div>
        
        <div class="col-md-10">
            <div class="bg-white p-4 rounded shadow-sm">
                <h5 class="fw-bold mb-3">Food Classification Using Machine Learning</h5>
                
                <div class="mb-4">
                    <label class="fw-bold small mb-2">Add New Task</label>
                    <div class="d-flex gap-2">
                        <input type="text" id="newTaskInput" class="task-input" placeholder="e.g., Design ERD Diagram...">
                        <button onclick="addTask()" class="btn btn-primary rounded-pill px-4">Add Task</button>
                    </div>
                </div>

                <h6 class="fw-bold mb-3">Milestones for Week 4</h6>
                
                <div id="milestoneList">
                    <div class="milestone-item shadow-sm">
                        <i class="bi bi-caret-right-fill text-muted me-3"></i>
                        <span class="flex-grow-1">System Implementation</span>
                        <span class="badge bg-light text-secondary me-3">Not Started</span>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" onchange="toggleStatus(this)">
                        </div>
                    </div>

                    <div class="milestone-item shadow-sm">
                        <i class="bi bi-caret-right-fill text-muted me-3"></i>
                        <span class="flex-grow-1">Database Configuration</span>
                        <span class="badge bg-light text-secondary me-3">Not Started</span>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" onchange="toggleStatus(this)">
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

</body>
</html>