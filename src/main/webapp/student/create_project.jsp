<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Project - FYP Tracker</title>
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
        
        /* Form Specifics */
        .form-control, .form-select { background-color: #f8f9fa; border: 1px solid #dee2e6; height: 45px; }
        .form-control:focus, .form-select:focus { background-color: #fff; border-color: #2563EB; box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25); }
    </style>

    <script>
        function handleProjectSave(event) {
            event.preventDefault(); // Stop server submit
            
            // Get values for demo
            const title = document.querySelector('input[name="title"]').value;
            const supervisor = document.querySelector('select[name="supervisor"]').value;
            
            // Simulate processing time
            const btn = document.querySelector('.btn-save');
            const originalText = btn.innerText;
            btn.innerText = "Saving...";
            
            setTimeout(() => {
                alert("Project details updated successfully!\n\nTitle: " + title + "\nSupervisor: " + supervisor);
                btn.innerText = originalText;
            }, 500);
        }

        function createNew() {
            if(confirm("Start a new project application? This will clear current data.")) {
                document.querySelector('form').reset();
                document.querySelector('input[name="title"]').focus();
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
        <a href="student_dashboard.jsp" class="nav-link"><i class="bi bi-grid-fill me-2"></i> Dashboard</a>
        <a href="create_project.jsp" class="nav-link active"><i class="bi bi-folder-fill me-2"></i> My Project</a>
        <a href="milestones.jsp" class="nav-link"><i class="bi bi-list-check me-2"></i> Milestones</a>
        <a href="profile.jsp" class="nav-link"><i class="bi bi-person-fill me-2"></i> User Profile</a>
        <a href="feedback.jsp" class="nav-link"><i class="bi bi-chat-left-text-fill me-2"></i> Feedback</a>
        <a href="login.jsp" class="nav-link mt-5 text-danger border-top pt-3"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </nav>
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">Project Details</h3>
        <button class="btn btn-outline-primary rounded-pill px-4" onclick="createNew()">
            <i class="bi bi-plus-lg me-2"></i> Create New Project
        </button>
    </div>

    <div class="card border-0 shadow-sm p-4">
        <h5 class="text-muted mb-4 border-bottom pb-3">View and edit project information</h5>
        
        <form onsubmit="handleProjectSave(event)">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Project Title</label>
                    <input type="text" name="title" class="form-control" value="Food Classification Using Machine Learning" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Supervisor</label>
                    <select name="supervisor" class="form-select">
                        <option>Dr. Sarah Johnson</option>
                        <option>Dr. Amin Bin Abdul</option>
                        <option>Prof. Madya Dr. Azman</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Category / Research Area</label>
                    <select name="category" class="form-select">
                        <option>Machine Learning</option>
                        <option>Internet of Things (IoT)</option>
                        <option>Web Development</option>
                        <option>Cybersecurity</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Project Type</label>
                    <input type="text" class="form-control" value="Individual Project" readonly>
                </div>

                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Start Date</label>
                    <input type="date" name="startDate" class="form-control" value="2025-12-10">
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">End Date</label>
                    <input type="date" name="endDate" class="form-control" value="2026-03-12">
                </div>
                
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Duration (Weeks)</label>
                    <input type="text" class="form-control" value="14 Weeks" readonly>
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-secondary">Contact Number</label>
                    <input type="text" name="phone" class="form-control" value="+6012371231">
                </div>

                <div class="col-12">
                    <label class="form-label small fw-bold text-secondary">Project Description</label>
                    <textarea name="desc" class="form-control" rows="3">This project focuses on developing a machine learning model capable of classifying different types of food based on images. It utilizes Convolutional Neural Networks (CNN) to achieve high accuracy.</textarea>
                </div>

                <div class="col-12">
                    <label class="form-label small fw-bold text-secondary">Project Objectives</label>
                    <textarea name="objectives" class="form-control" rows="4">• To collect and preprocess a food image dataset.
• To develop a machine learning model for food classification.
• To evaluate the model performance using accuracy and F1-score.
• To deploy the model via a web interface.</textarea>
                </div>

                <div class="col-12 text-end mt-4">
                    <button type="button" class="btn btn-light text-danger me-2">Cancel Changes</button>
                    <button type="submit" class="btn btn-primary px-5 rounded-pill btn-save">Save Changes</button>
                </div>
            </div>
        </form>
    </div>
</div>

</body>
</html>