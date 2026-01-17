package com.fyp.controller;

import com.fyp.dao.ProjectDAO;
import com.fyp.model.Account;
import com.fyp.model.Project;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CreateProjectServlet", urlPatterns = {"/CreateProjectServlet"})
public class CreateProjectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Security Check
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        ProjectDAO dao = new ProjectDAO();
        int studentId = dao.getStudentIdByAccount(user.getAccountId());
        
        // 2. FETCH ALL PROJECTS (For the Dropdown)
        // This allows the user to see a list of their existing projects
        List<Project> myProjects = dao.getAllProjectsByStudent(studentId);
        request.setAttribute("projectList", myProjects);

        // 3. DETERMINE WHICH PROJECT TO SHOW IN THE FORM
        String action = request.getParameter("action");          // e.g., "new"
        String selectedIdStr = request.getParameter("projectId"); // e.g., "5"
        
        Project currentProject = null;

        if ("new".equals(action)) {
            // Case A: User clicked "Create New Project" -> Show Empty Form
            currentProject = null; 
        } else if (selectedIdStr != null) {
            // Case B: User selected a project from Dropdown -> Show Specific Project
            try {
                int selectedId = Integer.parseInt(selectedIdStr);
                // Find the project in the list (saves a DB trip)
                for (Project p : myProjects) {
                    if (p.getProjectId() == selectedId) {
                        currentProject = p;
                        break;
                    }
                }
            } catch (NumberFormatException e) { }
        } else if (!myProjects.isEmpty()) {
            // Case C: Default Load -> Show the first project in the list (if any)
            currentProject = myProjects.get(0);
        }

        // Send the specific project (or null) to the JSP to fill the inputs
        request.setAttribute("currentProject", currentProject);
        
        request.getRequestDispatcher("student/create_project.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get Logged In User
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        // 2. Retrieve Form Data
        String projectIdStr = request.getParameter("projectId"); // HIDDEN FIELD for Updates
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String type = request.getParameter("type");
        String desc = request.getParameter("desc");
        String objectives = request.getParameter("objectives");
        String phone = request.getParameter("phone");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        // 3. Prepare Model
        Project p = new Project();
        p.setProjectTitle(title);
        p.setCategoryName(category);
        p.setProjectType(type);
        p.setDescription(desc);
        p.setObjective(objectives);
        p.setContactPhone(phone);

        try {
            if (startDateStr != null && !startDateStr.isEmpty()) 
                p.setStartDate(Date.valueOf(startDateStr));
            if (endDateStr != null && !endDateStr.isEmpty()) 
                p.setEndDate(Date.valueOf(endDateStr));
        } catch (IllegalArgumentException e) {
            p.setStartDate(new Date(System.currentTimeMillis()));
            p.setEndDate(new Date(System.currentTimeMillis()));
        }

        // 4. Database Interaction
        ProjectDAO dao = new ProjectDAO();
        int realStudentId = dao.getStudentIdByAccount(user.getAccountId());
        
        if (realStudentId != -1) {
            p.setStudentId(realStudentId);

            // --- THE LOGIC SPLIT: UPDATE OR CREATE? ---
            if (projectIdStr != null && !projectIdStr.isEmpty()) {
                // UPDATE EXISTING PROJECT
                p.setProjectId(Integer.parseInt(projectIdStr));
                boolean success = dao.updateProject(p); 
                
                // Redirect back to the specific project page
                if (success) {
                    response.sendRedirect("CreateProjectServlet?projectId=" + p.getProjectId());
                } else {
                    response.sendRedirect("CreateProjectServlet?error=UpdateFailed");
                }
                
            } else {
                // CREATE NEW PROJECT
                boolean success = dao.createProject(p);
                
                // Redirect to the main servlet to load the new list
                if (success) {
                    response.sendRedirect("CreateProjectServlet");
                } else {
                    response.sendRedirect("CreateProjectServlet?error=InsertFailed");
                }
            }
        } else {
            response.sendRedirect("CreateProjectServlet?error=NoStudentProfile");
        }
    }
}