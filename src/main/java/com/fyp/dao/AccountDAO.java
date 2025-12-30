/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.dao;

import com.fyp.model.Account;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO {
    
    // This method handles the LOGIN logic
    public Account login(String email, String password) {
        Account account = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // 1. Get connection from your DBConnection class (Java DB)
            con = DBConnection.getConnection();
            
            // 2. Create the SQL Query (Java DB understands this SQL)
            String sql = "SELECT * FROM ACCOUNT WHERE EMAIL = ? AND HASH_PASS = ?";
            
            // 3. Prepare the statement
            ps = con.prepareStatement(sql);
            ps.setString(1, email);     // Replace first ? with email
            ps.setString(2, password);  // Replace second ? with password
            
            // 4. Run the query
            rs = ps.executeQuery();
            
            // 5. If a match is found, create the Account object
            if (rs.next()) {
                account = new Account();
                // These column names must match your Java DB Table columns exactly
                account.setAccountId(rs.getInt("accountid")); 
                account.setEmail(rs.getString("email"));
                account.setRoleType(rs.getString("role_type"));
                // We don't save the password in the object for security
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error in AccountDAO: " + e.getMessage());
        } finally {
            // 6. Always close connections to prevent server crashes
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return account; // Returns the user object if found, or null if login failed
    }
    
    // Method to Register a New User
    public int registerUser(Account a) {
        int newId = -1;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Insert into ACCOUNT table (including the new fullname)
            String sql = "INSERT INTO ACCOUNT (email, hash_pass, role_type, fullname) VALUES (?, ?, ?, ?)";
            
            // RETURN_GENERATED_KEYS is needed to get the new Account ID immediately
            ps = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, a.getEmail());
            ps.setString(2, a.getPassword()); // In real world, hash this!
            ps.setString(3, a.getRoleType());
            ps.setString(4, a.getFullName());
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    newId = rs.getInt(1); // Get the Auto-Incremented ID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
        return newId;
    }
    
    // Check if email already exists
    public boolean emailExists(String email) {
        boolean exists = false;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT accountid FROM ACCOUNT WHERE email = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = true;
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return exists;
    }
    
    // Register a new Student row
    public void registerStudent(String name, String phone, int accountId) {
        try {
            Connection con = DBConnection.getConnection();
            // We need to generate a Student ID since the form doesn't ask for it.
            // For now, we use a random number or timestamp "S" + Time
            String genID = "2025" + (int)(Math.random() * 100000); 
            
            String sql = "INSERT INTO STUDENT (studentid, phoneNum, status, accountid) VALUES (?, ?, 'Active', ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, genID);
            ps.setString(2, phone);
            ps.setInt(3, accountId);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    // Register a new Supervisor row
    public void registerSupervisor(String phone, int accountId) {
        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO SUPERVISOR (phoneNum, position, accountid) VALUES (?, 'Lecturer', ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, phone);
            ps.setInt(2, accountId);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
