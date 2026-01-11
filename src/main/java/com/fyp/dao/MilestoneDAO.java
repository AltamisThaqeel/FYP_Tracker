package com.fyp.dao;

import com.fyp.model.Milestone;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MilestoneDAO {

    // ==========================================
    //  EXISTING SUPERVISOR METHODS (DO NOT DELETE)
    // ==========================================
    
    // Likely looks something like this in your current file:
    public List<Milestone> getMilestonesBySchedule(int scheduleId) {
        // ... your existing code ...
        return null; // placeholder
    }

    public void addMilestone(Milestone m) {
        // ... your existing code ...
    }

    public void updateStatus(int id, String status) {
        // ... your existing code ...
    }

    // ==========================================
    //  NEW METHOD FOR STUDENT DASHBOARD (ADD THIS)
    // ==========================================
    
    public List<Milestone> getMilestonesByProjectId(int projectId) {
        List<Milestone> list = new ArrayList<>();
        
        try (Connection con = DBConnection.getConnection()) {
            
            // Query the database using project_id
            String sql = "SELECT * FROM milestone WHERE project_id = ?"; 
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Milestone m = new Milestone();
                
                // MAP DB COLUMNS TO YOUR EXISTING MODEL FIELDS
                
                // 1. ID
                m.setMilestoneId(rs.getInt("milestone_id")); 
                
                // 2. Description (Use 'description' because your Model has it)
                m.setDescription(rs.getString("description")); 
                
                // 3. Status
                m.setStatus(rs.getString("status"));
                
                // 4. Project ID link (Bridge the gap)
                // Your Model has 'projectScheduleId', DB has 'project_id'
                m.setProjectScheduleId(rs.getInt("project_id")); 
                
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- NEW METHOD: Get Schedule ID for a Project ---
    public int getScheduleIdByProject(int projectId) {
        int scheduleId = -1;
        try {
            Connection con = DBConnection.getConnection();
            // We find the schedule linked to this project
            String sql = "SELECT project_schedule_id FROM PROJECT_SCHEDULE WHERE projectId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                scheduleId = rs.getInt("project_schedule_id");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return scheduleId;
    }

    // 1. Calculate Progress % for a specific Project
    public int getProjectProgress(int projectId) {
        int total = 0;
        int completed = 0;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT m.status FROM MILESTONE m "
                    + "JOIN PROJECT_SCHEDULE ps ON m.project_schedule_id = ps.project_schedule_id "
                    + "WHERE ps.projectId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                total++;
                if ("Completed".equalsIgnoreCase(rs.getString("status"))) {
                    completed++;
                }
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (total == 0) {
            return 0; // Avoid division by zero
        }
        return (int) ((double) completed / total * 100);
    }

    // 2. Count Milestones Due in a Specific Week (e.g., Week 1)
    public int countMilestonesByWeek(int supervisorId, int week) {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT count(*) FROM MILESTONE m "
                    + "JOIN PROJECT_SCHEDULE ps ON m.project_schedule_id = ps.project_schedule_id "
                    + "JOIN PROJECT p ON ps.projectId = p.projectId "
                    + "WHERE p.supervisorId = ? AND ps.week_num = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, supervisorId);
            ps.setInt(2, week);
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

    // 3. Count TOTAL Milestones for this Supervisor
    public int countTotalMilestones(int supervisorId) {
        int count = 0;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT count(*) FROM MILESTONE m "
                    + "JOIN PROJECT_SCHEDULE ps ON m.project_schedule_id = ps.project_schedule_id "
                    + "JOIN PROJECT p ON ps.projectId = p.projectId "
                    + "WHERE p.supervisorId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, supervisorId);
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

} // End of Class