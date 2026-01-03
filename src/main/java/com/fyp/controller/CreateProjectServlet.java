package com.fyp.controller;

import com.fyp.dao.ProjectDAO;
import com.fyp.model.Account;
import com.fyp.model.Project;
import java.io.IOException;
import java.sql.Date;
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
        // Keeps the URL as /CreateProjectServlet while showing the JSP content
        request.getRequestDispatcher("student/create_project.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get Logged In User from Session
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 2. Retrieve Form Data (Including new Category and Type)
        String title = request.getParameter("title");
        String category = request.getParameter("category"); // Captured from JSP select
        String type = request.getParameter("type");         // Captured from JSP select
        String desc = request.getParameter("desc");
        String objectives = request.getParameter("objectives");
        String phone = request.getParameter("phone");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        // 3. Prepare the Project Model
        Project p = new Project();
        p.setProjectName(title);
        p.setDescription(desc);
        p.setObjective(objectives);
        p.setContactPhone(phone);
        
        // --- IMPORTANT: Set the new fields ---
        // Ensure your Project.java model has these setter methods
        p.setCategoryName(category); 
        p.setProjectType(type);

        // Convert Strings to SQL Dates safely
        try {
            if (startDateStr != null && !startDateStr.isEmpty()) {
                p.setStartDate(Date.valueOf(startDateStr));
            }
            if (endDateStr != null && !endDateStr.isEmpty()) {
                p.setEndDate(Date.valueOf(endDateStr));
            }
        } catch (IllegalArgumentException e) {
            p.setStartDate(new Date(System.currentTimeMillis()));
            p.setEndDate(new Date(System.currentTimeMillis()));
        }

        // 4. Database Interaction
        ProjectDAO dao = new ProjectDAO();
        
        // A. Look up the real studentId from the accountId
        int realStudentId = dao.getStudentIdByAccount(user.getAccountId());
        
        if (realStudentId != -1) {
            p.setStudentId(realStudentId);
            
            // B. Save the project using your DAO Method 3
            boolean success = dao.createProject(p);

            if (success) {
                // Success: Go to Dashboard
                response.sendRedirect("StudentDashboardServlet");
            } else {
                // DB Error - sending back to the servlet URL
                response.sendRedirect("CreateProjectServlet?error=Database Insert Failed");
            }
        } else {
            // Error: No student profile linked to this account
            response.sendRedirect("CreateProjectServlet?error=No Student Profile Found");
        }
    }
}