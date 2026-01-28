package com.fyp.controller;

import com.fyp.dao.MilestoneDAO;
import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Account;
import com.fyp.model.Project;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SupervisorDashboardServlet", urlPatterns = {"/SupervisorDashboardServlet"})
public class SupervisorDashboardServlet extends HttpServlet {

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

        SupervisorDAO dao = new SupervisorDAO();
        MilestoneDAO mDao = new MilestoneDAO();

        // 1. Get Dynamic Supervisor ID
        int supervisorId = dao.getSupervisorId(user.getAccountId());

        // 2. Fetch Projects
        List<Project> projects = dao.getProjectsWithDetails(supervisorId);

        // 3. Fetch Student List (for filters if needed)
        List<Account> studentList = dao.getMyStudents(supervisorId);

        // 4. Calculate Dashboard Stats
        int totalStudents = projects.size();
        int completedProjects = 0;
        int currentWeek = 1;

        for (Project p : projects) {
            boolean isDbCompleted = "Completed".equalsIgnoreCase(p.getStatus());

            if (isDbCompleted) {
                // If DB says completed, force stats
                p.setProgress(100);
                completedProjects++;
            } else {
                // Calculate real progress from milestones
                int progress = mDao.getProjectProgress(p.getProjectId());
                p.setProgress(progress);

                // --- FIX: AUTO-COMPLETE LOGIC ---
                // If progress hits 100%, treat it as Completed for the dashboard display
                if (progress == 100) {
                    p.setStatus("Completed");
                    completedProjects++; // Count this as completed too
                }
            }
        }

        // Get Milestone Counts
        int weekMilestones = mDao.countMilestonesByWeek(supervisorId, currentWeek);
        int totalMilestones = mDao.countTotalMilestones(supervisorId);

        // 5. Send Data to JSP
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("completedProjects", completedProjects);
        request.setAttribute("weekMilestones", weekMilestones);
        request.setAttribute("totalMilestones", totalMilestones);

        request.setAttribute("projectList", projects);
        request.setAttribute("studentList", studentList);

        request.getRequestDispatcher("supervisor/supervisor_dashboard.jsp").forward(request, response);
    }
}
