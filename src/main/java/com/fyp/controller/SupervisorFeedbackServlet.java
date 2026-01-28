/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.FeedbackDAO;
import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Account;
import com.fyp.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "SupervisorFeedbackServlet", urlPatterns = {"/SupervisorFeedbackServlet"})
public class SupervisorFeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        // Security Check
        if (user == null || !user.getRoleType().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. Retrieve data
            String content = request.getParameter("feedbackContent");
            String projectIdStr = request.getParameter("projectId");
            String weekStr = request.getParameter("week");
            String studentId = request.getParameter("studentId");

            if (projectIdStr != null && weekStr != null && content != null) {
                int projectId = Integer.parseInt(projectIdStr);
                int weekNumber = Integer.parseInt(weekStr);

                SupervisorDAO sDao = new SupervisorDAO();
                int supervisorId = sDao.getSupervisorId(user.getAccountId());

                // 2. Create Object & Save
                Feedback f = new Feedback();
                f.setContent(content);
                f.setProjectId(projectId);
                f.setWeekNumber(weekNumber);
                f.setDateGiven(Date.valueOf(LocalDate.now()));
                f.setSupervisorId(supervisorId);

                FeedbackDAO dao = new FeedbackDAO();
                dao.saveOrUpdateFeedback(f);

                // 3. Redirect Back with Success Message & CORRECT PROJECT ID
                response.sendRedirect(request.getContextPath()
                        + "/SupervisorMilestoneServlet?studentId=" + studentId
                        + "&projectId=" + projectId
                        + "&week=" + weekNumber
                        + "&alert=success");
            } else {

                response.sendRedirect(request.getContextPath() + "/SupervisorDashboardServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/SupervisorDashboardServlet?error=true");
        }
    }
}
