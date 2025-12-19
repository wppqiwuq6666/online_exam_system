package com.exam.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // Update these constants to match your local MySQL setup
    private static final String URL = "jdbc:mysql://localhost:3306/exam_system?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // no password

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
