package com.exam.dao;

import com.exam.entity.Class;
import com.exam.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClassDao {

    // 查询所有班级
    public List<Class> findAll() {
        List<Class> classList = new ArrayList<>();
        String sql = "SELECT * FROM class ORDER BY grade, class_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Class c = new Class();
                c.setId(rs.getInt("id"));
                c.setClassName(rs.getString("class_name"));
                c.setGrade(rs.getString("grade"));
                c.setTeacherName(rs.getString("teacher_name"));
                c.setDescription(rs.getString("description"));
                c.setStudentCount(rs.getInt("student_count"));
                classList.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return classList;
    }

    // 根据ID查询班级
    public Class findById(int id) {
        String sql = "SELECT * FROM class WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Class c = new Class();
                c.setId(rs.getInt("id"));
                c.setClassName(rs.getString("class_name"));
                c.setGrade(rs.getString("grade"));
                c.setTeacherName(rs.getString("teacher_name"));
                c.setDescription(rs.getString("description"));
                c.setStudentCount(rs.getInt("student_count"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // 添加班级
    public boolean addClass(Class c) {
        String sql = "INSERT INTO class(class_name, grade, teacher_name, description, student_count) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getClassName());
            ps.setString(2, c.getGrade());
            ps.setString(3, c.getTeacherName());
            ps.setString(4, c.getDescription());
            ps.setInt(5, c.getStudentCount());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 更新班级
    public boolean updateClass(Class c) {
        String sql = "UPDATE class SET class_name = ?, grade = ?, teacher_name = ?, description = ?, student_count = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getClassName());
            ps.setString(2, c.getGrade());
            ps.setString(3, c.getTeacherName());
            ps.setString(4, c.getDescription());
            ps.setInt(5, c.getStudentCount());
            ps.setInt(6, c.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除班级
    public boolean deleteById(int id) {
        String sql = "DELETE FROM class WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 搜索班级（按班级名称或年级）
    public List<Class> searchClasses(String keyword) {
        List<Class> classList = new ArrayList<>();
        String sql = "SELECT * FROM class WHERE class_name LIKE ? OR grade LIKE ? ORDER BY grade, class_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Class c = new Class();
                c.setId(rs.getInt("id"));
                c.setClassName(rs.getString("class_name"));
                c.setGrade(rs.getString("grade"));
                c.setTeacherName(rs.getString("teacher_name"));
                c.setDescription(rs.getString("description"));
                c.setStudentCount(rs.getInt("student_count"));
                classList.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return classList;
    }

    // 获取班级总数
    public int getClassCount() {
        String sql = "SELECT COUNT(*) FROM class";

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
}