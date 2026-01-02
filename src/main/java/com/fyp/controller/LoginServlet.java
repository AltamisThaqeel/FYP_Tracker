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

        // 1. Retrieve Form Data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role"); // "student" or "supervisor"
        String rememberMe = request.getParameter("remember"); // Checkbox value

        // 2. Validate Credentials against Database
        AccountDAO dao = new AccountDAO();
        Account account = dao.login(email, password);

        if (account == null) {
            // Case A: Account not found or wrong password
            response.sendRedirect("login.jsp?error=InvalidCredentials");
            return;
        }

        // 3. Validate Role Selection
        // The DB role (e.g., "STUDENT") might differ in case from dropdown ("student")
        if (!account.getRoleType().equalsIgnoreCase(selectedRole)) {
            // Case B: Correct password, but wrong role selected
            response.sendRedirect("login.jsp?error=RoleMismatch");
            return;
        }

        // 4. Handle "Remember Me" Cookie
        Cookie cookie = new Cookie("c_email", email);
        if (rememberMe != null) {
            cookie.setMaxAge(60 * 60 * 24 * 7); // Store for 7 Days
        } else {
            cookie.setMaxAge(0); // Delete cookie if unchecked
        }
        response.addCookie(cookie);

        // 5. Create Session (Login Success)
        HttpSession session = request.getSession();
        session.setAttribute("user", account);
        session.setAttribute("role", account.getRoleType());

        // Save the specific ID (StudentId or SupervisorId) for queries later
        // Note: You'll need to fetch the specific ID using Account ID,
        // but for now, we redirect to the correct dashboard.
        // 6. Redirect to Dashboard
        if ("Supervisor".equalsIgnoreCase(account.getRoleType())) {
            response.sendRedirect("SupervisorDashboardServlet");
        } else {
            response.sendRedirect("StudentDashboardServlet");
        }
    }
}
