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
import java.sql.Statement;

public class AccountDAO {

    // --- 1. LOGIN METHOD ---
    public Account login(String email, String password) {
        Account account = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM ACCOUNT WHERE EMAIL = ? AND HASH_PASS = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                account = new Account();
                account.setAccountId(rs.getInt("accountId"));
                account.setEmail(rs.getString("email"));
                account.setRoleType(rs.getString("role_type"));
                // Note: We retrieve 'full_name' if it exists in DB
                try {
                    account.setFullName(rs.getString("full_name"));
                } catch (Exception e) {
                    // Ignore if column is missing to prevent crash
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(con, ps, rs);
        }
        return account;
    }

    // --- 2. REGISTER USER ACCOUNT ---
    public int registerUser(Account a) {
        int newId = -1;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // FIX: Ensure column name is 'full_name' matches DB
            String sql = "INSERT INTO ACCOUNT (email, hash_pass, role_type, full_name) VALUES (?, ?, ?, ?)";

            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, a.getEmail());
            ps.setString(2, a.getPassword());
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
            System.out.println("Error Registering Account: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, ps, rs);
        }
        return newId;
    }

    // --- 3. CHECK EMAIL EXISTS ---
    public boolean emailExists(String email) {
        boolean exists = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT accountId FROM ACCOUNT WHERE email = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                exists = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(con, ps, rs);
        }
        return exists;
    }

    // --- 4. REGISTER STUDENT PROFILE ---
    // MOVED HERE for convenience, but usually belongs in StudentDAO
    public void registerStudent(String name, String phone, int accountId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();

            // FIX: Removed 'studentId' from INSERT. Let Derby Auto-Generate it.
            String sql = "INSERT INTO STUDENT (phoneNum, status, accountId) VALUES (?, 'Active', ?)";

            ps = con.prepareStatement(sql);
            ps.setString(1, phone);
            ps.setInt(2, accountId);

            ps.executeUpdate();
            System.out.println("Student Profile Created for Account ID: " + accountId);

        } catch (Exception e) {
            System.out.println("Error Registering Student: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, ps, null);
        }
    }

    // --- 5. REGISTER SUPERVISOR PROFILE ---
    public void registerSupervisor(String phone, int accountId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();

            // FIX: Ensure columns match DB exactly
            String sql = "INSERT INTO SUPERVISOR (phoneNum, position, accountId) VALUES (?, 'Lecturer', ?)";

            ps = con.prepareStatement(sql);
            ps.setString(1, phone);
            ps.setInt(2, accountId);

            ps.executeUpdate();
            System.out.println("Supervisor Profile Created for Account ID: " + accountId);

        } catch (Exception e) {
            System.out.println("Error Registering Supervisor: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(con, ps, null);
        }
    }

    // Helper to close connections clean
    private void closeResources(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception e) {
        }
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (Exception e) {
        }
        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception e) {
        }
    }
    public boolean updateAccountName(int accountId, String fullName) {
        String sql = "UPDATE ACCOUNT SET full_name = ? WHERE accountId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}
