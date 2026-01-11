package com.fyp.dao;

import com.fyp.model.Project;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProjectDAO {

    // ==========================================================
    //  METHOD 1: FOR STUDENT DASHBOARD (Get Single Project)
    // ==========================================================
    public Project getProjectByStudent(int studentId) {
        Project proj = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM PROJECT WHERE STUDENTID = ?";
            
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                proj = new Project();
                proj.setProjectId(rs.getInt("projectid"));
                proj.setStudentId(rs.getInt("studentid"));
                proj.setProjectName(rs.getString("project_title")); 
                proj.setDescription(rs.getString("project_desc"));
                proj.setObjective(rs.getString("project_obj")); 
                proj.setStatus(rs.getString("project_status"));
                proj.setProjectType(rs.getString("project_type"));
                proj.setStartDate(rs.getDate("start_date"));
                proj.setEndDate(rs.getDate("end_date"));
                proj.setContactPhone(rs.getString("contact_phone"));
                
                // Optional fields with fallback
                proj.setSupervisorName(rs.getString("supervisor_name") != null ? rs.getString("supervisor_name") : "Not Assigned");
                proj.setProgress(rs.getInt("progress"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, ps, rs);
        }
        return proj;
    }

    // ==========================================================
    //  METHOD 2: CREATE NEW PROJECT
    // ==========================================================
    public boolean createProject(Project p) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            
            // 1. Look up categoryId based on the categoryName set in the object
            int categoryId = 1; // Default fallback
            String catSql = "SELECT categoryId FROM PROJECT_CATEGORY WHERE category_name = ?";
            ps = con.prepareStatement(catSql);
            ps.setString(1, p.getCategoryName());
            rs = ps.executeQuery();
            if (rs.next()) {
                categoryId = rs.getInt("categoryId");
            }
            ps.close(); // Close lookup before main insert

            // 2. Main Insert matching your SQL Schema
            String sql = "INSERT INTO PROJECT (project_title, project_desc, project_obj, "
                       + "start_date, end_date, project_status, studentId, contact_phone, "
                       + "project_type, categoryId) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getProjectName());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getObjective());
            ps.setDate(4, p.getStartDate());
            ps.setDate(5, p.getEndDate());
            ps.setString(6, "Active"); 
            ps.setInt(7, p.getStudentId());
            ps.setString(8, p.getContactPhone());
            ps.setString(9, p.getProjectType()); // Added project type
            ps.setInt(10, categoryId);           // Added category foreign key

            int rows = ps.executeUpdate();
            if (rows > 0) isSuccess = true;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, ps, rs);
        }
        return isSuccess;
    }

    // ==========================================================
    //  METHOD 3: GET STUDENT ID BY ACCOUNT
    // ==========================================================
    public int getStudentIdByAccount(int accountId) {
        int studentId = -1;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT studentId FROM STUDENT WHERE accountId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, accountId);
            rs = ps.executeQuery();

            if (rs.next()) {
                studentId = rs.getInt("studentId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, ps, rs);
        }
        return studentId;
    }

    private void closeResources(Connection con, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
    
    // ==========================================================
    //  METHOD 4: Get ALL projects for a specific student (For the Dropdown)
    // ==========================================================
    
    public List<Project> getAllProjectsByStudent(int studentId) {
        List<Project> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM PROJECT WHERE studentId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Project p = new Project();
                p.setProjectId(rs.getInt("projectid"));
                p.setProjectName(rs.getString("project_title"));
                p.setDescription(rs.getString("project_desc"));
                p.setObjective(rs.getString("project_obj"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setProjectType(rs.getString("project_type"));
                p.setContactPhone(rs.getString("contact_phone"));
                p.setNumOfWeeks(rs.getInt("numOfWeeks"));
                p.setStudentId(rs.getInt("studentId"));

                list.add(p);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        } 
        finally { 
            closeResources(con, ps, rs); 
        }
        return list;
    }

    // ==========================================================
    //  METHOD 5: Update an existing Project
    // ==========================================================

    public boolean updateProject(Project p) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE PROJECT SET project_title=?, project_desc=?, project_obj=?, "
                       + "start_date=?, end_date=?, contact_phone=?, project_type=? "
                       + "WHERE projectid=? AND studentId=?"; // Secure update

            ps = con.prepareStatement(sql);
            ps.setString(1, p.getProjectName());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getObjective());
            ps.setDate(4, p.getStartDate());
            ps.setDate(5, p.getEndDate());
            ps.setString(6, p.getContactPhone());
            ps.setString(7, p.getProjectType());
            ps.setInt(8, p.getProjectId());
            ps.setInt(9, p.getStudentId());

            isSuccess = ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); } 
        finally { closeResources(con, ps, null); }
        return isSuccess;
    }
    
    public int getProjectDuration(int projectId) {
    int weeks = 0;
    try (Connection con = DBConnection.getConnection()) {
        String sql = "SELECT numOfWeeks FROM PROJECT WHERE projectId = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, projectId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            weeks = rs.getInt("numOfWeeks");
        }
    } catch (Exception e) { e.printStackTrace(); }
    return weeks;
    }
}