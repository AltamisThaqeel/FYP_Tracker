<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Dashboard - Login</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body, html { height: 100%; margin: 0; font-family: 'Segoe UI', sans-serif; }

        /* --- Left Side Styling (Blue Panel) --- */
        .left-panel {
            background-color: #2563EB; /* Bright Blue */
            color: white;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 50px;
        }
        
        /* Illustration Placeholder */
        .illustration-box {
            background-color: #60a5fa; 
            border-radius: 20px; 
            width: 80%; 
            max-width: 350px; 
            height: 300px;
            margin-bottom: 30px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .feature-icons i { font-size: 1.5rem; margin: 0 15px; opacity: 0.8; }
        .feature-text { font-size: 0.8rem; margin-top: 5px; opacity: 0.8; }

        /* --- Right Side Styling (Form) --- */
        .right-panel {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #ffffff;
        }

        .login-container { width: 100%; max-width: 400px; padding: 20px; }

        .form-control, .form-select {
            background-color: #F3F4F6; /* Light gray inputs */
            border: 1px solid transparent;
            height: 50px;
            border-radius: 8px;
            padding-left: 15px;
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            background-color: white;
            border-color: #2563EB;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .btn-primary {
            background-color: #2563EB;
            border: none;
            height: 50px;
            border-radius: 8px;
            font-weight: 600;
            width: 100%;
            transition: background 0.3s;
        }

        .btn-primary:hover { background-color: #1d4ed8; }
        .forgot-link { font-size: 0.9rem; text-decoration: none; color: #2563EB; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        
        <div class="col-md-6 d-none d-md-flex left-panel">
            <div class="illustration-box">
                <i class="bi bi-laptop text-white" style="font-size: 6rem;"></i>
            </div>
            
            <h2 class="fw-bold display-6">Academic Dashboard</h2>
            <p class="mt-2" style="opacity: 0.9; max-width: 400px; font-weight: 300;">
                Streamline your academic journey with our comprehensive management platform.
            </p>

            <div class="d-flex justify-content-center mt-5 feature-icons">
                <div class="text-center">
                    <i class="bi bi-graph-up"></i>
                    <div class="feature-text">Analytics</div>
                </div>
                <div class="text-center">
                    <i class="bi bi-people-fill"></i>
                    <div class="feature-text">Collaboration</div>
                </div>
                <div class="text-center">
                    <i class="bi bi-mortarboard-fill"></i>
                    <div class="feature-text">Learning</div>
                </div>
            </div>
        </div>

        <div class="col-md-6 right-panel">
            <div class="login-container">
                <div class="mb-4">
                    <h2 class="fw-bold">Welcome Back</h2>
                    <p class="text-muted">Sign in to access your dashboard</p>
                </div>

                <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-secondary">LOGIN AS</label>
                        <select name="role" class="form-select">
                            <option value="student">Student</option>
                            <option value="supervisor">Supervisor</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-secondary">EMAIL ADDRESS</label>
                        <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-secondary">PASSWORD</label>
                        <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="rememberMe">
                            <label class="form-check-label small text-muted" for="rememberMe">Remember me</label>
                        </div>
                        <a href="#" class="forgot-link">Forgot Password?</a>
                    </div>

                    <button type="submit" class="btn btn-primary shadow-sm">
                        <i class="bi bi-box-arrow-in-right me-2"></i> Sign In
                    </button>

                    <% 
                        String error = request.getParameter("error");
                        if (error != null) {
                    %>
                        <div class="alert alert-danger mt-3 d-flex align-items-center small" role="alert">
                            <i class="bi bi-exclamation-circle-fill me-2"></i>
                            <div>
                                <% 
                                    if(error.equals("InvalidCredentials")) {
                                        out.print("Invalid Email or Password.");
                                    } else if(error.equals("RoleMismatch")) {
                                        out.print("Correct account, but wrong Role selected.");
                                    } else {
                                        out.print("Login failed. Please try again.");
                                    }
                                %>
                            </div>
                        </div>
                    <% } %>

                    <div class="text-center mt-4 small text-muted">
                        Don't have an account? <a href="register.jsp" class="text-decoration-none fw-bold" style="color: #2563EB;">Sign up</a>
                    </div>
                    
                </form>
            </div>
        </div>
        
    </div>
</div>

</body>
</html>