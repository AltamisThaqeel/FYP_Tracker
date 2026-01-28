package com.fyp.controller;

import com.fyp.dao.FeedbackDAO;
import com.fyp.dao.ProjectDAO;
import com.fyp.model.Account;
import com.fyp.model.Feedback;
import com.fyp.model.Project;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StudentFeedbackServlet", urlPatterns = {"/StudentFeedbackServlet"})
public class StudentFeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null || !"Student".equals(user.getRoleType())) {
            response.sendRedirect("login.jsp");
            return;
        }

        ProjectDAO pDao = new ProjectDAO();
        FeedbackDAO fDao = new FeedbackDAO();

        int studentId = pDao.getStudentIdByAccount(user.getAccountId());
        Project project = pDao.getProjectByStudent(studentId);

        if (project != null) {
            List<Feedback> feedbackList = fDao.getAllFeedbackByProject(project.getProjectId());
            request.setAttribute("feedbackList", feedbackList);
        }
        String action = request.getParameter("action");
        if ("markRead".equals(action)) {
            int fbId = Integer.parseInt(request.getParameter("id"));
            fDao.markAsRead(fbId);
            response.setStatus(200); 
            return;
        }

        request.getRequestDispatcher("student/feedback.jsp").forward(request, response);
    }
}