/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Account;
import com.fyp.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentListServlet", urlPatterns = {"/StudentListServlet"})
public class StudentListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        // Security Check
        if (user == null || !user.getRoleType().equalsIgnoreCase("Supervisor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Fetch Projects using the new DAO method
        SupervisorDAO dao = new SupervisorDAO();

        int supervisorId = dao.getSupervisorId(user.getAccountId());

        
        List<Project> projectList = dao.getProjectsWithDetails(supervisorId);
        
        // 2. Pass data to JSP
        request.setAttribute("projectList", projectList);
        
        // 3. Forward to your JSP
        request.getRequestDispatcher("supervisor/student_list.jsp").forward(request, response);
    }
}