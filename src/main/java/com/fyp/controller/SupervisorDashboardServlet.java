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
        
        if (user == null || !user.getRoleType().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        SupervisorDAO dao = new SupervisorDAO();
        int supervisorId = 107; // Hardcoded for assignment

        // 1. Fetch Projects
        List<Project> projects = dao.getProjectsWithDetails(supervisorId);
        
        // 2. Calculate Stats
        int totalStudents = projects.size();
        int completed = 0;
        int delayed = 0;
        
        for(Project p : projects) {
            if("Completed".equalsIgnoreCase(p.getStatus())) completed++;
            // Logic to determine delay can be added here based on dates
        }

        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("projectList", projects); // Re-using the list for the "Status" table
        
        request.getRequestDispatcher("supervisor/supervisor_dashboard.jsp").forward(request, response);
    }
}