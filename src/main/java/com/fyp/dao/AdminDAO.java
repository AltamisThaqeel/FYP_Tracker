package com.fyp.dao;

import com.fyp.model.Account;
import com.fyp.model.Project;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    // 1. Basic Count
    public int getCount(String tableName) {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM " + tableName;
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // 2. Completed Projects Count
    public int getCompletedProjectCount() {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            
            // --- FIX START: Auto-update status based on progress ---
            // This ensures that if progress is 100, the status becomes 'Completed' automatically
            String updateSql = "UPDATE PROJECT SET project_status = 'Completed' WHERE progress = 100";
            PreparedStatement psUpdate = con.prepareStatement(updateSql);
            psUpdate.executeUpdate();
            psUpdate.close(); 
            // --- FIX END ---

            // Now count the projects that are effectively completed
            String sql = "SELECT COUNT(*) FROM PROJECT WHERE project_status = 'Completed'";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // 3. Get All Students
    public List<Account> getAllStudents() {
        List<Account> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT s.studentid, a.full_name, a.email FROM STUDENT s JOIN ACCOUNT a ON s.accountid = a.accountid";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account a = new Account();
                a.setAccountId(rs.getInt("studentid"));
                a.setFullName(rs.getString("full_name"));
                a.setEmail(rs.getString("email"));
                list.add(a);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Get All Supervisors
    public List<Account> getAllSupervisors() {
        List<Account> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT s.supervisorid, a.full_name, a.email FROM SUPERVISOR s JOIN ACCOUNT a ON s.accountid = a.accountid";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account a = new Account();
                a.setAccountId(rs.getInt("supervisorid"));
                a.setFullName(rs.getString("full_name"));
                a.setEmail(rs.getString("email"));
                list.add(a);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 5. Get All Projects
    public List<Project> getAllProjects() {
        List<Project> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT projectid, project_title, project_status FROM PROJECT";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Project p = new Project();
                p.setProjectId(rs.getInt("projectid"));
                p.setTitle(rs.getString("project_title"));
                p.setStatus(rs.getString("project_status"));
                list.add(p);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 6. Get All Projects (Fixed for your Project.java)
    public List<Project> getAllProjectsForAssignment() {
        List<Project> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            // We only fetch columns that map to Project.java fields
            String sql = "SELECT p.projectid, p.project_title, p.project_status, "
                    + "p.supervisorid, p.studentid "
                    + "FROM PROJECT p "
                    + "ORDER BY CASE WHEN p.supervisorid IS NULL THEN 0 ELSE 1 END, p.projectid ASC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Project p = new Project();
                p.setProjectId(rs.getInt("projectid"));
                p.setTitle(rs.getString("project_title")); // Helper method in your Project.java
                p.setStatus(rs.getString("project_status"));
                p.setSupervisorId(rs.getInt("supervisorid")); // 0 if null
                p.setStudentId(rs.getInt("studentid"));       // 0 if null

                // REMOVED: p.setStudentName(...) and p.setSupervisorName(...)
                // because your Project.java does not have them.
                list.add(p);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 7. Assign Supervisor
    public boolean assignSupervisor(int projectId, int supervisorId) {
        boolean success = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE PROJECT SET supervisorid = ? WHERE projectid = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, supervisorId);
            ps.setInt(2, projectId);
            success = ps.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    // 8. Get ALL Accounts
    public List<Account> getAllAccounts() {
        List<Account> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM ACCOUNT ORDER BY role_type, accountid";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account a = new Account();
                a.setAccountId(rs.getInt("accountid"));
                a.setEmail(rs.getString("email"));
                a.setRoleType(rs.getString("role_type"));
                a.setFullName(rs.getString("full_name"));
                a.setStatus(rs.getString("status"));
                list.add(a);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 9. Update Status
    public boolean updateAccountStatus(int accountId, String newStatus) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE ACCOUNT SET status = ? WHERE accountid = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, accountId);
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 10. Delete Account
    public boolean deleteAccount(int accountId) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Check Role
            String getRoleSql = "SELECT role_type FROM ACCOUNT WHERE accountid = ?";
            PreparedStatement psRole = con.prepareStatement(getRoleSql);
            psRole.setInt(1, accountId);
            ResultSet rs = psRole.executeQuery();
            String role = "";
            if (rs.next()) {
                role = rs.getString("role_type");
            }
            psRole.close();
            rs.close();

            if ("Student".equalsIgnoreCase(role)) {
                // Delete Student Dependencies... (Same as previous logic)
                int studentId = -1;
                PreparedStatement psSid = con.prepareStatement("SELECT studentid FROM STUDENT WHERE accountid = ?");
                psSid.setInt(1, accountId);
                ResultSet rsS = psSid.executeQuery();
                if (rsS.next()) {
                    studentId = rsS.getInt("studentid");
                }
                psSid.close();
                rsS.close();

                if (studentId != -1) {
                    // Delete sub-tables
                    con.createStatement().executeUpdate("DELETE FROM MILESTONE WHERE project_schedule_id IN (SELECT project_schedule_id FROM PROJECT_SCHEDULE WHERE projectId IN (SELECT projectId FROM PROJECT WHERE studentid = " + studentId + "))");
                    con.createStatement().executeUpdate("DELETE FROM PROJECT_SCHEDULE WHERE projectId IN (SELECT projectId FROM PROJECT WHERE studentid = " + studentId + ")");
                    con.createStatement().executeUpdate("DELETE FROM FEEDBACK WHERE projectid IN (SELECT projectid FROM PROJECT WHERE studentid = " + studentId + ")");
                    con.createStatement().executeUpdate("DELETE FROM PROJECT WHERE studentid = " + studentId);
                    con.createStatement().executeUpdate("DELETE FROM STUDENT WHERE accountid = " + accountId);
                }
            } else if ("Supervisor".equalsIgnoreCase(role)) {
                int supervisorId = -1;
                PreparedStatement psSupId = con.prepareStatement("SELECT supervisorid FROM SUPERVISOR WHERE accountid = ?");
                psSupId.setInt(1, accountId);
                ResultSet rsSup = psSupId.executeQuery();
                if (rsSup.next()) {
                    supervisorId = rsSup.getInt("supervisorid");
                }
                psSupId.close();
                rsSup.close();

                if (supervisorId != -1) {
                    con.createStatement().executeUpdate("UPDATE PROJECT SET supervisorid = NULL WHERE supervisorid = " + supervisorId);
                    con.createStatement().executeUpdate("DELETE FROM SUPERVISOR WHERE accountid = " + accountId);
                }
            }

            con.createStatement().executeUpdate("DELETE FROM ACCOUNT WHERE accountid = " + accountId);
            con.commit();
            return true;
        } catch (Exception e) {
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
            }
        }
    }

    // 11. Create Admin
    public boolean createAdmin(String email, String password, String fullName) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO ACCOUNT (email, hash_pass, full_name, role_type, status) VALUES (?, ?, ?, 'Admin', 'Active')";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, fullName);
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
