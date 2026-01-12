/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.dao;

import com.fyp.model.Feedback;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FeedbackDAO {

    // 1. Get Feedback for a specific Project and Week
    public Feedback getFeedback(int projectId, int week) {
        Feedback f = null;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM FEEDBACK WHERE projectid = ? AND week_number = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            ps.setInt(2, week);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                f = new Feedback();
                f.setFeedbackId(rs.getInt("feedbackid"));
                f.setContent(rs.getString("content"));
                f.setWeekNumber(rs.getInt("week_number"));
                f.setProjectId(rs.getInt("projectid"));
                f.setDateGiven(rs.getDate("date_given"));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    // 2. Save or Update (Upsert Logic)
    public void saveOrUpdateFeedback(Feedback f) {
        try {
            Connection con = DBConnection.getConnection();

            // Check if exists
            if (getFeedback(f.getProjectId(), f.getWeekNumber()) != null) {
                // UPDATE
                String sql = "UPDATE FEEDBACK SET content = ?, date_given = ? WHERE projectid = ? AND week_number = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, f.getContent());
                ps.setDate(2, f.getDateGiven());
                ps.setInt(3, f.getProjectId());
                ps.setInt(4, f.getWeekNumber());
                ps.executeUpdate();
            } else {
                // INSERT
                String sql = "INSERT INTO FEEDBACK (date_given, week_number, content, status, projectid, supervisorid) VALUES (?, ?, ?, 'Unread', ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setDate(1, f.getDateGiven());
                ps.setInt(2, f.getWeekNumber());
                ps.setString(3, f.getContent());
                ps.setInt(4, f.getProjectId());
                ps.setInt(5, f.getSupervisorId());
                ps.executeUpdate();
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
