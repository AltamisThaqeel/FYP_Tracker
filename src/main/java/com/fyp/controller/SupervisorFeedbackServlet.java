/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.FeedbackDAO;
import com.fyp.model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "SupervisorFeedbackServlet", urlPatterns = {"/SupervisorFeedbackServlet"})
public class SupervisorFeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Retrieve data from the form
        String content = request.getParameter("feedbackContent");
        String pIdStr = request.getParameter("projectId");
        String weekStr = request.getParameter("week");
        
        int projectId = Integer.parseInt(pIdStr);
        int weekNumber = Integer.parseInt(weekStr);
        
        // 2. Create Feedback Object
        Feedback f = new Feedback();
        f.setContent(content);
        f.setProjectId(projectId);
        f.setWeekNumber(weekNumber);
        f.setDateGiven(Date.valueOf(LocalDate.now())); // Current Date
        f.setSupervisorId(1); // Hardcoded Supervisor ID 1 for this assignment
        
        // 3. Save to Database
        FeedbackDAO dao = new FeedbackDAO();
        dao.addFeedback(f);
        
        // 4. Redirect back to the view page
        // We pass the projectId back so the page reloads the correct student
        response.sendRedirect("SupervisorProgressServlet?projectId=" + projectId);
    }
}