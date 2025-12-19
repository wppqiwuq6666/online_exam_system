package com.exam.dao;

import com.exam.entity.Score;
import com.exam.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScoreDao {

    // 查询所有成绩
    public List<Score> findAll() {
        List<Score> scoreList = new ArrayList<>();
        String sql = "SELECT s.*, u.display_name as student_name, c.course_name, " +
                    "CONCAT(c.course_name, ' 期末考试') as exam_title " +
                    "FROM score s " +
                    "LEFT JOIN user u ON s.student_id = u.id " +
                    "LEFT JOIN course c ON s.course_id = c.id " +
                    "ORDER BY s.exam_time DESC, s.created_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Score s = new Score();
                s.setId(rs.getInt("id"));
                s.setStudentId(rs.getInt("student_id"));
                s.setCourseId(rs.getInt("course_id"));
                s.setExamId(rs.getInt("exam_id"));
                s.setStudentName(rs.getString("student_name"));
                s.setCourseName(rs.getString("course_name"));
                s.setExamTitle(rs.getString("exam_title"));
                s.setScore(rs.getDouble("score"));
                s.setMaxScore(rs.getDouble("max_score"));
                s.setStatus(rs.getString("status"));
                s.setExamTime(rs.getTimestamp("exam_time"));
                s.setCreateTime(rs.getTimestamp("created_time"));
                scoreList.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return scoreList;
    }

    // 根据ID查询成绩
    public Score findById(int id) {
        String sql = "SELECT s.*, u.display_name as student_name, c.course_name, " +
                    "CONCAT(c.course_name, ' 期末考试') as exam_title " +
                    "FROM score s " +
                    "LEFT JOIN user u ON s.student_id = u.id " +
                    "LEFT JOIN course c ON s.course_id = c.id " +
                    "WHERE s.id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Score s = new Score();
                s.setId(rs.getInt("id"));
                s.setStudentId(rs.getInt("student_id"));
                s.setCourseId(rs.getInt("course_id"));
                s.setExamId(rs.getInt("exam_id"));
                s.setStudentName(rs.getString("student_name"));
                s.setCourseName(rs.getString("course_name"));
                s.setExamTitle(rs.getString("exam_title"));
                s.setScore(rs.getDouble("score"));
                s.setMaxScore(rs.getDouble("max_score"));
                s.setStatus(rs.getString("status"));
                s.setExamTime(rs.getTimestamp("exam_time"));
                s.setCreateTime(rs.getTimestamp("created_time"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // 按学生查询成绩
    public List<Score> findByStudent(int studentId) {
        List<Score> scoreList = new ArrayList<>();
        String sql = "SELECT s.*, u.display_name as student_name, c.course_name, " +
                    "CONCAT(c.course_name, ' 期末考试') as exam_title " +
                    "FROM score s " +
                    "LEFT JOIN user u ON s.student_id = u.id " +
                    "LEFT JOIN course c ON s.course_id = c.id " +
                    "WHERE s.student_id = ? " +
                    "ORDER BY s.exam_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Score s = new Score();
                s.setId(rs.getInt("id"));
                s.setStudentId(rs.getInt("student_id"));
                s.setCourseId(rs.getInt("course_id"));
                s.setExamId(rs.getInt("exam_id"));
                s.setStudentName(rs.getString("student_name"));
                s.setCourseName(rs.getString("course_name"));
                s.setExamTitle(rs.getString("exam_title"));
                s.setScore(rs.getDouble("score"));
                s.setMaxScore(rs.getDouble("max_score"));
                s.setStatus(rs.getString("status"));
                s.setExamTime(rs.getTimestamp("exam_time"));
                s.setCreateTime(rs.getTimestamp("created_time"));
                scoreList.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return scoreList;
    }

    // 按课程查询成绩
    public List<Score> findByCourse(int courseId) {
        List<Score> scoreList = new ArrayList<>();
        String sql = "SELECT s.*, u.display_name as student_name, c.course_name, " +
                    "CONCAT(c.course_name, ' 期末考试') as exam_title " +
                    "FROM score s " +
                    "LEFT JOIN user u ON s.student_id = u.id " +
                    "LEFT JOIN course c ON s.course_id = c.id " +
                    "WHERE s.course_id = ? " +
                    "ORDER BY s.exam_time DESC, s.score DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Score s = new Score();
                s.setId(rs.getInt("id"));
                s.setStudentId(rs.getInt("student_id"));
                s.setCourseId(rs.getInt("course_id"));
                s.setExamId(rs.getInt("exam_id"));
                s.setStudentName(rs.getString("student_name"));
                s.setCourseName(rs.getString("course_name"));
                s.setExamTitle(rs.getString("exam_title"));
                s.setScore(rs.getDouble("score"));
                s.setMaxScore(rs.getDouble("max_score"));
                s.setStatus(rs.getString("status"));
                s.setExamTime(rs.getTimestamp("exam_time"));
                s.setCreateTime(rs.getTimestamp("created_time"));
                scoreList.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return scoreList;
    }

    // 搜索成绩（按学生姓名、课程名称、考试名称）
    public List<Score> searchScores(String keyword) {
        List<Score> scoreList = new ArrayList<>();
        String sql = "SELECT s.*, u.display_name as student_name, c.course_name, " +
                    "CONCAT(c.course_name, ' 期末考试') as exam_title " +
                    "FROM score s " +
                    "LEFT JOIN user u ON s.student_id = u.id " +
                    "LEFT JOIN course c ON s.course_id = c.id " +
                    "WHERE u.display_name LIKE ? OR c.course_name LIKE ? OR CONCAT(c.course_name, ' 期末考试') LIKE ? " +
                    "ORDER BY s.exam_time DESC, s.created_time DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Score s = new Score();
                s.setId(rs.getInt("id"));
                s.setStudentId(rs.getInt("student_id"));
                s.setCourseId(rs.getInt("course_id"));
                s.setExamId(rs.getInt("exam_id"));
                s.setStudentName(rs.getString("student_name"));
                s.setCourseName(rs.getString("course_name"));
                s.setExamTitle(rs.getString("exam_title"));
                s.setScore(rs.getDouble("score"));
                s.setMaxScore(rs.getDouble("max_score"));
                s.setStatus(rs.getString("status"));
                s.setExamTime(rs.getTimestamp("exam_time"));
                s.setCreateTime(rs.getTimestamp("created_time"));
                scoreList.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return scoreList;
    }

    // 添加成绩
    public boolean addScore(Score s) {
        String sql = "INSERT INTO score(student_id, course_id, exam_id, score, max_score, status, exam_time) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, s.getStudentId());
            ps.setInt(2, s.getCourseId());
            ps.setInt(3, s.getExamId());
            ps.setDouble(4, s.getScore());
            ps.setDouble(5, s.getMaxScore());
            ps.setString(6, s.getStatus() != null ? s.getStatus() : "pending");
            ps.setTimestamp(7, s.getExamTime());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除成绩
    public boolean deleteById(int id) {
        String sql = "DELETE FROM score WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 获取成绩总数
    public int getScoreCount() {
        String sql = "SELECT COUNT(*) FROM score";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // 获取及格率
    public double getPassRate() {
        String sql = "SELECT " +
                    "SUM(CASE WHEN (score / max_score) >= 0.6 OR status = 'passed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as pass_rate " +
                    "FROM score WHERE max_score > 0";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("pass_rate");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // 获取平均分
    public double getAverageScore() {
        String sql = "SELECT AVG(score) as avg_score FROM score";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("avg_score");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // 获取最高分
    public double getMaxScore() {
        String sql = "SELECT MAX(score) as max_score FROM score";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("max_score");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // 获取所有课程列表（用于筛选）
    public List<String> getAllCourses() {
        List<String> courses = new ArrayList<>();
        String sql = "SELECT DISTINCT c.course_name FROM score s " +
                    "LEFT JOIN course c ON s.course_id = c.id " +
                    "WHERE c.course_name IS NOT NULL ORDER BY c.course_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                courses.add(rs.getString("course_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courses;
    }
}