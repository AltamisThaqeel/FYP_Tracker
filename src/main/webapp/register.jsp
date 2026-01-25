<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FYP Tracker - Create Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            overflow-x: hidden;
        }

        .main-container {
            height: 100vh;
            width: 100%;
        }

        /* --- LEFT PANEL (Blue Side) --- */
        .left-panel {
            background-color: #2563EB; /* Bright Blue */
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px;
            position: relative;
        }

        .illustration-container {
            background: rgba(255, 255, 255, 0.1); /* Subtle transparent white box behind image */
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .illustration-img {
            max-width: 80%;
            height: auto;
            /* Placeholder styling if image is missing */
            filter: drop-shadow(0 10px 20px rgba(0,0,0,0.1));
        }

        .left-title { font-weight: 700; font-size: 1.8rem; margin-bottom: 10px; }
        .left-subtitle { font-size: 0.95rem; opacity: 0.8; max-width: 350px; text-align: center; margin-bottom: 30px; line-height: 1.6; }

        .feature-icons { display: flex; gap: 30px; opacity: 0.9; }
        .feature-item { text-align: center; font-size: 0.8rem; }
        .feature-item i { font-size: 1.5rem; display: block; margin-bottom: 5px; }

        /* --- RIGHT PANEL (Form Side) --- */
        .right-panel {
            background-color: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px 100px; /* High padding for centered look */
        }
        
        .form-header { margin-bottom: 30px; }
        .form-title { font-weight: 700; font-size: 2rem; color: #333; }
        .form-subtitle { color: #6c757d; font-size: 0.95rem; }

        /* Input Styling to match your image */
        .form-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
        }
        
        .custom-input {
            background-color: #F3F4F6; /* Light Gray Background */
            border: 1px solid transparent;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 0.95rem;
            transition: 0.3s;
        }
        
        .custom-input:focus {
            background-color: #fff;
            border-color: #2563EB;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .btn-primary-custom {
            background-color: #2563EB;
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            width: 100%;
            margin-top: 10px;
        }
        .btn-primary-custom:hover { background-color: #1d4ed8; }

        .bottom-link { text-align: center; margin-top: 20px; font-size: 0.9rem; color: #6c757d; }
        .bottom-link a { color: #2563EB; text-decoration: none; font-weight: 600; }
        .bottom-link a:hover { text-decoration: underline; }

        /* Responsive Fixes */
        @media (max-width: 992px) {
            .right-panel { padding: 40px; }
        }
        @media (max-width: 768px) {
            .left-panel { display: none; } /* Hide left panel on mobile */
            .right-panel { padding: 30px; }
        }
    </style>
</head>
<body>

<div class="container-fluid p-0">
    <div class="row g-0 main-container">
        
        <div class="col-lg-6 left-panel">
            <div class="illustration-box" style="padding: 0; background-color: white;">
                <img src="${pageContext.request.contextPath}/assets/img/img.png" 
                     alt="Login Illustration" 
                     style="width: 100%; height: 100%; object-fit: cover;">
            </div>
            
            <h2 class="left-title">Academic Dashboard</h2>
            <p class="left-subtitle">Streamline your academic journey with our comprehensive management platform.</p>
            
            <div class="feature-icons">
                <div class="feature-item">
                    <i class="bi bi-graph-up-arrow"></i>
                    <span>Analytics</span>
                </div>
                <div class="feature-item">
                    <i class="bi bi-people-fill"></i>
                    <span>Collaboration</span>
                </div>
                <div class="feature-item">
                    <i class="bi bi-mortarboard-fill"></i>
                    <span>Learning</span>
                </div>
            </div>
        </div>

        <div class="col-lg-6 right-panel">
            
            <div class="form-header">
                <h1 class="form-title">Create Account</h1>
                <p class="form-subtitle">Sign up to access your dashboard</p>
            </div>

            <% 
                String error = (String) request.getAttribute("errorMessage");
                if (error != null) {
            %>
                <div class="alert alert-danger py-2 mb-3" role="alert" style="font-size: 0.9rem;">
                    <%= error %>
                </div>
            <% } %>

            <form action="RegisterServlet" method="POST">
                
                <div class="mb-3">
                    <label class="form-label">Register as</label>
                    <select name="role" class="form-select custom-input" required>
                        <option value="Student" selected>Student</option>
                        <option value="Supervisor">Supervisor</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control custom-input" placeholder="Enter your name" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control custom-input" placeholder="Enter your email" required>
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control custom-input" placeholder="Create a password" required>
                </div>

                <button type="submit" class="btn btn-primary-custom">
                    Sign Up <i class="bi bi-arrow-right ms-2"></i>
                </button>

                <div class="bottom-link">
                    Already have an account? <a href="login.jsp">Sign in</a>
                </div>

            </form>
        </div>
    </div>
</div>

</body>
</html>