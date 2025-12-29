/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Account;
import com.fyp.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupervisorDashboardServlet", urlPatterns = {"/SupervisorDashboardServlet"})
public class SupervisorDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        // 1. Security Check: Is user logged in and a Supervisor?
        if (user == null || !user.getRoleType().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("index.html");
            return;
        }

        // 2. Fetch Projects for this Supervisor
        SupervisorDAO dao = new SupervisorDAO();
        
        // TEMPORARY: We are using Supervisor ID = 1 (Dr. Amin) for testing.
        // In a real app, you would link the Account ID to the Supervisor ID table.
        int supervisorId = 1; 
        
        List<Project> studentProjects = dao.getProjectsBySupervisor(supervisorId);
        
        // 3. Attach data to request
        request.setAttribute("projectList", studentProjects);
        
        // 4. Forward to the JSP
        request.getRequestDispatcher("supervisor/dashboard.jsp").forward(request, response);
    }
}