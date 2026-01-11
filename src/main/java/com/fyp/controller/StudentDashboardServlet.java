package com.fyp.controller;

import com.fyp.dao.MilestoneDAO;
import com.fyp.dao.ProjectDAO;
import com.fyp.model.Account;
import com.fyp.model.Project;
import java.io.IOException;
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

        // 1. Security Check
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        ProjectDAO pDao = new ProjectDAO();
        MilestoneDAO mDao = new MilestoneDAO();
        
        // 2. Get the real studentId using the accountId
        int studentId = pDao.getStudentIdByAccount(user.getAccountId());
        
        if (studentId != -1) {
            // 3. Fetch the project
            Project myProject = pDao.getProjectByStudent(studentId);
            
            if (myProject != null) {
                // 4. Calculate REAL Progress based on Milestones
                int progress = mDao.getProjectProgress(myProject.getProjectId());
                myProject.setProgress(progress);
                
                request.setAttribute("project", myProject);
            }
        }

        // 5. Forward to the JSP page
        request.getRequestDispatcher("student/student_dashboard.jsp").forward(request, response);
    }
}