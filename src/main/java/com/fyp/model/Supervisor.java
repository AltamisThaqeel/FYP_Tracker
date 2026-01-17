package com.fyp.model;

public class Supervisor {
    private int supervisorId;
    private String phoneNum;
    private String position;
    private int departmentId; 
    private int accountId;    

    // Constructors
    public Supervisor() {}

    public Supervisor(int supervisorId, String phoneNum, String position, int departmentId, int accountId) {
        this.supervisorId = supervisorId;
        this.phoneNum = phoneNum;
        this.position = position;
        this.departmentId = departmentId;
        this.accountId = accountId;
    }

    public int getSupervisorId() {return supervisorId;}
    public void setSupervisorId(int supervisorId) {this.supervisorId = supervisorId;}

    public String getPhoneNum() {return phoneNum;}
    public void setPhoneNum(String phoneNum) {this.phoneNum = phoneNum;}

    public String getPosition() {return position;}
    public void setPosition(String position) {this.position = position;}

    public int getDepartmentId() {return departmentId;}
    public void setDepartmentId(int departmentId) {this.departmentId = departmentId;}

    public int getAccountId() {return accountId;}
    public void setAccountId(int accountId) {this.accountId = accountId;}
}