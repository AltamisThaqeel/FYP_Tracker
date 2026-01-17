/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.fyp.model;

public class ProjectCategory {
    private int categoryId;
    private String categoryName;
    
    public ProjectCategory() {}
    public ProjectCategory(int categoryId, String categoryName) {this.categoryId = categoryId;this.categoryName = categoryName;}
    
    public int getCategoryId() {return categoryId;}
    public void setCategoryId(int categoryId) {this.categoryId = categoryId;}

    public String getCategoryName() {return categoryName;}
    public void setCategoryName(String categoryName) {this.categoryName = categoryName;}
}