/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.dao;

import com.fyp.model.Milestone;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MilestoneDAO {

    // 1. Get all milestones for a specific Project Schedule (Week)
    public List<Milestone> getMilestonesBySchedule(int scheduleId) {
        List<Milestone> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM MILESTONE WHERE PROJECT_SCHEDULE_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Milestone m = new Milestone();
                m.setMilestoneId(rs.getInt("milestoneid"));
                m.setDescription(rs.getString("milestone_desc")); // Must match DB column name
                m.setStatus(rs.getString("status"));
                m.setProjectScheduleId(rs.getInt("project_schedule_id"));
                list.add(m);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Add a new Milestone
    public void addMilestone(Milestone m) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO MILESTONE (milestone_desc, status, project_schedule_id) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, m.getDescription());
            ps.setString(2, "Pending"); // Default status
            ps.setInt(3, m.getProjectScheduleId());
            ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 3. Update Milestone Status
    public void updateStatus(int milestoneId, String newStatus) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE MILESTONE SET STATUS = ? WHERE MILESTONEID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, milestoneId);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}