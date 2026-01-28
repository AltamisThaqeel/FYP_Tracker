package com.fyp.controller;

import com.fyp.dao.AccountDAO;
import com.fyp.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role");
        String rememberMe = request.getParameter("remember");

        AccountDAO dao = new AccountDAO();
        Account account = dao.login(email, password);

        if (account == null) {
            response.sendRedirect("login.jsp?error=InvalidCredentials");
            return;
        }

        if (!account.getRoleType().equalsIgnoreCase(selectedRole)) {
            response.sendRedirect("login.jsp?error=RoleMismatch");
            return;
        }

        Cookie cookie = new Cookie("c_email", email);
        if (rememberMe != null) {
            cookie.setMaxAge(60 * 60 * 24 * 7); // 7 Days
        } else {
            cookie.setMaxAge(0);
        }
        response.addCookie(cookie);

        HttpSession session = request.getSession();
        session.setAttribute("user", account);
        session.setAttribute("role", account.getRoleType());

        if ("Student".equalsIgnoreCase(account.getRoleType())) {
            response.sendRedirect("StudentDashboardServlet");

        } else if ("Supervisor".equalsIgnoreCase(account.getRoleType())) {
            response.sendRedirect("SupervisorDashboardServlet");

        } else if ("Admin".equalsIgnoreCase(account.getRoleType())) {
            response.sendRedirect("AdminDashboardServlet");

        } else {
            response.sendRedirect("login.jsp?error=UnknownRole");
        }
    }
}
