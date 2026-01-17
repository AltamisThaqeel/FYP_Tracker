package com.fyp.dao;

import com.fyp.model.Account;
import com.fyp.model.Project;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SupervisorDAO {

    // 1. Get Projects By Supervisor ID (Simple)
    public List<Project> getProjectsBySupervisor(int supervisorId) {
        List<Project> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM PROJECT WHERE SUPERVISORID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, supervisorId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Project p = new Project();
                p.setProjectId(rs.getInt("projectid"));
                p.setTitle(rs.getString("project_title"));
                p.setDescription(rs.getString("project_desc"));
                p.setStatus(rs.getString("project_status"));
                p.setStudentId(rs.getInt("studentId"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
            }
        }
        return list;
    }

    // 2. Register Supervisor
    public void registerSupervisor(String phone, int accountId) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO SUPERVISOR (phoneNum, position, accountid) VALUES (?, 'Lecturer', ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, phone);
            ps.setInt(2, accountId);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Get Projects WITH Details (UPDATED: Maps Phone Number)
    public List<Project> getProjectsWithDetails(int supervisorId) {
        List<Project> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String sql = "SELECT p.*, a.full_name, s.phoneNum, c.category_name "
                    + "FROM PROJECT p "
                    + "LEFT JOIN STUDENT s ON p.studentid = s.studentid "
                    + "LEFT JOIN ACCOUNT a ON s.accountid = a.accountid "
                    + "LEFT JOIN PROJECT_CATEGORY c ON p.categoryid = c.categoryid "
                    + "WHERE p.supervisorid = ?";

            ps = con.prepareStatement(sql);
            ps.setInt(1, supervisorId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Project p = new Project();
                p.setProjectId(rs.getInt("projectid"));
                p.setTitle(rs.getString("project_title"));
                p.setDescription(rs.getString("project_desc"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setStatus(rs.getString("project_status"));
                p.setStudentId(rs.getInt("studentid"));
                p.setCategoryName(rs.getString("category_name"));
                p.setContactPhone(rs.getString("phoneNum"));

                try {
                    p.setProgress(rs.getInt("progress"));
                } catch (Exception ex) {
                    p.setProgress(0);
                }

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
            }
        }
        return list;
    }

    // 4. Get Supervisor ID
    public int getSupervisorId(int accountId) {
        int supervisorId = -1;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT supervisorId FROM SUPERVISOR WHERE accountId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                supervisorId = rs.getInt("supervisorId");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return supervisorId;
    }

    // 5. Get Students for Name Lookup (FIXED: Declared variables properly)
    public List<Account> getMyStudents(int supervisorId) {
        List<Account> list = new ArrayList<>();
        // --- FIX: Variables declared here ---
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT DISTINCT s.studentid, a.full_name, a.email "
                    + "FROM PROJECT p "
                    + "LEFT JOIN STUDENT s ON p.studentid = s.studentid "
                    + "LEFT JOIN ACCOUNT a ON s.accountid = a.accountid "
                    + "WHERE p.supervisorid = ? AND s.studentid IS NOT NULL";

            ps = con.prepareStatement(sql);
            ps.setInt(1, supervisorId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Account a = new Account();
                a.setAccountId(rs.getInt("studentid")); // Use AccountID to hold StudentID
                a.setFullName(rs.getString("full_name"));
                a.setEmail(rs.getString("email"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
            }
        }
        return list;
    }
}
