/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.MilestoneDAO;
import com.fyp.model.Account;
import com.fyp.model.Milestone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupervisorProgressServlet", urlPatterns = {"/SupervisorProgressServlet"})
public class SupervisorProgressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        if (user == null || !user.getRoleType().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("index.html");
            return;
        }

        // 1. Get Project ID from the URL link
        String pIdStr = request.getParameter("projectId");
        
        // Default to Project ID 1 if null (for safety)
        int projectId = (pIdStr != null) ? Integer.parseInt(pIdStr) : 1;

        // 2. Fetch Milestones
        // NOTE: In a full real system, you would query the Schedule ID based on Project + Week.
        // For this assignment prototype, we assume "Week 1" is linked to Schedule ID 1.
        // If you want to make this dynamic later, you'd need a ScheduleDAO.
        int scheduleId = 1; 
        
        MilestoneDAO dao = new MilestoneDAO();
        List<Milestone> milestones = dao.getMilestonesBySchedule(scheduleId);
        
        // 3. Send data to the JSP
        request.setAttribute("milestoneList", milestones);
        request.setAttribute("projectId", projectId);
        
        // 4. Open the Review Page
        request.getRequestDispatcher("supervisor/view_milestones.jsp").forward(request, response);
    }
}