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
import java.util.ArrayList;
import java.util.List;

public class SupervisorDAO {

    // Get ALL projects assigned to a specific Supervisor ID
    public List<Project> getProjectsBySupervisor(int supervisorId) {
        List<Project> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            // Select all projects for this supervisor
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
                p.setStudentId(rs.getInt("studentId")); // We will show Student ID since Name isn't in ERD
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
        return list;
    }
    
    // ADD THIS NEW METHOD FOR REGISTRATION:
    public void registerSupervisor(String phone, int accountId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            
            // Insert new Supervisor
            String sql = "INSERT INTO SUPERVISOR (phoneNum, position, accountid) VALUES (?, 'Lecturer', ?)";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, phone);
            ps.setInt(2, accountId);
            
            ps.executeUpdate();
            
        } catch (Exception e) { 
            e.printStackTrace(); 
        } finally {
            try { if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
    }
    
    // Get Projects WITH Student and Category Details
    public List<Project> getProjectsWithDetails(int supervisorId) {
        List<Project> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            // SQL JOIN to get names instead of just IDs
            String sql = "SELECT p.*, s.student_name, s.phoneNum, c.category_name " +
                         "FROM PROJECT p " +
                         "JOIN STUDENT s ON p.studentid = s.studentid " +
                         "LEFT JOIN PROJECT_CATEGORY c ON p.categoryid = c.categoryid " +
                         "WHERE p.supervisorid = ?";
            
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
                p.setStudentId(rs.getInt("studentId"));
                
                // Set the new display fields
                p.setStudentName(rs.getString("student_name")); // Ensure STUDENT table has 'student_name' column
                p.setStudentPhone(rs.getString("phoneNum"));
                p.setCategoryName(rs.getString("category_name"));
                
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
        return list;
    }
}