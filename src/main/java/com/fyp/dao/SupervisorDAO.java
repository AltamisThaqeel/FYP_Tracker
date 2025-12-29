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
                p.setStudentId(rs.getString("studentid")); // We will show Student ID since Name isn't in ERD
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
}