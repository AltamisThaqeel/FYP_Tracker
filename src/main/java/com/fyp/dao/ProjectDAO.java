/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.dao;

import com.fyp.model.Project;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ProjectDAO {

    // Method to get a project by Student ID
    public Project getProjectByStudent(String studentId) {
        Project proj = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            // SQL to join tables (optional) or just get project details
            String sql = "SELECT * FROM PROJECT WHERE STUDENTID = ?";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, studentId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                proj = new Project();
                proj.setProjectId(rs.getInt("projectid"));
                proj.setTitle(rs.getString("project_title"));
                proj.setDescription(rs.getString("project_desc"));
                proj.setStatus(rs.getString("project_status"));
                proj.setStartDate(rs.getDate("start_date"));
                proj.setEndDate(rs.getDate("end_date"));
                // Add more fields if needed matching your ERD
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch(Exception e){}
        }
        return proj;
    }
}