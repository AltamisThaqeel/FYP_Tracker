/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Java DB (Derby) Connection String
    private static final String HOST = "jdbc:derby://localhost:1527/FYP_Tracker_DB";
    private static final String USER = "app";
    private static final String PASS = "app";

    public static Connection getConnection() {
        Connection con = null;
        try {
            // Load Derby Client Driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            con = DriverManager.getConnection(HOST, USER, PASS);
            System.out.println("✅ Database Connected Successfully!");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Connection Failed: " + e.getMessage());
        }
        return con;
    }
}