package com.exam.dao;

import com.exam.entity.Exam;
import com.exam.entity.Question;
import com.exam.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDao {

    // 添加考试
    public boolean add(Exam exam) {
        String sql = "INSERT INTO exams (title, description, duration, start_time, end_time, " +
                    "total_score, pass_score, status, teacher_id, create_time, update_time) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, exam.getTitle());
            pstmt.setString(2, exam.getDescription());
            pstmt.setInt(3, exam.getDuration());
            pstmt.setTimestamp(4, exam.getStartTime());
            pstmt.setTimestamp(5, exam.getEndTime());
            pstmt.setInt(6, exam.getTotalScore());
            pstmt.setInt(7, exam.getPassScore());
            pstmt.setString(8, exam.getStatus());
            pstmt.setInt(9, exam.getTeacherId());
            pstmt.setTimestamp(10, exam.getCreateTime());
            pstmt.setTimestamp(11, exam.getUpdateTime());

            int result = pstmt.executeUpdate();
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    exam.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 根据ID查找考试
    public Exam findById(int id) {
        String sql = "SELECT * FROM exams WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractExamFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 获取所有可参加的考试
    public List<Exam> findAvailableExams() {
        String sql = "SELECT * FROM exams WHERE status = 'published' AND " +
                    "start_time <= NOW() AND end_time >= NOW() ORDER BY start_time ASC";

        List<Exam> exams = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                exams.add(extractExamFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exams;
    }

    // 获取学生考试列表（包括未开始、进行中、已结束）
    public List<Exam> findExamsForStudent() {
        String sql = "SELECT * FROM exams WHERE status = 'published' ORDER BY start_time DESC";

        List<Exam> exams = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                exams.add(extractExamFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exams;
    }

    // 获取考试的试题
    public List<Question> getExamQuestions(int examId) {
        String sql = "SELECT q.* FROM questions q " +
                    "JOIN exam_questions eq ON q.id = eq.question_id " +
                    "WHERE eq.exam_id = ? ORDER BY eq.question_order";

        List<Question> questions = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, examId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
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

                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    // 更新考试状态
    public boolean updateStatus(int examId, String status) {
        String sql = "UPDATE exams SET status = ?, update_time = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(3, examId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除考试
    public boolean delete(int id) {
        String sql = "DELETE FROM exams WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 从ResultSet提取Exam对象
    private Exam extractExamFromResultSet(ResultSet rs) throws SQLException {
        Exam exam = new Exam();
        exam.setId(rs.getInt("id"));
        exam.setTitle(rs.getString("title"));
        exam.setDescription(rs.getString("description"));
        exam.setDuration(rs.getInt("duration"));
        exam.setStartTime(rs.getTimestamp("start_time"));
        exam.setEndTime(rs.getTimestamp("end_time"));
        exam.setTotalScore(rs.getInt("total_score"));
        exam.setPassScore(rs.getInt("pass_score"));
        exam.setStatus(rs.getString("status"));
        exam.setTeacherId(rs.getInt("teacher_id"));

        Timestamp createTime = rs.getTimestamp("create_time");
        if (createTime != null) {
            exam.setCreateTime(createTime);
        }

        Timestamp updateTime = rs.getTimestamp("update_time");
        if (updateTime != null) {
            exam.setUpdateTime(updateTime);
        }

        return exam;
    }

    // 获取所有考试（管理员用）
    public List<Exam> findAll() {
        String sql = "SELECT * FROM exams ORDER BY create_time DESC";
        List<Exam> exams = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                exams.add(extractExamFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exams;
    }

    // 更新考试
    public boolean update(Exam exam) {
        String sql = "UPDATE exams SET title = ?, description = ?, duration = ?, " +
                    "start_time = ?, end_time = ?, total_score = ?, pass_score = ?, " +
                    "status = ?, update_time = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, exam.getTitle());
            pstmt.setString(2, exam.getDescription());
            pstmt.setInt(3, exam.getDuration());
            pstmt.setTimestamp(4, exam.getStartTime());
            pstmt.setTimestamp(5, exam.getEndTime());
            pstmt.setInt(6, exam.getTotalScore());
            pstmt.setInt(7, exam.getPassScore());
            pstmt.setString(8, exam.getStatus());
            pstmt.setTimestamp(9, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(10, exam.getId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}