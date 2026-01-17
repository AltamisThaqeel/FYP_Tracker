/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.model;

import java.util.Date;

public class ProjectSchedule {
    private int projectScheduleId;
    private int weekNum;
    private Date startWeek;
    private Date endWeek;
    private int projectId;   // Foreign key to Project
    private int milestoneId; // Foreign key to Milestone

    // Constructors
    public ProjectSchedule() {}

    public ProjectSchedule(int projectScheduleId, int weekNum, Date startWeek, Date endWeek, int projectId, int milestoneId) {
        this.projectScheduleId = projectScheduleId;
        this.weekNum = weekNum;
        this.startWeek = startWeek;
        this.endWeek = endWeek;
        this.projectId = projectId;
        this.milestoneId = milestoneId;
    }

    // Getters and Setters
    public int getProjectScheduleId() {return projectScheduleId;}
    public void setProjectScheduleId(int projectScheduleId) {this.projectScheduleId = projectScheduleId;}

    public int getWeekNum() {return weekNum;}
    public void setWeekNum(int weekNum) {this.weekNum = weekNum;}

    public Date getStartWeek() {return startWeek;}
    public void setStartWeek(Date startWeek) {this.startWeek = startWeek;}

    public Date getEndWeek() {return endWeek;}
    public void setEndWeek(Date endWeek) {this.endWeek = endWeek;}

    public int getProjectId() {return projectId;}
    public void setProjectId(int projectId) {this.projectId = projectId;}

    public int getMilestoneId() {return milestoneId;}
    public void setMilestoneId(int milestoneId) {this.milestoneId = milestoneId;}
}