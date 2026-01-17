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

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/AdminDashboardServlet"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("--- AdminDashboardServlet STARTED ---"); // Debug Print

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        // 1. Security Check
        if (user == null || !user.getRoleType().equalsIgnoreCase("Admin")) {
            System.out.println("Redirecting: User is not Admin or not logged in.");
            response.sendRedirect("login.jsp");
            return;
        }

        AdminDAO dao = new AdminDAO();

        // 2. Fetch Counts
        request.setAttribute("statStudent", dao.getCount("STUDENT"));
        request.setAttribute("statSupervisor", dao.getCount("SUPERVISOR"));

        int totalProjs = dao.getCount("PROJECT");
        int compProjs = dao.getCompletedProjectCount();
        request.setAttribute("statProjectTotal", totalProjs);
        request.setAttribute("statProjectCompleted", compProjs);

        // 3. Fetch Lists
        List<Account> stList = dao.getAllStudents();
        List<Account> supList = dao.getAllSupervisors();
        List<Project> prList = dao.getAllProjects();

        request.setAttribute("studentList", stList);
        request.setAttribute("supervisorList", supList);
        request.setAttribute("projectList", prList);

        System.out.println("Data sent to JSP. Projects found: " + prList.size());

        // 4. Forward
        request.getRequestDispatcher("admin/admin_dashboard.jsp").forward(request, response);
    }
}
