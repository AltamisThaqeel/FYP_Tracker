/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.MilestoneDAO;
import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Account;
import com.fyp.model.Milestone;
import com.fyp.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupervisorMilestoneServlet", urlPatterns = {"/SupervisorMilestoneServlet"})
public class SupervisorMilestoneServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        // Security Check
        if (user == null || !user.getRoleType().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        SupervisorDAO supDao = new SupervisorDAO();
        MilestoneDAO mileDao = new MilestoneDAO();
        int supervisorId = 107; // Hardcoded for this demo

        // 1. Get List of All Students (For Dropdown)
        List<Project> allStudents = supDao.getProjectsWithDetails(supervisorId);
        request.setAttribute("allStudents", allStudents);

        // 2. Check if a specific student is selected via URL (?studentId=...)
        String studentIdStr = request.getParameter("studentId");

        if (studentIdStr != null && !studentIdStr.isEmpty()) {
            int studentId = Integer.parseInt(studentIdStr);
            // Find the specific project object from the list
            Project selectedProject = null;
            for (Project p : allStudents) {
                if (p.getStudentId() == studentId) {
                    selectedProject = p;
                    break;
                }
            }

            if (selectedProject != null) {
                request.setAttribute("selectedProject", selectedProject);

                // 3. Fetch Milestones
                // (Assuming Week 1 / Schedule ID 1 for this prototype)
                List<Milestone> milestones = mileDao.getMilestonesBySchedule(1);
                request.setAttribute("milestoneList", milestones);

                // 4. Calculate Stats (Total vs Completed)
                int total = milestones.size();
                int completed = 0;
                for (Milestone m : milestones) {
                    if ("Completed".equalsIgnoreCase(m.getStatus())) {
                        completed++;
                    }
                }
                request.setAttribute("statTotal", total);
                request.setAttribute("statCompleted", completed);
            }
        }

        // 5. Forward to JSP
        request.getRequestDispatcher("supervisor/supervisor_milestone.jsp").forward(request, response);
    }
}
