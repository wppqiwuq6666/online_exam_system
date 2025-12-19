package com.exam.servlet.teacher;

import com.exam.dao.ScoreDao;
import com.exam.dao.CourseDao;
import com.exam.entity.Score;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeacherScoreListServlet", urlPatterns = {"/teacher/score/list"})
public class TeacherScoreListServlet extends HttpServlet {

    private final ScoreDao scoreDao = new ScoreDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户登录和角色
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"teacher".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 获取搜索和筛选参数
        String keyword = request.getParameter("keyword");
        String course = request.getParameter("course");
        String status = request.getParameter("status");

        // 查询成绩数据
        List<Score> scores;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // 关键词搜索
            scores = scoreDao.searchScores(keyword);
        } else {
            // 获取所有成绩（这里简化处理，实际应该根据教师所授课程筛选）
            scores = scoreDao.findAll();
        }

        // 获取统计数据
        int totalScores = scoreDao.getScoreCount();
        double passRate = scoreDao.getPassRate();
        double averageScore = scoreDao.getAverageScore();
        double maxScore = scoreDao.getMaxScore();

        // 获取所有课程列表
        List<String> courses = scoreDao.getAllCourses();

        // 设置请求属性
        request.setAttribute("scores", scores);
        request.setAttribute("courses", courses);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCourse", course);
        request.setAttribute("selectedStatus", status);

        // 设置统计数据
        request.setAttribute("totalScores", totalScores);
        request.setAttribute("passRate", String.format("%.1f", passRate));
        request.setAttribute("averageScore", String.format("%.1f", averageScore));
        request.setAttribute("maxScore", String.format("%.1f", maxScore));

        // 转发到成绩列表页面
        request.getRequestDispatcher("/teacher/teacher_score_list.jsp")
                .forward(request, response);
    }
}