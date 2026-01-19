package com.fyp.dao;

import com.fyp.model.Department;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {
    
    // Fetch all departments for the dropdown menu
    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM DEPARTMENT ORDER BY departmentId ASC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while(rs.next()) {
                Department d = new Department();
                d.setDepartmentId(rs.getInt("departmentId"));
                d.setDepartmentName(rs.getString("departmentName"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}