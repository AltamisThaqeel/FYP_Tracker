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

        // 1. Retrieve data
        String content = request.getParameter("feedbackContent");
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        int weekNumber = Integer.parseInt(request.getParameter("week"));
        // We need studentId to redirect back correctly
        String studentId = request.getParameter("studentId");

        SupervisorDAO sDao = new SupervisorDAO();
        int supervisorId = sDao.getSupervisorId(user.getAccountId());

        // 2. Create Object
        Feedback f = new Feedback();
        f.setContent(content);
        f.setProjectId(projectId);
        f.setWeekNumber(weekNumber);
        f.setDateGiven(Date.valueOf(LocalDate.now()));
        f.setSupervisorId(supervisorId);

        // 3. Save (Upsert)
        FeedbackDAO dao = new FeedbackDAO();
        dao.saveOrUpdateFeedback(f);

        // 4. Redirect Back with Success Message
        response.sendRedirect(request.getContextPath()
                + "/SupervisorMilestoneServlet?studentId=" + studentId + "&week=" + weekNumber + "&alert=success");
    }
}
