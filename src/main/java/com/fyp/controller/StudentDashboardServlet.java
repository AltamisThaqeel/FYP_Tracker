package com.fyp.controller;

import com.fyp.dao.MilestoneDAO;
import com.fyp.dao.ProjectDAO;
import com.fyp.dao.FeedbackDAO;
import com.fyp.model.Milestone;
import com.fyp.model.Account;
import com.fyp.model.Project;
import java.io.IOException;
import java.util.stream.IntStream;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/StudentDashboardServlet"})
public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        ProjectDAO pDao = new ProjectDAO();
        MilestoneDAO mDao = new MilestoneDAO();
        FeedbackDAO fDao = new FeedbackDAO();

        int studentId = pDao.getStudentIdByAccount(user.getAccountId());

        if (studentId != -1) {
            // 1. Fetch ALL projects for the student
            List<Project> projectList = pDao.getAllProjectsByStudent(studentId);
            request.setAttribute("totalProjects", projectList.size());

            if (!projectList.isEmpty()) {
                // 2. Determine which project to show based on the 'index' parameter
                int currentIndex = 0;
                String idxStr = request.getParameter("index");
                if (idxStr != null) {
                    try {
                        currentIndex = Integer.parseInt(idxStr);
                    } catch (NumberFormatException e) { currentIndex = 0; }
                }

                // Boundary safety for the list
                if (currentIndex < 0) currentIndex = 0;
                if (currentIndex >= projectList.size()) currentIndex = projectList.size() - 1;

                // 3. SELECT the specific project from the list
                Project myProject = projectList.get(currentIndex);
                int projectId = myProject.getProjectId();

                // 4. RECALCULATE ALL STATS for this specific projectId
                int progress = mDao.getProjectProgress(projectId);
                myProject.setProgress(progress);

                int totalCount = mDao.countAllMilestonesForProject(projectId);
                int completedCount = mDao.countCompletedMilestonesForProject(projectId);
                int currentWeek = 1; 
                int thisWeekCount = mDao.getMilestonesByProjectAndWeek(projectId, currentWeek).size();
                int upcomingCount = mDao.getMilestonesByProjectAndWeek(projectId, currentWeek + 1).size();
                int feedbackCount = fDao.getAllFeedbackByProject(projectId).size();

                // 5. Update Chart Data for this specific project
                List<Integer> completedPerWeek = new ArrayList<>();
                List<Integer> totalPerWeek = new ArrayList<>();
                int totalWeeks = myProject.getNumOfWeeks();

                for (int i = 1; i <= totalWeeks; i++) {
                    List<Milestone> weekMilestones = mDao.getMilestonesByProjectAndWeek(projectId, i);
                    int completed = (int) weekMilestones.stream()
                            .filter(m -> "Completed".equalsIgnoreCase(m.getStatus())).count();
                    completedPerWeek.add(completed);
                    totalPerWeek.add(weekMilestones.size());
                }

                String labelsJson = IntStream.rangeClosed(1, totalWeeks).mapToObj(String::valueOf).collect(java.util.stream.Collectors.joining(","));
                String completedJson = completedPerWeek.stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(","));
                String totalJson = totalPerWeek.stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(","));

                // 6. Set attributes for JSP
                request.setAttribute("project", myProject);
                request.setAttribute("currentIndex", currentIndex);
                request.setAttribute("totalCount", totalCount);
                request.setAttribute("completedCount", completedCount);
                request.setAttribute("upcomingCount", upcomingCount);
                request.setAttribute("thisWeekCount", thisWeekCount);
                request.setAttribute("feedbackCount", feedbackCount);
                request.setAttribute("chartLabels", labelsJson);
                request.setAttribute("chartCompletedData", completedJson);
                request.setAttribute("chartTotalData", totalJson);
                request.setAttribute("chartLabelsArray", IntStream.rangeClosed(1, totalWeeks).boxed().toList());
                request.setAttribute("allProjectMilestones", mDao.getMilestonesByProject(projectId));
            }
        }
        request.getRequestDispatcher("student/student_dashboard.jsp").forward(request, response);
    }
}