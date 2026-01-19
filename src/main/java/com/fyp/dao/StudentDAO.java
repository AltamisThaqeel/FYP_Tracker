/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.dao;

import com.fyp.model.Student;
import com.fyp.util.DBConnection;
import java.sql.Connection;
import java.sql.ResultSet;
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
        public boolean updateStudentProfile(int studentId, String phone, String address, String year, String spec, String edu) {
            String sql = "UPDATE STUDENT SET phoneNum = ?, address = ?, enrollment_year = ?, specialization = ?, education_type = ? WHERE studentId = ?";
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, phone);
                ps.setString(2, address);
                ps.setInt(3, Integer.parseInt(year));
                ps.setString(4, spec);
                ps.setString(5, edu);
                ps.setInt(6, studentId);

                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
        public Student getStudentByAccount(int accountId) {
        Student s = null;
        String sql = "SELECT * FROM STUDENT WHERE accountId = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    s = new Student();
                    s.setStudentId(rs.getInt("studentId"));
                    s.setPhoneNum(rs.getString("phoneNum"));
                    s.setAddress(rs.getString("address"));
                    s.setEnrollmentYear(rs.getInt("enrollment_year"));
                    s.setSpecialization(rs.getString("specialization"));
                    s.setEducationType(rs.getString("education_type"));
                    s.setAccountId(rs.getInt("accountId"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }
}
