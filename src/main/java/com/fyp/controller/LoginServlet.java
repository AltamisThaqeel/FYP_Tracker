package com.fyp.controller;

import com.fyp.dao.AccountDAO;
import com.fyp.model.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie; // <--- IMPORT THIS
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve Form Data
        String selectedRole = request.getParameter("role");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember"); // <--- GET CHECKBOX VALUE

        // 2. Database Validation
        AccountDAO dao = new AccountDAO();
        Account user = dao.login(email, password); 

        // 3. Logic Flow
        if (user != null) {
            
            // --- CHECK 2: Did they select the correct role? ---
            if (user.getRoleType().equalsIgnoreCase(selectedRole)) {

                // --- LOGIN SUCCESS ---
                
                // === START REMEMBER ME LOGIC ===
                // Create a cookie named "c_email" to store the email
                Cookie c = new Cookie("c_email", email);
                
                if (remember != null && remember.equals("on")) {
                    // If checked, save for 30 days (30 * 24 * 60 * 60 seconds)
                    c.setMaxAge(60 * 60 * 24 * 30); 
                } else {
                    // If unchecked, delete the cookie instantly
                    c.setMaxAge(0); 
                }
                response.addCookie(c); // Add cookie to the response
                // === END REMEMBER ME LOGIC ===

                // Create Session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);      
                session.setAttribute("role", selectedRole); 

                // Redirect to the specific SERVLET (Not JSP)
                // We use Servlets so that dashboard data (projects/tasks) loads first.
                if (selectedRole.equalsIgnoreCase("Student")) {
                    response.sendRedirect("StudentDashboardServlet"); // Loads data -> student_dashboard.jsp
                    
                } else if (selectedRole.equalsIgnoreCase("Supervisor")) {
                    response.sendRedirect("SupervisorDashboardServlet"); // Loads data -> supervisor_dashboard.jsp
                } 
                else {
                    response.sendRedirect("index.html");
                }

            } else {
                // --- ROLE MISMATCH ---
                request.setAttribute("errorMessage", "Role mismatch! You are registered as a " + user.getRoleType());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } else {
            // --- LOGIN FAILED ---
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}