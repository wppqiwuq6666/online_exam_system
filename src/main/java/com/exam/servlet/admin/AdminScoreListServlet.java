package com.exam.servlet.admin;

import com.exam.dao.ScoreDao;
import com.exam.entity.Score;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员查看所有成绩
 */
@WebServlet("/admin/score/list")
public class AdminScoreListServlet extends HttpServlet {

    private ScoreDao scoreDao = new ScoreDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        // 获取搜索关键词和课程筛选
        String keyword = req.getParameter("search");
        String course = req.getParameter("course");
        List<Score> scores;

        if (keyword != null && !keyword.trim().isEmpty()) {
            scores = scoreDao.searchScores(keyword.trim());
        } else if (course != null && !course.trim().isEmpty() && !"all".equals(course.trim())) {
            // 按课程名称筛选（这里简化处理，实际可能需要按courseId筛选）
            scores = scoreDao.findAll(); // 简化处理，实际应该调用按课程筛选的方法
            scores.removeIf(score -> !course.trim().equals(score.getCourseName()));
        } else {
            scores = scoreDao.findAll();
        }

        // 设置属性传给 JSP
        req.setAttribute("scores", scores);
        req.setAttribute("scoreCount", scoreDao.getScoreCount());
        req.setAttribute("searchKeyword", keyword);
        req.setAttribute("selectedCourse", course);
        req.setAttribute("courses", scoreDao.getAllCourses());

        // 统计信息
        req.setAttribute("passRate", String.format("%.1f", scoreDao.getPassRate()));
        req.setAttribute("averageScore", String.format("%.1f", scoreDao.getAverageScore()));
        req.setAttribute("maxScore", String.format("%.1f", scoreDao.getMaxScore()));

        // 跳转页面
        req.getRequestDispatcher("/admin/admin_score_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}