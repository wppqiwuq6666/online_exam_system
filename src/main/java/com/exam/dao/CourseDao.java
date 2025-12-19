package com.exam.dao;

import com.exam.entity.Course;
import com.exam.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDao {

    // 查询所有课程
    public List<Course> findAll() {
        List<Course> courseList = new ArrayList<>();
        String sql = "SELECT * FROM course ORDER BY semester, course_code";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setCourseName(rs.getString("course_name"));
                c.setCourseCode(rs.getString("course_code"));
                c.setDescription(rs.getString("description"));
                c.setTeacherName(rs.getString("teacher_name"));
                c.setCredit(rs.getInt("credit"));
                c.setSemester(rs.getString("semester"));
                c.setStatus(rs.getString("status"));
                c.setCreateTime(rs.getTimestamp("created_time"));
                c.setUpdateTime(rs.getTimestamp("updated_time"));
                courseList.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courseList;
    }

    // 根据ID查询课程
    public Course findById(int id) {
        String sql = "SELECT * FROM course WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setCourseName(rs.getString("course_name"));
                c.setCourseCode(rs.getString("course_code"));
                c.setDescription(rs.getString("description"));
                c.setTeacherName(rs.getString("teacher_name"));
                c.setCredit(rs.getInt("credit"));
                c.setSemester(rs.getString("semester"));
                c.setStatus(rs.getString("status"));
                c.setCreateTime(rs.getTimestamp("created_time"));
                c.setUpdateTime(rs.getTimestamp("updated_time"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // 添加课程
    public boolean addCourse(Course c) {
        String sql = "INSERT INTO course(course_name, course_code, description, teacher_name, credit, semester, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getCourseName());
            ps.setString(2, c.getCourseCode());
            ps.setString(3, c.getDescription());
            ps.setString(4, c.getTeacherName());
            ps.setInt(5, c.getCredit());
            ps.setString(6, c.getSemester());
            ps.setString(7, c.getStatus() != null ? c.getStatus() : "active");

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 更新课程
    public boolean updateCourse(Course c) {
        String sql = "UPDATE course SET course_name = ?, course_code = ?, description = ?, teacher_name = ?, credit = ?, semester = ?, status = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getCourseName());
            ps.setString(2, c.getCourseCode());
            ps.setString(3, c.getDescription());
            ps.setString(4, c.getTeacherName());
            ps.setInt(5, c.getCredit());
            ps.setString(6, c.getSemester());
            ps.setString(7, c.getStatus() != null ? c.getStatus() : "active");
            ps.setInt(8, c.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除课程
    public boolean deleteById(int id) {
        String sql = "DELETE FROM course WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 搜索课程（按课程名称、课程代码或教师姓名）
    public List<Course> searchCourses(String keyword) {
        List<Course> courseList = new ArrayList<>();
        String sql = "SELECT * FROM course WHERE course_name LIKE ? OR course_code LIKE ? OR teacher_name LIKE ? ORDER BY semester, course_code";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setCourseName(rs.getString("course_name"));
                c.setCourseCode(rs.getString("course_code"));
                c.setDescription(rs.getString("description"));
                c.setTeacherName(rs.getString("teacher_name"));
                c.setCredit(rs.getInt("credit"));
                c.setSemester(rs.getString("semester"));
                c.setStatus(rs.getString("status"));
                c.setCreateTime(rs.getTimestamp("created_time"));
                c.setUpdateTime(rs.getTimestamp("updated_time"));
                courseList.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courseList;
    }

    // 按学期查询课程
    public List<Course> findBySemester(String semester) {
        List<Course> courseList = new ArrayList<>();
        String sql = "SELECT * FROM course WHERE semester = ? ORDER BY course_code";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, semester);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setCourseName(rs.getString("course_name"));
                c.setCourseCode(rs.getString("course_code"));
                c.setDescription(rs.getString("description"));
                c.setTeacherName(rs.getString("teacher_name"));
                c.setCredit(rs.getInt("credit"));
                c.setSemester(rs.getString("semester"));
                c.setStatus(rs.getString("status"));
                c.setCreateTime(rs.getTimestamp("created_time"));
                c.setUpdateTime(rs.getTimestamp("updated_time"));
                courseList.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courseList;
    }

    // 获取课程总数
    public int getCourseCount() {
        String sql = "SELECT COUNT(*) FROM course";

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

    // 获取所有学期列表
    public List<String> getAllSemesters() {
        List<String> semesters = new ArrayList<>();
        String sql = "SELECT DISTINCT semester FROM course ORDER BY semester DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                semesters.add(rs.getString("semester"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return semesters;
    }
}