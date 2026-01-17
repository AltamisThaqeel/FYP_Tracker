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

        SupervisorDAO dao = new SupervisorDAO();
        int supervisorId = dao.getSupervisorId(user.getAccountId());

        // 1. Fetch Projects (contains contactPhone)
        List<Project> projectList = dao.getProjectsWithDetails(supervisorId);

        // 2. Fetch Students (for Name lookup) -- ADDED THIS
        List<Account> studentList = dao.getMyStudents(supervisorId);

        // 3. Pass data to JSP
        request.setAttribute("projectList", projectList);
        request.setAttribute("studentList", studentList); // -- ADDED THIS

        // 4. Forward to your JSP
        request.getRequestDispatcher("supervisor/student_list.jsp").forward(request, response);
    }
}
