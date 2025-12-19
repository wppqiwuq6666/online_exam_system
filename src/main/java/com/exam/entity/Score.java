package com.exam.entity;

import java.sql.Timestamp;

public class Score {
    private int id;
    private int studentId;
    private int courseId;
    private int examId;
    private String studentName;
    private String courseName;
    private String examTitle;
    private double score;
    private double maxScore;
    private String status; // passed, failed, pending
    private Timestamp examTime;
    private Timestamp createTime;

    // 构造方法
    public Score() {}

    public Score(int id, int studentId, int courseId, int examId,
                 String studentName, String courseName, String examTitle,
                 double score, double maxScore, String status,
                 Timestamp examTime, Timestamp createTime) {
        this.id = id;
        this.studentId = studentId;
        this.courseId = courseId;
        this.examId = examId;
        this.studentName = studentName;
        this.courseName = courseName;
        this.examTitle = examTitle;
        this.score = score;
        this.maxScore = maxScore;
        this.status = status;
        this.examTime = examTime;
        this.createTime = createTime;
    }

    // Getter和Setter方法
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getExamId() {
        return examId;
    }

    public void setExamId(int examId) {
        this.examId = examId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getExamTitle() {
        return examTitle;
    }

    public void setExamTitle(String examTitle) {
        this.examTitle = examTitle;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public double getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(double maxScore) {
        this.maxScore = maxScore;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getExamTime() {
        return examTime;
    }

    public void setExamTime(Timestamp examTime) {
        this.examTime = examTime;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    // 计算百分比
    public double getPercentage() {
        if (maxScore > 0) {
            return (score / maxScore) * 100;
        }
        return 0;
    }

    // 获取等级
    public String getGrade() {
        double percentage = getPercentage();
        if (percentage >= 90) return "A";
        if (percentage >= 80) return "B";
        if (percentage >= 70) return "C";
        if (percentage >= 60) return "D";
        return "F";
    }

    // 是否及格
    public boolean isPassed() {
        return "passed".equals(status) || getPercentage() >= 60;
    }

    @Override
    public String toString() {
        return "Score{" +
                "id=" + id +
                ", studentId=" + studentId +
                ", courseId=" + courseId +
                ", examId=" + examId +
                ", studentName='" + studentName + '\'' +
                ", courseName='" + courseName + '\'' +
                ", examTitle='" + examTitle + '\'' +
                ", score=" + score +
                ", maxScore=" + maxScore +
                ", status='" + status + '\'' +
                ", examTime=" + examTime +
                ", createTime=" + createTime +
                '}';
    }
}