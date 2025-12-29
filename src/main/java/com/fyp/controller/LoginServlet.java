package com.fyp.controller;

import com.fyp.dao.AccountDAO;
import com.fyp.model.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
        String selectedRole = request.getParameter("role"); // The role chosen in the dropdown
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. Database Validation
        AccountDAO dao = new AccountDAO();
        Account user = dao.login(email, password); // Returns null if not found

        // 3. Logic Flow
        if (user != null) {
            
            // --- CHECK 1: Does the user exist? YES. ---
            
            // --- CHECK 2: Did they select the correct role? ---
            // Compares the role in Database (user.getRoleType()) with the form (selectedRole)
            if (user.getRoleType().equalsIgnoreCase(selectedRole)) {

                // --- LOGIN SUCCESS ---
                
                // Create Session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);      // Store the whole object
                session.setAttribute("role", selectedRole); // Store the role for easy checks

                // Redirect to the specific Folder + JSP
                if (selectedRole.equalsIgnoreCase("Student")) {
                    // Go to: /FYP_Tracker/student/student_dashboard.jsp
                    response.sendRedirect("student/student_dashboard.jsp");
                    
                } else if (selectedRole.equalsIgnoreCase("Supervisor")) {
                    // Go to: /FYP_Tracker/supervisor/supervisor_dashboard.jsp
                    response.sendRedirect("supervisor/supervisor_dashboard.jsp");
                } 
                else {
                    // Fallback for unexpected roles
                    response.sendRedirect("index.html");
                }

            } else {
                // --- ROLE MISMATCH ---
                // User exists, but tried to log in as the wrong role
                request.setAttribute("errorMessage", "Role mismatch! You are registered as a " + user.getRoleType());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } else {
            // --- LOGIN FAILED ---
            // Invalid Email or Password
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If someone tries to access /LoginServlet directly, send them to login page
        response.sendRedirect("login.jsp");
    }
}