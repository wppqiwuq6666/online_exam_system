package com.exam.servlet.student;

import com.exam.dao.ScoreDao;
import com.exam.entity.Score;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentScoreServlet", urlPatterns = {"/student/score/list"})
public class StudentScoreServlet extends HttpServlet {

    private final ScoreDao scoreDao = new ScoreDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户登录和角色
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"student".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 获取当前学生的所有成绩
        List<Score> scores = scoreDao.findByStudent(user.getId());

        // 计算统计数据
        int totalExams = scores.size();
        int passedExams = 0;
        double totalScore = 0;
        double highestScore = 0;
        double lowestScore = 100;

        for (Score score : scores) {
            totalScore += score.getScore();
            if (score.isPassed()) {
                passedExams++;
            }
            if (score.getScore() > highestScore) {
                highestScore = score.getScore();
            }
            if (score.getScore() < lowestScore) {
                lowestScore = score.getScore();
            }
        }

        double averageScore = totalExams > 0 ? totalScore / totalExams : 0;
        double passRate = totalExams > 0 ? (double) passedExams / totalExams * 100 : 0;

        // 设置请求属性
        request.setAttribute("scores", scores);
        request.setAttribute("totalExams", totalExams);
        request.setAttribute("passedExams", passedExams);
        request.setAttribute("averageScore", String.format("%.1f", averageScore));
        request.setAttribute("highestScore", String.format("%.1f", highestScore));
        request.setAttribute("lowestScore", String.format("%.1f", lowestScore));
        request.setAttribute("passRate", String.format("%.1f", passRate));

        // 转发到成绩列表页面
        request.getRequestDispatcher("/student/student_score_list.jsp")
                .forward(request, response);
    }
}