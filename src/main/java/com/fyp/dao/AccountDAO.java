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
}
