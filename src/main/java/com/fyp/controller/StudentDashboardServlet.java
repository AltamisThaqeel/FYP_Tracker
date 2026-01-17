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
            Project myProject = pDao.getProjectByStudent(studentId);
            
            if (myProject != null) {
                int progress = mDao.getProjectProgress(myProject.getProjectId());
                myProject.setProgress(progress);
                
                request.setAttribute("project", myProject);
            }
        }
        if (studentId != -1) {
            Project myProject = pDao.getProjectByStudent(studentId);

            if (myProject != null) {
                int progress = mDao.getProjectProgress(myProject.getProjectId());
                myProject.setProgress(progress);
                request.setAttribute("project", myProject);
            } else {
                request.setAttribute("project", new Project()); 
            }
        }
        if (studentId != 1){
            Project myProject = pDao.getProjectByStudent(studentId);
            
            if (myProject != null) {
                int projectId = myProject.getProjectId();

                int progress = mDao.getProjectProgress(projectId);
                myProject.setProgress(progress);

                int totalCount = mDao.countAllMilestonesForProject(projectId);
                int completedCount = mDao.countCompletedMilestonesForProject(projectId);
                int currentWeek = 1; 
                int thisWeekMilestones = mDao.getMilestonesByProjectAndWeek(projectId, currentWeek).size();
                int upcomingCount = mDao.getMilestonesByProjectAndWeek(projectId, currentWeek + 1).size();
                int feedbackCount = fDao.getAllFeedbackByProject(projectId).size();
                
                List<Integer> completedPerWeek = new ArrayList<>();
                List<Integer> totalPerWeek = new ArrayList<>();
                int totalWeeks = myProject.getNumOfWeeks(); // Corrected getter from your Project.java

                for (int i = 1; i <= totalWeeks; i++) {
                    List<Milestone> weekMilestones = mDao.getMilestonesByProjectAndWeek(projectId, i);
                    int completed = 0;
                    for (Milestone m : weekMilestones) {
                        if ("Completed".equalsIgnoreCase(m.getStatus())) {
                            completed++;
                        }
                    }
                    completedPerWeek.add(completed);
                    totalPerWeek.add(weekMilestones.size());
                }

                String labelsJson = IntStream.rangeClosed(1, totalWeeks).mapToObj(String::valueOf).collect(java.util.stream.Collectors.joining(","));
                String completedJson = completedPerWeek.stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(","));
                String totalJson = totalPerWeek.stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(","));
                
                List<Milestone> allMilestones = mDao.getMilestonesByProject(projectId);
                request.setAttribute("allProjectMilestones", allMilestones);
                
                List<Integer> weeksList = IntStream.rangeClosed(1, totalWeeks).boxed().collect(java.util.stream.Collectors.toList());
                request.setAttribute("chartLabelsArray", weeksList);
                
                request.setAttribute("chartLabels", labelsJson);
                request.setAttribute("chartCompletedData", completedJson);
                request.setAttribute("chartTotalData", totalJson);
                
                request.setAttribute("project", myProject);
                request.setAttribute("totalCount", totalCount);
                request.setAttribute("completedCount", completedCount);
                request.setAttribute("upcomingCount", upcomingCount);
                request.setAttribute("thisWeekCount", thisWeekMilestones);
                request.setAttribute("feedbackCount", feedbackCount);
            }
            }
            
        request.getRequestDispatcher("student/student_dashboard.jsp").forward(request, response);
    }
}