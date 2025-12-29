/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.model;

public class Milestone {
    private int milestoneId;
    private String description;
    private String status; // 'Completed' or 'Pending'
    private int projectScheduleId; // Links to a specific Week

    public Milestone() {}

    public Milestone(int milestoneId, String description, String status, int projectScheduleId) {
        this.milestoneId = milestoneId;
        this.description = description;
        this.status = status;
        this.projectScheduleId = projectScheduleId;
    }

    // Getters and Setters
    public int getMilestoneId() { return milestoneId; }
    public void setMilestoneId(int milestoneId) { this.milestoneId = milestoneId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getProjectScheduleId() { return projectScheduleId; }
    public void setProjectScheduleId(int projectScheduleId) { this.projectScheduleId = projectScheduleId; }
}