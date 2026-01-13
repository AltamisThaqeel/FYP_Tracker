package com.fyp.model;

import java.sql.Date;

public class Project {
    
    // --- SHARED DATABASE FIELDS (Matches your SQL Table) ---
    private int projectId;          // SQL: projectId INT
    private String projectName;     // SQL: project_title
    private String description;     // SQL: project_desc
    private String objective;       // SQL: project_obj
    private String status;          // SQL: project_status
    private String projectType;     // SQL: project_type
    private String contactPhone;    // SQL: contact_phone
    private int numOfWeeks;         // SQL: numOfWeeks
    private Date startDate;         // SQL: start_date
    private Date endDate;           // SQL: end_date

    // --- FOREIGN KEYS (Integers to match DB Columns) ---
    private int studentId;          // SQL: studentId INT
    private int supervisorId;       // SQL: supervisorId INT
    
    // [ADDED] These were missing but exist in your Database Table!
    private int categoryId;         // SQL: categoryId INT
    private int groupId;            // SQL: groupId INT

    // --- VIRTUAL FIELDS (For Display Only - Not in PROJECT table) ---
    private String supervisorName;
    private int progress;
    private String studentName;
    private String studentPhone;
    private String categoryName;

    public Project() {}

    // ==========================================
    //       GETTERS AND SETTERS
    // ==========================================

    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }

    public String getProjectName() { return projectName; }
    public void setProjectName(String projectName) { this.projectName = projectName; }
    
    // Helper: Keeps older code working if it uses setTitle
    public void setTitle(String title) { this.projectName = title; }
    public String getTitle() { return projectName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getObjective() { return objective; }
    public void setObjective(String objective) { this.objective = objective; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getProjectType() { return projectType; }
    public void setProjectType(String projectType) { this.projectType = projectType; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    
    public int getNumOfWeeks() { return numOfWeeks; }
    public void setNumOfWeeks(int numOfWeeks) { this.numOfWeeks = numOfWeeks; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    // --- ID Links ---
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    
    public int getSupervisorId() { return supervisorId; }
    public void setSupervisorId(int supervisorId) { this.supervisorId = supervisorId; }

    // [ADDED] Getters for the missing Foreign Keys
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getGroupId() { return groupId; }
    public void setGroupId(int groupId) { this.groupId = groupId; }

    // --- Virtual / Display Fields ---
    public String getSupervisorName() { return supervisorName; }
    public void setSupervisorName(String supervisorName) { this.supervisorName = supervisorName; }

    public int getProgress() { return progress; }
    public void setProgress(int progress) { this.progress = progress; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentPhone() { return studentPhone; }
    public void setStudentPhone(String studentPhone) { this.studentPhone = studentPhone; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}