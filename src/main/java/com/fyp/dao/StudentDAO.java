/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.dao;

import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class StudentDAO {
    
    // Register a new Student row linked to an Account
        public void registerStudent(String name, String phone, int accountId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();

            // REMOVE 'studentid' from the SQL query
            String sql = "INSERT INTO STUDENT (phoneNum, status, accountId) VALUES (?, 'Active', ?)";
            ps = con.prepareStatement(sql);

            // Shift parameter indices to match the new SQL
            ps.setString(1, phone);
            ps.setInt(2, accountId);

            ps.executeUpdate();
            System.out.println("Student profile automatically created.");

        } catch (Exception e) { 
            e.printStackTrace(); 
        } finally {
            try { if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
    }
}
