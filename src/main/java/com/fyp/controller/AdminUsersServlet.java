/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.fyp.controller;

import com.fyp.dao.AdminDAO;
import com.fyp.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUsersServlet", urlPatterns = {"/AdminUsersServlet"})
public class AdminUsersServlet extends HttpServlet {

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
        List<Account> list = dao.getAllAccounts();
        request.setAttribute("userList", list);

        request.getRequestDispatcher("admin/admin_users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        // capture the current tab from the form, default to 'admin'
        String currentTab = request.getParameter("tab");
        if (currentTab == null || currentTab.isEmpty()) {
            currentTab = "admin";
        }

        AdminDAO dao = new AdminDAO();

        if ("createAdmin".equals(action)) {
            String name = request.getParameter("fullname");
            String email = request.getParameter("email");
            String pass = request.getParameter("password");

            boolean success = dao.createAdmin(email, pass, name);
            if (success) {
                // Return to Admin tab
                response.sendRedirect("AdminUsersServlet?alert=created&tab=admin");
            } else {
                response.sendRedirect("AdminUsersServlet?alert=error&tab=admin");
            }

        } else if ("toggleStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String currentStatus = request.getParameter("status");
            String newStatus = "Active".equalsIgnoreCase(currentStatus) ? "Inactive" : "Active";

            dao.updateAccountStatus(id, newStatus);
            // Return to the tab where the action happened
            response.sendRedirect("AdminUsersServlet?alert=updated&tab=" + currentTab);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = dao.deleteAccount(id); // Capture result

            if (success) {
                response.sendRedirect("AdminUsersServlet?alert=deleted&tab=" + currentTab);
            } else {
                response.sendRedirect("AdminUsersServlet?alert=error&tab=" + currentTab);
            }
        }
    }
}
