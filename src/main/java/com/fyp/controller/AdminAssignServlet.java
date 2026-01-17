/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.AdminDAO;
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

@WebServlet(name = "AdminAssignServlet", urlPatterns = {"/AdminAssignServlet"})
public class AdminAssignServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null || !user.getRoleType().equalsIgnoreCase("Admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        AdminDAO dao = new AdminDAO();

        List<Project> projectList = dao.getAllProjectsForAssignment();
        List<Account> supervisorList = dao.getAllSupervisors();

        // ADDED: Get Student list so we can show names in the JSP
        List<Account> studentList = dao.getAllStudents();

        request.setAttribute("projectList", projectList);
        request.setAttribute("supervisorList", supervisorList);
        request.setAttribute("studentList", studentList); // Send to JSP

        request.getRequestDispatcher("admin/admin_assign.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            // Handle case where "Select Supervisor..." sends empty string or null
            String supParam = request.getParameter("supervisorId");
            int supervisorId = (supParam != null && !supParam.isEmpty()) ? Integer.parseInt(supParam) : 0;

            AdminDAO dao = new AdminDAO();
            boolean success = dao.assignSupervisor(projectId, supervisorId);

            if (success) {
                response.sendRedirect("AdminAssignServlet?alert=success");
            } else {
                response.sendRedirect("AdminAssignServlet?alert=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminAssignServlet?alert=error");
        }
    }
}
