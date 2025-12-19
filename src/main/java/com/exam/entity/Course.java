package com.exam.entity;

import java.sql.Timestamp;

public class Course {
    private int id;
    private String courseName;
    private String courseCode;
    private String description;
    private String teacherName;
    private int credit;
    private String semester;
    private String status; // active, inactive
    private Timestamp createTime;
    private Timestamp updateTime;

    // 构造方法
    public Course() {}

    public Course(int id, String courseName, String courseCode, String description,
                  String teacherName, int credit, String semester, String status,
                  Timestamp createTime, Timestamp updateTime) {
        this.id = id;
        this.courseName = courseName;
        this.courseCode = courseCode;
        this.description = description;
        this.teacherName = teacherName;
        this.credit = credit;
        this.semester = semester;
        this.status = status;
        this.createTime = createTime;
        this.updateTime = updateTime;
    }

    // Getter和Setter方法
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public int getCredit() {
        return credit;
    }

    public void setCredit(int credit) {
        this.credit = credit;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", courseName='" + courseName + '\'' +
                ", courseCode='" + courseCode + '\'' +
                ", description='" + description + '\'' +
                ", teacherName='" + teacherName + '\'' +
                ", credit=" + credit +
                ", semester='" + semester + '\'' +
                ", status='" + status + '\'' +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}