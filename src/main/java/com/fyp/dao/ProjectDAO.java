package com.fyp.dao;

import com.fyp.model.Project;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class ProjectDAO {

    // ==========================================================
    //  1. GET PROJECT (Read) - For Dashboard & Edit Form
    // ==========================================================
    public Project getProjectByStudent(int studentId) {
    Project proj = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        con = DBConnection.getConnection();
        // JOIN with PROJECT_CATEGORY to get the actual name
        String sql = "SELECT p.*, c.category_name FROM PROJECT p " +
                     "LEFT JOIN PROJECT_CATEGORY c ON p.categoryId = c.categoryId " +
                     "WHERE p.STUDENTID = ?";
        
        ps = con.prepareStatement(sql);
        ps.setInt(1, studentId);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            proj = new Project();
            proj.setProjectId(rs.getInt("projectId"));
            proj.setProjectTitle(rs.getString("project_title")); 
            proj.setDescription(rs.getString("project_desc"));
            proj.setObjective(rs.getString("project_obj")); 
            proj.setStatus(rs.getString("project_status"));
            proj.setProjectType(rs.getString("project_type"));
            proj.setStartDate(rs.getDate("start_date"));
            proj.setEndDate(rs.getDate("end_date"));
            proj.setContactPhone(rs.getString("contact_phone"));
            
            // Set the category name from the JOIN
            proj.setCategoryName(rs.getString("category_name"));
            proj.setProgress(rs.getInt("progress"));
            calculateAndSetWeeks(proj, rs.getDate("start_date"), rs.getDate("end_date"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResources(con, ps, rs);
    }
    return proj;
}

    // ==========================================================
    //  2. CREATE PROJECT (Insert)
    // ==========================================================
    public boolean createProject(Project p) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            
            // 1. Resolve Category ID from Name
            int categoryId = 1; 
            if (p.getCategoryName() != null) {
                categoryId = lookupCategoryId(con, p.getCategoryName());
            } else {
                categoryId = p.getCategoryId(); 
            }

            // 2. Calculate Weeks
            int weeks = calculateWeeks(p.getStartDate(), p.getEndDate());

            // 3. Insert
            String sql = "INSERT INTO PROJECT (project_title, project_desc, project_obj, "
                       + "start_date, end_date, project_status, studentId, contact_phone, "
                       + "project_type, categoryId, numOfWeeks, progress, category_name) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getProjectTitle());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getObjective());
            ps.setDate(4, p.getStartDate());
            ps.setDate(5, p.getEndDate());
            ps.setString(6, "Active"); 
            ps.setInt(7, p.getStudentId());
            ps.setString(8, p.getContactPhone());
            ps.setString(9, p.getProjectType()); 
            ps.setInt(10, categoryId);           
            ps.setInt(11, weeks);
            ps.setInt(12, p.getProgress()); 
            ps.setString(13, p.getCategoryName());

            isSuccess = ps.executeUpdate() > 0;

        } catch (Exception e) { e.printStackTrace(); } 
        finally { closeResources(con, ps, rs); }
        return isSuccess;
    }

    // ==========================================================
    //  3. UPDATE PROJECT (Edit) - NOW FIXED!
    // ==========================================================
    public boolean updateProject(Project p) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            
            // 1. Resolve Category ID (If user changed the category name)
            int categoryId = p.getCategoryId(); // Default to existing
            if (p.getCategoryName() != null) {
                categoryId = lookupCategoryId(con, p.getCategoryName());
            }

            // 2. Recalculate Weeks (If user changed dates)
            int weeks = calculateWeeks(p.getStartDate(), p.getEndDate());

            // 3. Update Query
            String sql = "UPDATE PROJECT SET project_title=?, project_desc=?, project_obj=?, "
                       + "start_date=?, end_date=?, contact_phone=?, project_type=?, "
                       + "categoryId=?, numOfWeeks=?, progress=?, category_name=? "
                       + "WHERE projectid=? AND studentId=?";

            ps = con.prepareStatement(sql);
            ps.setString(1, p.getProjectTitle());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getObjective());
            ps.setDate(4, p.getStartDate());
            ps.setDate(5, p.getEndDate());
            ps.setString(6, p.getContactPhone());
            ps.setString(7, p.getProjectType());
            ps.setInt(8, categoryId);
            ps.setInt(9, weeks);
            ps.setInt(10, p.getProgress());       
            ps.setString(11, p.getCategoryName()); 
            ps.setInt(12, p.getProjectId());
            ps.setInt(13, p.getStudentId());

            isSuccess = ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
        } finally { 
            closeResources(con, ps, null); 
        }
        return isSuccess;
    }

    // ==========================================================
    //  4. UTILITY METHODS
    // ==========================================================
    public int getStudentIdByAccount(int accountId) {
        int studentId = -1;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT studentId FROM STUDENT WHERE accountId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) studentId = rs.getInt("studentId");
        } catch (Exception e) { e.printStackTrace(); }
        return studentId;
    }

    public List<Project> getAllProjectsByStudent(int studentId) {
        List<Project> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM PROJECT WHERE studentId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Project p = new Project();
                p.setProjectId(rs.getInt("projectid"));
                p.setProjectTitle(rs.getString("project_title"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                
                int dbWeeks = rs.getInt("numOfWeeks");
                if (dbWeeks > 0) p.setNumOfWeeks(dbWeeks);
                else calculateAndSetWeeks(p, rs.getDate("start_date"), rs.getDate("end_date"));
                
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // --- PRIVATE HELPERS ---
    
    // Helper to calculate weeks as integer
    private int calculateWeeks(java.sql.Date start, java.sql.Date end) {
        if (start != null && end != null) {
            long diffInMillies = Math.abs(end.getTime() - start.getTime());
            long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
            int weeks = (int) Math.ceil((double) diffInDays / 7);
            return (weeks > 0) ? weeks : 1;
        }
        return 1;
    }

    // Helper to set weeks on object
    private void calculateAndSetWeeks(Project p, java.sql.Date start, java.sql.Date end) {
        p.setNumOfWeeks(calculateWeeks(start, end));
    }
    
    // Helper to find ID from Name
    private int lookupCategoryId(Connection con, String categoryName) {
        int id = 1; // Default
        try {
            PreparedStatement ps = con.prepareStatement("SELECT categoryId FROM PROJECT_CATEGORY WHERE category_name = ?");
            ps.setString(1, categoryName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) id = rs.getInt("categoryId");
            ps.close();
            rs.close();
        } catch (Exception e) {}
        return id;
    }

    // Helper to find Name from ID
    private String getCategoryName(int categoryId) {
        String name = "General";
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT category_name FROM PROJECT_CATEGORY WHERE categoryId = ?");
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) name = rs.getString("category_name");
        } catch(Exception e) {}
        return name;
    }

    private void closeResources(Connection con, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
}