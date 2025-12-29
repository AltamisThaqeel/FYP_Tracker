/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.ProjectDAO;
import com.fyp.model.Account;
import com.fyp.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/StudentDashboardServlet"})
public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        // 1. Security Check: Is user logged in and a Student?
        if (user == null || !user.getRoleType().equalsIgnoreCase("Student")) {
            response.sendRedirect(request.getContextPath() + "/index.html");
            return;
        }

        // 2. Fetch Project Data for this Student
        // We assume the studentID is the same as the email or we need to fetch the Student ID based on Account ID.
        // For this assignment, let's assume you stored the 'Student ID' in the session during login, 
        // OR we use the hardcoded sample ID "2025368237" (Rashdan) for testing if you haven't linked them yet.
        
        ProjectDAO dao = new ProjectDAO();
        
        // TEMPORARY: Hardcoded ID to test the display immediately (matches your sample DB data)
        // Later we will fetch the real ID from the Account object.
        String tempStudentId = "2025368237"; 
        
        Project myProject = dao.getProjectByStudent(tempStudentId);
        
        // 3. Attach data to the request
        request.setAttribute("project", myProject);
        
        // 4. Forward to the JSP
        request.getRequestDispatcher("student/dashboard.jsp").forward(request, response);
    }
}