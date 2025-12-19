package com.exam.entity;

public class Question {
    private int id;
    private String title;
    private String type; // single(单选), multiple(多选), essay(主观)
    private String options; // JSON格式存储选项
    private String answer; // 正确答案
    private String analysis; // 答案解析
    private int difficulty; // 难度 1-简单 2-中等 3-困难
    private String subject; // 科目
    private int teacherId; // 创建教师ID
    private java.time.LocalDateTime createTime;
    private java.time.LocalDateTime updateTime;

    public Question() {}

    public Question(String title, String type, String options, String answer,
                   String analysis, int difficulty, String subject, int teacherId) {
        this.title = title;
        this.type = type;
        this.options = options;
        this.answer = answer;
        this.analysis = analysis;
        this.difficulty = difficulty;
        this.subject = subject;
        this.teacherId = teacherId;
        this.createTime = java.time.LocalDateTime.now();
        this.updateTime = java.time.LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getOptions() { return options; }
    public void setOptions(String options) { this.options = options; }

    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }

    public String getAnalysis() { return analysis; }
    public void setAnalysis(String analysis) { this.analysis = analysis; }

    public int getDifficulty() { return difficulty; }
    public void setDifficulty(int difficulty) { this.difficulty = difficulty; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }

    public java.time.LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(java.time.LocalDateTime createTime) { this.createTime = createTime; }

    public java.time.LocalDateTime getUpdateTime() { return updateTime; }
    public void setUpdateTime(java.time.LocalDateTime updateTime) { this.updateTime = updateTime; }

    // 获取难度文本
    public String getDifficultyText() {
        switch (difficulty) {
            case 1: return "简单";
            case 2: return "中等";
            case 3: return "困难";
            default: return "未知";
        }
    }

    // 获取题型文本
    public String getTypeText() {
        switch (type) {
            case "single": return "单选题";
            case "multiple": return "多选题";
            case "essay": return "主观题";
            default: return "未知";
        }
    }
}