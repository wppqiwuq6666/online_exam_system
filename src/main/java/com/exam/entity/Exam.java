package com.exam.entity;

import java.sql.Timestamp;
import java.util.List;

public class Exam {
    private int id;
    private String title;
    private String description;
    private int duration; // 考试时长（分钟）
    private Timestamp startTime;
    private Timestamp endTime;
    private int totalScore; // 总分
    private int passScore; // 及格分数
    private String status; // draft, published, ended
    private int teacherId;
    private Timestamp createTime;
    private Timestamp updateTime;

    // 关联的试题列表
    private List<Question> questions;

    public Exam() {}

    public Exam(String title, String description, int duration,
                Timestamp startTime, Timestamp endTime, int totalScore,
                int passScore, String status, int teacherId) {
        this.title = title;
        this.description = description;
        this.duration = duration;
        this.startTime = startTime;
        this.endTime = endTime;
        this.totalScore = totalScore;
        this.passScore = passScore;
        this.status = status;
        this.teacherId = teacherId;
        this.createTime = new Timestamp(System.currentTimeMillis());
        this.updateTime = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }

    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }

    public int getTotalScore() { return totalScore; }
    public void setTotalScore(int totalScore) { this.totalScore = totalScore; }

    public int getPassScore() { return passScore; }
    public void setPassScore(int passScore) { this.passScore = passScore; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }

    public Timestamp getCreateTime() { return createTime; }
    public void setCreateTime(Timestamp createTime) { this.createTime = createTime; }

    public Timestamp getUpdateTime() { return updateTime; }
    public void setUpdateTime(Timestamp updateTime) { this.updateTime = updateTime; }

    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }

    // 获取状态文本
    public String getStatusText() {
        switch (status) {
            case "draft": return "草稿";
            case "published": return "已发布";
            case "ended": return "已结束";
            default: return "未知";
        }
    }

    // 检查考试是否可以参加
    public boolean canTakeExam() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return "published".equals(status) &&
               startTime != null && endTime != null &&
               now.after(startTime) && now.before(endTime);
    }

    // 检查考试是否已结束
    public boolean isEnded() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return endTime != null && now.after(endTime);
    }

    // 检查考试是否还未开始
    public boolean isNotStarted() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return startTime != null && now.before(startTime);
    }

    // 获取剩余时间（分钟）
    public long getRemainingMinutes() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (endTime == null || now.after(endTime)) {
            return 0;
        }
        long diff = endTime.getTime() - now.getTime();
        return diff / (60 * 1000);
    }

    @Override
    public String toString() {
        return "Exam{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", duration=" + duration +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", totalScore=" + totalScore +
                ", passScore=" + passScore +
                ", status='" + status + '\'' +
                ", teacherId=" + teacherId +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}