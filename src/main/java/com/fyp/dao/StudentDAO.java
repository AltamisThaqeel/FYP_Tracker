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
            
            // We need to generate a Student ID. 
            // In a real system, you might ask for it in the form. 
            // Here, we generate a random one starting with 2025.
            String genID = "2025" + (int)(Math.random() * 100000); 
            
            String sql = "INSERT INTO STUDENT (studentid, phoneNum, status, accountid) VALUES (?, ?, 'Active', ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, genID);
            ps.setString(2, phone);
            ps.setInt(3, accountId);
            
            ps.executeUpdate();
            
        } catch (Exception e) { 
            e.printStackTrace(); 
        } finally {
            try { if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
    }
}
