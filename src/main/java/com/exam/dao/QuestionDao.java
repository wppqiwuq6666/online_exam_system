package com.exam.dao;

import com.exam.entity.Question;
import com.exam.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDao {

    // 添加试题
    public boolean add(Question question) {
        String sql = "INSERT INTO questions (title, type, options, answer, analysis, difficulty, subject, teacher_id, create_time, update_time) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, question.getTitle());
            pstmt.setString(2, question.getType());
            pstmt.setString(3, question.getOptions());
            pstmt.setString(4, question.getAnswer());
            pstmt.setString(5, question.getAnalysis());
            pstmt.setInt(6, question.getDifficulty());
            pstmt.setString(7, question.getSubject());
            pstmt.setInt(8, question.getTeacherId());
            pstmt.setTimestamp(9, Timestamp.valueOf(question.getCreateTime()));
            pstmt.setTimestamp(10, Timestamp.valueOf(question.getUpdateTime()));

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 根据ID查找试题
    public Question findById(int id) {
        String sql = "SELECT * FROM questions WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractQuestionFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 根据教师ID查找所有试题
    public List<Question> findByTeacherId(int teacherId) {
        String sql = "SELECT * FROM questions WHERE teacher_id = ? ORDER BY create_time DESC";
        List<Question> questions = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, teacherId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                questions.add(extractQuestionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    // 获取所有试题（管理员用）
    public List<Question> findAll() {
        String sql = "SELECT * FROM questions ORDER BY create_time DESC";
        List<Question> questions = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                questions.add(extractQuestionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    // 更新试题
    public boolean update(Question question) {
        String sql = "UPDATE questions SET title = ?, type = ?, options = ?, answer = ?, " +
                    "analysis = ?, difficulty = ?, subject = ?, update_time = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, question.getTitle());
            pstmt.setString(2, question.getType());
            pstmt.setString(3, question.getOptions());
            pstmt.setString(4, question.getAnswer());
            pstmt.setString(5, question.getAnalysis());
            pstmt.setInt(6, question.getDifficulty());
            pstmt.setString(7, question.getSubject());
            pstmt.setTimestamp(8, Timestamp.valueOf(java.time.LocalDateTime.now()));
            pstmt.setInt(9, question.getId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除试题
    public boolean delete(int id) {
        String sql = "DELETE FROM questions WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 按条件搜索试题
    public List<Question> search(String keyword, String type, String subject, int teacherId) {
        StringBuilder sql = new StringBuilder("SELECT * FROM questions WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (teacherId > 0) {
            sql.append(" AND teacher_id = ?");
            params.add(teacherId);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR analysis LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        if (type != null && !type.equals("all")) {
            sql.append(" AND type = ?");
            params.add(type);
        }

        if (subject != null && !subject.equals("all")) {
            sql.append(" AND subject = ?");
            params.add(subject);
        }

        sql.append(" ORDER BY create_time DESC");

        List<Question> questions = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                questions.add(extractQuestionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    // 获取所有科目
    public List<String> getAllSubjects() {
        String sql = "SELECT DISTINCT subject FROM questions WHERE subject IS NOT NULL ORDER BY subject";
        List<String> subjects = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                subjects.add(rs.getString("subject"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }

    // 从ResultSet提取Question对象
    private Question extractQuestionFromResultSet(ResultSet rs) throws SQLException {
        Question question = new Question();
        question.setId(rs.getInt("id"));
        question.setTitle(rs.getString("title"));
        question.setType(rs.getString("type"));
        question.setOptions(rs.getString("options"));
        question.setAnswer(rs.getString("answer"));
        question.setAnalysis(rs.getString("analysis"));
        question.setDifficulty(rs.getInt("difficulty"));
        question.setSubject(rs.getString("subject"));
        question.setTeacherId(rs.getInt("teacher_id"));

        Timestamp createTime = rs.getTimestamp("create_time");
        if (createTime != null) {
            question.setCreateTime(createTime.toLocalDateTime());
        }

        Timestamp updateTime = rs.getTimestamp("update_time");
        if (updateTime != null) {
            question.setUpdateTime(updateTime.toLocalDateTime());
        }

        return question;
    }
}