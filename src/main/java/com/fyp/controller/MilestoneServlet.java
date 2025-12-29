/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.MilestoneDAO;
import com.fyp.model.Milestone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "MilestoneServlet", urlPatterns = {"/MilestoneServlet"})
public class MilestoneServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        MilestoneDAO dao = new MilestoneDAO();

        if (action != null && action.equals("add")) {
            // --- LOGIC TO ADD NEW TASK ---
            String taskDesc = request.getParameter("taskDesc");
            int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            
            Milestone m = new Milestone();
            m.setDescription(taskDesc);
            m.setProjectScheduleId(scheduleId);
            dao.addMilestone(m);
            
        } else if (action != null && action.equals("complete")) {
            // --- LOGIC TO MARK AS COMPLETED ---
            int milestoneId = Integer.parseInt(request.getParameter("milestoneId"));
            dao.updateStatus(milestoneId, "Completed");
        }

        // Redirect back to refresh the list
        response.sendRedirect("student/milestones.jsp");
    }
}