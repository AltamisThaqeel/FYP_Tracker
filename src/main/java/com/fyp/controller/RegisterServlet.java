/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.AccountDAO;
import com.fyp.dao.StudentDAO;
import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Retrieve Form Data
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        
        AccountDAO accountDao = new AccountDAO();
        
        // 2. Validation: Check if email exists
        if (accountDao.emailExists(email)) {
            request.setAttribute("errorMessage", "Email is already registered!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // 3. Create Account Object
        Account a = new Account();
        a.setFullName(name);
        a.setEmail(email);
        a.setPassword(password);
        a.setRoleType(role);
        
        // 4. Save Account and Get ID
        int newAccountId = accountDao.registerUser(a);
        
        if (newAccountId > 0) {
            // 5. Create specific Role Profile
            if (role.equalsIgnoreCase("Student")) {
                StudentDAO sDao = new StudentDAO();
                sDao.registerStudent(name, phone, newAccountId);
            } else if (role.equalsIgnoreCase("Supervisor")) {
                SupervisorDAO supDao = new SupervisorDAO();
                supDao.registerSupervisor(phone, newAccountId);
            }
            
            // 6. Success - Redirect to Login
            // We can pass a success message via URL parameter
            response.sendRedirect("login.jsp?msg=registered");
        } else {
            // Failure
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
