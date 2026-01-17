package com.fyp.controller;

import com.fyp.dao.FeedbackDAO;
import com.fyp.dao.MilestoneDAO;
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
import java.util.ArrayList; // Import ArrayList
import java.util.List;

@WebServlet(name = "SupervisorMilestoneServlet", urlPatterns = {"/SupervisorMilestoneServlet"})
public class SupervisorMilestoneServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null || !user.getRoleType().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        SupervisorDAO supDao = new SupervisorDAO();
        MilestoneDAO mileDao = new MilestoneDAO();
        FeedbackDAO feedDao = new FeedbackDAO();

        int supervisorId = supDao.getSupervisorId(user.getAccountId());

        // 1. Get All Projects (Raw List)
        List<Project> allProjects = supDao.getProjectsWithDetails(supervisorId);
        request.setAttribute("allProjects", allProjects);

        // 2. Get Unique Student List (For Search Dropdown)
        List<Account> studentList = supDao.getMyStudents(supervisorId);
        request.setAttribute("studentList", studentList);

        // 3. Handle Parameters
        String studentIdParam = request.getParameter("studentId");
        String projectIdParam = request.getParameter("projectId"); // NEW: Support specific project selection
        String weekParam = request.getParameter("week");

        int selectedWeek = 1;
        try {
            selectedWeek = Integer.parseInt(weekParam);
        } catch (Exception e) {
        }
        request.setAttribute("selectedWeek", selectedWeek);

        // 4. Logic: If a student is selected
        if (studentIdParam != null && !studentIdParam.isEmpty()) {
            int studentId = Integer.parseInt(studentIdParam);

            // A. Filter projects belonging ONLY to this student
            List<Project> studentProjects = new ArrayList<>();
            for (Project p : allProjects) {
                if (p.getStudentId() == studentId) {
                    studentProjects.add(p);
                }
            }
            // Pass the student's specific projects to JSP for the switcher
            request.setAttribute("studentProjects", studentProjects);

            // B. Determine which project to show (Target Project)
            Project selectedProject = null;

            // If projectId is specifically requested, look for it
            if (projectIdParam != null && !projectIdParam.isEmpty()) {
                int targetProjId = Integer.parseInt(projectIdParam);
                for (Project p : studentProjects) {
                    if (p.getProjectId() == targetProjId) {
                        selectedProject = p;
                        break;
                    }
                }
            }

            // Default: If no specific project requested (or not found), pick the first one
            if (selectedProject == null && !studentProjects.isEmpty()) {
                selectedProject = studentProjects.get(0);
            }

            // C. Load Data for the selected Project
            if (selectedProject != null) {
                request.setAttribute("selectedProject", selectedProject);

                // --- Calculate Weeks ---
                int totalWeeks = 14;
                if (selectedProject.getStartDate() != null && selectedProject.getEndDate() != null) {
                    long diff = Math.abs(selectedProject.getEndDate().getTime() - selectedProject.getStartDate().getTime());
                    totalWeeks = (int) Math.ceil(diff / (1000 * 60 * 60 * 24 * 7.0));
                    if (totalWeeks < 1) {
                        totalWeeks = 14;
                    }
                }
                request.setAttribute("totalWeeks", totalWeeks);

                // --- Load Stats ---
                request.setAttribute("statTotal", mileDao.countAllMilestonesForProject(selectedProject.getProjectId()));
                request.setAttribute("statCompleted", mileDao.countCompletedMilestonesForProject(selectedProject.getProjectId()));

                // --- Load Feedback ---
                request.setAttribute("currentFeedback", feedDao.getFeedback(selectedProject.getProjectId(), selectedWeek));

                // --- Load Milestones ---
                int scheduleId = mileDao.getScheduleIdByProjectAndWeek(selectedProject.getProjectId(), selectedWeek);
                if (scheduleId != -1) {
                    request.setAttribute("milestoneList", mileDao.getMilestonesBySchedule(scheduleId));
                }
            }
        }
        request.getRequestDispatcher("supervisor/supervisor_milestone.jsp").forward(request, response);
    }

    // doPost remains the same
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("milestoneId");
        String studentId = request.getParameter("studentId");
        String projectId = request.getParameter("projectId"); // Keep project ID in URL

        if (idParam != null && action != null) {
            MilestoneDAO dao = new MilestoneDAO();
            if ("approve".equals(action)) {
                dao.updateMilestoneStatus(Integer.parseInt(idParam), "Completed");
            } else if ("reject".equals(action)) {
                dao.updateMilestoneStatus(Integer.parseInt(idParam), "Pending");
            }
        }

        // Redirect keeping both IDs
        response.sendRedirect("SupervisorMilestoneServlet?studentId=" + studentId + "&projectId=" + projectId);
    }
}
