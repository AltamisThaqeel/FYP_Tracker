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

        // 3. Calculate Dashboard Stats
        int totalStudents = projects.size();
        int completedProjects = 0;
        int currentWeek = 1; // You can make this dynamic later based on date

        for (Project p : projects) {
            boolean isCompleted = "Completed".equalsIgnoreCase(p.getStatus());

            // Count Completed Projects
            if (isCompleted) {
                completedProjects++;
            }

            // --- FIX: Force 100% Progress if Status is Completed ---
            if (isCompleted) {
                p.setProgress(100);
            } else {
                // Otherwise, calculate based on milestones
                int progress = mDao.getProjectProgress(p.getProjectId());
                p.setProgress(progress);
            }
        }

        // Get Milestone Counts
        int weekMilestones = mDao.countMilestonesByWeek(supervisorId, currentWeek);
        int totalMilestones = mDao.countTotalMilestones(supervisorId);

        // 4. Send Data to JSP
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("completedProjects", completedProjects);
        request.setAttribute("weekMilestones", weekMilestones);
        request.setAttribute("totalMilestones", totalMilestones);

        request.setAttribute("projectList", projects);

        request.getRequestDispatcher("supervisor/supervisor_dashboard.jsp").forward(request, response);
    }
}
