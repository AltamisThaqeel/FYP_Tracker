/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.AccountDAO;
import com.fyp.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// This annotation defines the URL pattern. 
// Form action="LoginServlet" looks for this.
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Retrieve Form Data
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        
        // 2. Validate with DAO
        AccountDAO dao = new AccountDAO();
        Account user = dao.login(email, pass);
        
        // 3. Logic Flow
        if (user != null) {
            // Check if the role matches what they selected (Security Check)
            if (user.getRoleType().equalsIgnoreCase(role)) {
                
                // LOGIN SUCCESS: Create Session
                HttpSession session = request.getSession();
                session.setAttribute("user", user); // Save full user object
                session.setAttribute("role", role);
                
                // Redirect to appropriate Dashboard
                if (role.equalsIgnoreCase("Student")) {
                    response.sendRedirect("StudentDashboardServlet");
                } else if (role.equalsIgnoreCase("Supervisor")) {
                    response.sendRedirect("SupervisorDashboardServlet");
                }
            } else {
                // Role mismatch
                response.sendRedirect("index.html?error=1");
            }
        } else {
            // LOGIN FAILED
            response.sendRedirect("index.html?error=1");
        }
    }
}
