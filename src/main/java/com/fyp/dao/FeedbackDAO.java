/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.dao;

import com.fyp.model.Feedback;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class FeedbackDAO {

    public void addFeedback(Feedback f) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            // Matching the FEEDBACK table columns from your ERD
            String sql = "INSERT INTO FEEDBACK (date_given, week_number, content, status, projectid, supervisorid) VALUES (?, ?, ?, ?, ?, ?)";
            
            ps = con.prepareStatement(sql);
            ps.setDate(1, f.getDateGiven());
            ps.setInt(2, f.getWeekNumber());
            ps.setString(3, f.getContent());
            ps.setString(4, "Unread"); // Default status
            ps.setInt(5, f.getProjectId());
            ps.setInt(6, f.getSupervisorId()); // We will use ID 1 for now
            
            ps.executeUpdate();
            System.out.println("✅ Feedback saved successfully!");
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
    }
}