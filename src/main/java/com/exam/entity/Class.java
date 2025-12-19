package com.exam.entity;

public class Class {
    private int id;
    private String className;
    private String grade;
    private String teacherName;
    private String description;
    private int studentCount;

    // 构造方法
    public Class() {}

    public Class(int id, String className, String grade, String teacherName, String description, int studentCount) {
        this.id = id;
        this.className = className;
        this.grade = grade;
        this.teacherName = teacherName;
        this.description = description;
        this.studentCount = studentCount;
    }

    // Getter和Setter方法
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }

    @Override
    public String toString() {
        return "Class{" +
                "id=" + id +
                ", className='" + className + '\'' +
                ", grade='" + grade + '\'' +
                ", teacherName='" + teacherName + '\'' +
                ", description='" + description + '\'' +
                ", studentCount=" + studentCount +
                '}';
    }
}