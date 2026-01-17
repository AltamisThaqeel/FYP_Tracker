package com.fyp.dao;

import com.fyp.model.Milestone;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MilestoneDAO {

    // ==========================================================
    //  1. METHODS FOR SUPERVISOR MILESTONE VIEW (Fixes SupervisorMilestoneServlet)
    // ==========================================================
    
    public List<Milestone> getMilestonesBySchedule(int scheduleId) {
        List<Milestone> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM milestone WHERE project_schedule_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Milestone m = new Milestone();
                // Using lowercase column names as per your preference
                m.setMilestoneId(rs.getInt("milestoneId"));
                m.setDescription(rs.getString("milestone_desc")); 
                m.setStatus(rs.getString("status"));
                m.setProjectScheduleId(rs.getInt("project_schedule_id"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; 
    }

    public int getScheduleIdByProject(int projectId) {
        int scheduleId = -1;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT project_schedule_id FROM project_schedule WHERE projectId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                scheduleId = rs.getInt("project_schedule_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return scheduleId;
    }
    
    // Kept for backward compatibility if Supervisor uses a different Add logic
    public void addMilestone(Milestone m) {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO milestone (milestone_desc, status, project_schedule_id) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, m.getDescription());
            ps.setString(2, "Pending"); 
            ps.setInt(3, m.getProjectScheduleId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ==========================================================
    //  2. METHODS FOR STUDENT WEEKLY VIEW (Fixes MilestoneServlet)
    // ==========================================================
    
    public List<Milestone> getMilestonesByProjectAndWeek(int projectId, int weekNum) {
        List<Milestone> list = new ArrayList<>();
        String sql = "SELECT m.* FROM milestone m " +
                     "JOIN project_schedule s ON m.project_schedule_id = s.project_schedule_id " +
                     "WHERE s.projectId = ? AND s.week_num = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setInt(2, weekNum);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Milestone m = new Milestone();
                m.setMilestoneId(rs.getInt("milestoneId"));
                m.setDescription(rs.getString("milestone_desc"));
                m.setStatus(rs.getString("status"));
                m.setProjectScheduleId(rs.getInt("project_schedule_id"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // This is the specific method MilestoneServlet uses to ADD tasks dynamically
    public boolean addMilestone(String description, int projectId, int weekNum) {
        try (Connection con = DBConnection.getConnection()) {
            int scheduleId = getOrCreateSchedule(con, projectId, weekNum);
            String sql = "INSERT INTO milestone (milestone_desc, status, project_schedule_id) VALUES (?, 'Not Started', ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, description);
            ps.setInt(2, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper to auto-create schedule if it doesn't exist for that week
    private int getOrCreateSchedule(Connection con, int projectId, int weekNum) throws Exception {
        String checkSql = "SELECT project_schedule_id FROM project_schedule WHERE projectId = ? AND week_num = ?";
        PreparedStatement psCheck = con.prepareStatement(checkSql);
        psCheck.setInt(1, projectId);
        psCheck.setInt(2, weekNum);
        ResultSet rs = psCheck.executeQuery();

        if (rs.next()) {
            return rs.getInt("project_schedule_id");
        } else {
            String insertSql = "INSERT INTO project_schedule (projectId, week_num) VALUES (?, ?)";
            PreparedStatement psInsert = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            psInsert.setInt(1, projectId);
            psInsert.setInt(2, weekNum);
            psInsert.executeUpdate();
            ResultSet rsKeys = psInsert.getGeneratedKeys();
            if (rsKeys.next()) return rsKeys.getInt(1);
        }
        return -1;
    }

    // ==========================================================
    //  3. METHODS FOR SUPERVISOR DASHBOARD (Fixes SupervisorDashboardServlet)
    // ==========================================================

    public int getProjectProgress(int projectId) {
        int total = 0, completed = 0;
        String sql = "SELECT m.status FROM MILESTONE m " + 
                 "JOIN PROJECT_SCHEDULE ps ON m.project_schedule_id = ps.project_schedule_id " + 
                 "WHERE ps.projectId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                total++;
                if ("Completed".equalsIgnoreCase(rs.getString("status"))) completed++;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return (total == 0) ? 0 : (int) ((double) completed / total * 100);
    }

    public int countMilestonesByWeek(int supervisorId, int week) {
        int count = 0;
        String sql = "SELECT count(*) FROM milestone m " + 
                     "JOIN project_schedule ps ON m.project_schedule_id = ps.project_schedule_id " + 
                     "JOIN project p ON ps.projectId = p.projectId " + 
                     "WHERE p.supervisorId = ? AND ps.week_num = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, supervisorId);
            ps.setInt(2, week);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public int countTotalMilestones(int supervisorId) {
        int count = 0;
        String sql = "SELECT count(*) FROM milestone m " + 
                     "JOIN project_schedule ps ON m.project_schedule_id = ps.project_schedule_id " + 
                     "JOIN project p ON ps.projectId = p.projectId " + 
                     "WHERE p.supervisorId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, supervisorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // ==========================================================
    //  4. UTILITIES (Used by Both)
    // ==========================================================

    public void updateStatus(int id, String status) {
        String sql = "UPDATE milestone SET status = ? WHERE milestoneId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // --- NEW: Count TOTAL Milestones for a Project (All Weeks) ---
    public int countAllMilestonesForProject(int projectId) {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT count(*) FROM MILESTONE m "
                    + "JOIN PROJECT_SCHEDULE ps ON m.project_schedule_id = ps.project_schedule_id "
                    + "WHERE ps.projectId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
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

    // --- NEW: Count COMPLETED Milestones for a Project (All Weeks) ---
    public int countCompletedMilestonesForProject(int projectId) {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT count(*) FROM MILESTONE m "
                    + "JOIN PROJECT_SCHEDULE ps ON m.project_schedule_id = ps.project_schedule_id "
                    + "WHERE ps.projectId = ? AND m.status = 'Completed'";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
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

    // --- ADD THIS MISSING METHOD ---
    public int getScheduleIdByProjectAndWeek(int projectId, int weekNum) {
        int scheduleId = -1;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT project_schedule_id FROM project_schedule WHERE projectId = ? AND week_num = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            ps.setInt(2, weekNum);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                scheduleId = rs.getInt("project_schedule_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return scheduleId;
    }
    
    public List<Milestone> getMilestonesByProject(int projectId) {
        List<Milestone> list = new ArrayList<>();
        // This query joins with project_schedule to get the week_num for each task
        String sql = "SELECT m.*, ps.week_num FROM milestone m " +
                     "JOIN project_schedule ps ON m.project_schedule_id = ps.project_schedule_id " +
                     "WHERE ps.projectId = ? " +
                     "ORDER BY ps.week_num ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Milestone m = new Milestone();
                m.setMilestoneId(rs.getInt("milestoneId"));
                m.setDescription(rs.getString("milestone_desc"));
                m.setStatus(rs.getString("status"));
                m.setProjectScheduleId(rs.getInt("project_schedule_id"));
                // IMPORTANT: This requires a setWeekNum method in your Milestone model
                m.setWeekNum(rs.getInt("week_num")); 
                list.add(m);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
}