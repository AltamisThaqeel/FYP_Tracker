package com.fyp.dao;

import com.fyp.model.Feedback;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    // 1. Get Feedback for a specific Project and Week
    public Feedback getFeedback(int projectId, int week) {
        Feedback f = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM FEEDBACK WHERE projectid = ? AND week_number = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            ps.setInt(2, week);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                f = new Feedback();
                f.setFeedbackId(rs.getInt("feedbackId"));
                f.setDateGiven(rs.getDate("date_given"));
                f.setWeekNumber(rs.getInt("week_number"));
                f.setContent(rs.getString("content"));
                f.setStatus(rs.getString("status"));
                f.setProjectId(rs.getInt("projectid"));
                f.setSupervisorId(rs.getInt("supervisorid"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    // 2. Get ALL Feedback for a specific Project (Used by Student Dashboard)
    public List<Feedback> getAllFeedbackByProject(int projectId) {
        List<Feedback> feedbackList = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            // Ordering by week_number descending so newest feedback appears first
            String sql = "SELECT * FROM FEEDBACK WHERE projectid = ? ORDER BY week_number DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackId(rs.getInt("feedbackId"));
                f.setDateGiven(rs.getDate("date_given"));
                f.setWeekNumber(rs.getInt("week_number"));
                f.setContent(rs.getString("content"));
                f.setStatus(rs.getString("status"));
                f.setProjectId(rs.getInt("projectid"));
                f.setSupervisorId(rs.getInt("supervisorid"));
                feedbackList.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    // 3. Update status to 'Read' (Used when student clicks "Check As Read")
    public boolean markAsRead(int feedbackId) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE FEEDBACK SET status = 'Read' WHERE feedbackId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, feedbackId);
            int rows = ps.executeUpdate();
            success = (rows > 0);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    // 4. Save or Update (Upsert Logic for Supervisor side)
    public void saveOrUpdateFeedback(Feedback f) {
        try (Connection con = DBConnection.getConnection()) {
            if (getFeedback(f.getProjectId(), f.getWeekNumber()) != null) {
                // UPDATE
                String sql = "UPDATE FEEDBACK SET content = ?, date_given = ?, status = ? WHERE projectid = ? AND week_number = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, f.getContent());
                ps.setDate(2, f.getDateGiven());
                ps.setString(3, f.getStatus());
                ps.setInt(4, f.getProjectId());
                ps.setInt(5, f.getWeekNumber());
                ps.executeUpdate();
            } else {
                // INSERT
                String sql = "INSERT INTO FEEDBACK (date_given, week_number, content, status, projectid, supervisorid) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setDate(1, f.getDateGiven());
                ps.setInt(2, f.getWeekNumber());
                ps.setString(3, f.getContent());
                ps.setString(4, f.getStatus() != null ? f.getStatus() : "Unread");
                ps.setInt(5, f.getProjectId());
                ps.setInt(6, f.getSupervisorId());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}