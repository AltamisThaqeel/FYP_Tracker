/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.MilestoneDAO;
import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Milestone;
import com.fyp.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupervisorMilestoneServlet", urlPatterns = {"/SupervisorMilestoneServlet"})
public class SupervisorMilestoneServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        SupervisorDAO supDao = new SupervisorDAO();
        MilestoneDAO mileDao = new MilestoneDAO();
        int supervisorId = 1;

        // 1. Get List of All Students (for the Dropdown)
        List<Project> allProjects = supDao.getProjectsWithDetails(supervisorId);
        request.setAttribute("allStudents", allProjects);

        // 2. Check if a specific student is selected (via URL param)
        String studentId = request.getParameter("studentId");
        
        if (studentId != null && !studentId.isEmpty()) {
            // Fetch Milestones for this student's project
            // (Note: You might need a method in ProjectDAO to get ProjectID from StudentID first)
            // For now assuming we find the project in the list:
            for(Project p : allProjects) {
                if(p.getStudentId().equals(studentId)) {
                    List<Milestone> milestones = mileDao.getMilestonesBySchedule(1); // Default Week 1 for demo
                    request.setAttribute("selectedProject", p);
                    request.setAttribute("milestones", milestones);
                    break;
                }
            }
        }

        request.getRequestDispatcher("supervisor/supervisor_milestone.jsp").forward(request, response);
    }
}