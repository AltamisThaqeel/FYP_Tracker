/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.FeedbackDAO;
import com.fyp.dao.MilestoneDAO;
import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Account;
import com.fyp.model.Feedback;
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
        FeedbackDAO feedDao = new FeedbackDAO();

        // 2. Get Dynamic Supervisor ID
        int supervisorId = supDao.getSupervisorId(user.getAccountId());
        List<Project> allStudents = supDao.getProjectsWithDetails(supervisorId);
        request.setAttribute("allStudents", allStudents);

        // 3. Handle 'week' parameter safely
        String weekStr = request.getParameter("week");
        int selectedWeek = 1;
        if (weekStr != null && !weekStr.isEmpty()) {
            try {
                selectedWeek = Integer.parseInt(weekStr);
            } catch (NumberFormatException e) {
                selectedWeek = 1;
            }
        }
        request.setAttribute("selectedWeek", selectedWeek);

        // 4. Handle 'studentId' parameter
        String studentId = request.getParameter("studentId");

        if (studentId != null && !studentId.isEmpty()) {
            Project selectedProject = null;
            for (Project p : allStudents) {
                if (String.valueOf(p.getStudentId()).equals(studentId)) {
                    selectedProject = p;
                    break;
                }
            }

            if (selectedProject != null) {
                request.setAttribute("selectedProject", selectedProject);

                // --- NEW LOGIC: Calculate Dynamic Total Weeks ---
                int totalWeeks = 14; // Default
                if (selectedProject.getStartDate() != null && selectedProject.getEndDate() != null) {
                    long diffInMillies = Math.abs(selectedProject.getEndDate().getTime() - selectedProject.getStartDate().getTime());
                    long diffInDays = diffInMillies / (1000 * 60 * 60 * 24);
                    // We calculate weeks (rounding up to ensure we cover the last partial week if any)
                    totalWeeks = (int) Math.ceil(diffInDays / 7.0);

                    // Safety: If for some reason calculation is 0 or negative, stick to 14 or minimum 1
                    if (totalWeeks < 1) {
                        totalWeeks = 14;
                    }
                }
                request.setAttribute("totalWeeks", totalWeeks);
                // ------------------------------------------------

                // 1. FETCH OVERALL STATS
                int totalOverall = mileDao.countAllMilestonesForProject(selectedProject.getProjectId());
                int completedOverall = mileDao.countCompletedMilestonesForProject(selectedProject.getProjectId());
                request.setAttribute("statTotal", totalOverall);
                request.setAttribute("statCompleted", completedOverall);

                // 2. FETCH FEEDBACK
                Feedback existingFeedback = feedDao.getFeedback(selectedProject.getProjectId(), selectedWeek);
                request.setAttribute("currentFeedback", existingFeedback);

                // 3. FETCH MILESTONES
                int scheduleId = mileDao.getScheduleIdByProjectAndWeek(selectedProject.getProjectId(), selectedWeek);
                if (scheduleId != -1) {
                    List<Milestone> milestones = mileDao.getMilestonesBySchedule(scheduleId);
                    request.setAttribute("milestoneList", milestones);
                }
            }
        }
        request.getRequestDispatcher("supervisor/supervisor_milestone.jsp").forward(request, response);
    }
}
