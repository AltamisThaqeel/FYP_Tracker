package com.fyp.controller;

import com.fyp.dao.AccountDAO;
import com.fyp.dao.StudentDAO;
import com.fyp.dao.SupervisorDAO;
import com.fyp.model.Account;
import com.fyp.model.Student;
import com.fyp.model.Supervisor;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        // Security Check
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = user.getRoleType();
        
        // Fetch extended profile data based on role
        if ("Student".equalsIgnoreCase(role)) {
            StudentDAO sDao = new StudentDAO();
            Student studentDetails = sDao.getStudentByAccount(user.getAccountId());
            request.setAttribute("profileDetails", studentDetails);
            
        } else if ("Supervisor".equalsIgnoreCase(role) || "Admin".equalsIgnoreCase(role)) {
            SupervisorDAO supDao = new SupervisorDAO();
            Supervisor supervisorDetails = supDao.getSupervisorByAccount(user.getAccountId());
            request.setAttribute("profileDetails", supervisorDetails);
        }

        // Forward to the profile JSP
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Common Data (Account Table)
        String fullName = request.getParameter("fullName");
        AccountDAO aDao = new AccountDAO();
        
        boolean accountUpdated = aDao.updateAccountName(user.getAccountId(), fullName);
        if (accountUpdated) {
            user.setFullName(fullName); // Update the session object name immediately
        }

        String role = user.getRoleType();
        boolean detailsUpdated = false;

        // 2. Role-Specific Data (Student or Supervisor Table)
        if ("Student".equalsIgnoreCase(role)) {
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String enrollmentYear = request.getParameter("enrollmentYear");
            String specialization = request.getParameter("specialization");
            String educationType = request.getParameter("educationType");
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            
            StudentDAO sDao = new StudentDAO();
            detailsUpdated = sDao.updateStudentProfile(studentId, phone, address, enrollmentYear, specialization, educationType);

        } else if ("Supervisor".equalsIgnoreCase(role) || "Admin".equalsIgnoreCase(role)) {
            String phone = request.getParameter("phone");
            String position = request.getParameter("position");
            int supervisorId = Integer.parseInt(request.getParameter("supervisorId"));
            
            SupervisorDAO supDao = new SupervisorDAO();
            detailsUpdated = supDao.updateSupervisorProfile(supervisorId, phone, position);
        }

        // 3. Redirect with Status
        if (accountUpdated || detailsUpdated) {
            response.sendRedirect("ProfileServlet?status=success");
        } else {
            response.sendRedirect("ProfileServlet?status=error");
        }
    }
}