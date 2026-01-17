/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.model;

public class Student {
    private int studentId;
    private String phoneNum;
    private String address;
    private String status;
    private int enrollmentYear;
    private String specialization;
    private String educationType;
    private int courseId;
    private int accountId;    // Foreign key to ACCOUNT
    private int departmentId; // Foreign key to DEPARTMENT

    // Constructors
    public Student() {}

    public Student(int studentId, String phoneNum, String address, String status, 
                   int enrollmentYear, String specialization, String educationType, 
                   int courseId, int accountId, int departmentId) {
        this.studentId = studentId;
        this.phoneNum = phoneNum;
        this.address = address;
        this.status = status;
        this.enrollmentYear = enrollmentYear;
        this.specialization = specialization;
        this.educationType = educationType;
        this.courseId = courseId;
        this.accountId = accountId;
        this.departmentId = departmentId;
    }

    // Getters and Setters
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getPhoneNum() { return phoneNum; }
    public void setPhoneNum(String phoneNum) { this.phoneNum = phoneNum; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getEnrollmentYear() { return enrollmentYear; }
    public void setEnrollmentYear(int enrollmentYear) { this.enrollmentYear = enrollmentYear; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getEducationType() { return educationType; }
    public void setEducationType(String educationType) { this.educationType = educationType; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public int getAccountId() { return accountId; }
    public void setAccountId(int accountId) { this.accountId = accountId; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }
}