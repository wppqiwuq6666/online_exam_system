package com.exam.dao;

import com.exam.entity.User;
import com.exam.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    // 登录方法
    public User login(String username, String password, String role) {
        String sql = "SELECT * FROM user WHERE username=? AND password=? AND role=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setRole(rs.getString("role"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //  查询所有用户
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM user";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //  添加用户
    public void addUser(User user) {
        String sql = "INSERT INTO user(username, password, role) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //  根据 ID 删除用户
    public void deleteById(int id) {
        String sql = "DELETE FROM user WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 根据ID查找用户
    public User findById(int id) {
        String sql = "SELECT * FROM user WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setRole(rs.getString("role"));
                u.setDisplayName(rs.getString("display_name"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 更新用户信息
    public boolean update(User user) {
        String sql = "UPDATE user SET display_name = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getDisplayName());
            ps.setInt(2, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 修改密码
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        // 先验证旧密码
        String checkSql = "SELECT id FROM user WHERE id = ? AND password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, userId);
            checkPs.setString(2, oldPassword);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // 旧密码正确，更新密码
                String updateSql = "UPDATE user SET password = ? WHERE id = ?";
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setString(1, newPassword);
                    updatePs.setInt(2, userId);
                    return updatePs.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 验证密码
    public boolean verifyPassword(int userId, String password) {
        String sql = "SELECT id FROM user WHERE id = ? AND password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
