/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.model;

public class Account {
    private int accountId;
    private String email;
    private String password;
    private String roleType; // "Student" or "Supervisor"

    // Constructors, Getters, and Setters
    public Account() {}

    public Account(int accountId, String email, String password, String roleType) {
        this.accountId = accountId;
        this.email = email;
        this.password = password;
        this.roleType = roleType;
    }

    public int getAccountId() { return accountId; }
    public void setAccountId(int accountId) { this.accountId = accountId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getRoleType() { return roleType; }
    public void setRoleType(String roleType) { this.roleType = roleType; }
}