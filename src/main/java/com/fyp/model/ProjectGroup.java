package com.fyp.model;

public class ProjectGroup {
    private int groupId;
    private int projectId;
    private int studentId;

    public ProjectGroup() {}

    public ProjectGroup(int groupId, int projectId, int studentId) {
        this.groupId = groupId;
        this.projectId = projectId;
        this.studentId = studentId;}
    
    public int getGroupId() {return groupId;}
    public void setGroupId(int groupId) {this.groupId = groupId;}

    public int getProjectId() {return projectId;}
    public void setProjectId(int projectId) {this.projectId = projectId;}

    public int getStudentId() {return studentId;}
    public void setStudentId(int studentId) {this.studentId = studentId;}
}