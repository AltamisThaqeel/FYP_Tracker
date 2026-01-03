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

} // End of Class