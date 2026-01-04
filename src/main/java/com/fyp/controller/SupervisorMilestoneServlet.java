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

        // 1. Security Check
        if (user == null || !user.getRoleType().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        SupervisorDAO supDao = new SupervisorDAO();
        MilestoneDAO mileDao = new MilestoneDAO();

        // FIX 1: Get the REAL Supervisor ID (No more 107!)
        int supervisorId = supDao.getSupervisorId(user.getAccountId());

        // 2. Get List of All Students assigned to this Supervisor
        List<Project> allStudents = supDao.getProjectsWithDetails(supervisorId);
        request.setAttribute("allStudents", allStudents);

        // 3. Check if a specific student is selected via URL (?studentId=...)
        String studentId = request.getParameter("studentId");

        if (studentId != null && !studentId.isEmpty()) {

            Project selectedProject = null;
            for (Project p : allStudents) {

                // --- IMPORTANT CHANGE HERE: String.valueOf(...) ---
                if (String.valueOf(p.getStudentId()).equals(studentId)) {
                    selectedProject = p;
                    break;
                }
            }

            if (selectedProject != null) {
                request.setAttribute("selectedProject", selectedProject);

                // FIX 2: Get the CORRECT Schedule ID for this specific project
                int scheduleId = mileDao.getScheduleIdByProject(selectedProject.getProjectId());

                if (scheduleId != -1) {
                    // Fetch milestones for THAT schedule
                    List<Milestone> milestones = mileDao.getMilestonesBySchedule(scheduleId);
                    request.setAttribute("milestoneList", milestones);

                    // Calculate Stats
                    int total = milestones.size();
                    int completed = 0;
                    for (Milestone m : milestones) {
                        if ("Completed".equalsIgnoreCase(m.getStatus())) {
                            completed++;
                        }
                    }
                    request.setAttribute("statTotal", total);
                    request.setAttribute("statCompleted", completed);
                } else {
                    // Handle case where no schedule exists yet
                    request.setAttribute("statTotal", 0);
                    request.setAttribute("statCompleted", 0);
                }
            }
        }

        // 4. Forward to JSP
        request.getRequestDispatcher("supervisor/supervisor_milestone.jsp").forward(request, response);
    }
}
