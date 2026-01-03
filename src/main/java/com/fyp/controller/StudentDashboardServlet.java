package com.fyp.controller;

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

        ProjectDAO projectDAO = new ProjectDAO();
        
        // 2. Get the real studentId using the accountId
        int studentId = projectDAO.getStudentIdByAccount(user.getAccountId());
        
        if (studentId != -1) {
            // 3. Fetch the project using the INT studentId
            Project myProject = projectDAO.getProjectByStudent(studentId);
            
            // 4. Send the project object to the JSP
            request.setAttribute("project", myProject);
        }

        // 5. Forward to the JSP page
        request.getRequestDispatcher("student/student_dashboard.jsp").forward(request, response);
    }
}