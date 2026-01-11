package com.fyp.controller;

import com.fyp.dao.MilestoneDAO;
import com.fyp.dao.ProjectDAO;
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

@WebServlet(name = "MilestoneServlet", urlPatterns = {"/MilestoneServlet"})
public class MilestoneServlet extends HttpServlet {

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

        // 1. Get the real studentId
        int studentId = pDao.getStudentIdByAccount(user.getAccountId());
        
        // 2. FETCH ALL PROJECTS (For the Dropdown)
        List<Project> projectList = pDao.getAllProjectsByStudent(studentId);
        request.setAttribute("projectList", projectList);
        
        // 3. DETERMINE WHICH PROJECT IS SELECTED
        String projectIdParam = request.getParameter("projectId");
        Project currentProject = null;

        if (projectIdParam != null && !projectIdParam.isEmpty()) {
            // Case A: User selected a specific project from dropdown
            int pid = Integer.parseInt(projectIdParam);
            for (Project p : projectList) {
                if (p.getProjectId() == pid) {
                    currentProject = p;
                    break;
                }
            }
        } else if (!projectList.isEmpty()) {
            // Case B: Default load (pick the first project in the list)
            currentProject = projectList.get(0);
        }

        // 4. Handle Milestones and Weeks if a project exists
        if (currentProject != null) {
            String weekParam = request.getParameter("week");
            int selectedWeek = (weekParam != null) ? Integer.parseInt(weekParam) : 1;

            List<Milestone> milestones = mDao.getMilestonesByProjectAndWeek(currentProject.getProjectId(), selectedWeek);

            // Set all necessary attributes for the JSP
            request.setAttribute("currentProject", currentProject);
            request.setAttribute("milestones", milestones);
            request.setAttribute("selectedWeek", selectedWeek);
            request.setAttribute("projectId", currentProject.getProjectId()); // Used for dropdown "selected" state
        }

        request.getRequestDispatcher("student/milestones.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        MilestoneDAO dao = new MilestoneDAO();
        
        String projectId = request.getParameter("projectId");
        String weekNum = request.getParameter("weekNum");

        if ("add".equals(action)) {
            String taskDesc = request.getParameter("taskDesc");
            dao.addMilestone(taskDesc, Integer.parseInt(projectId), Integer.parseInt(weekNum));
            
        } else if ("complete".equals(action)) {
            int milestoneId = Integer.parseInt(request.getParameter("milestoneId"));
            String status = request.getParameter("status"); 
            dao.updateStatus(milestoneId, status);
        }

        response.sendRedirect("MilestoneServlet?projectId=" + projectId + "&week=" + weekNum);
    }
}