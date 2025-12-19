package com.exam.servlet.admin;

import com.exam.dao.ScoreDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员删除成绩
 */
@WebServlet("/admin/score/delete")
public class AdminDeleteScoreServlet extends HttpServlet {

    private ScoreDao scoreDao = new ScoreDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        String id = req.getParameter("id");
        if (id != null && id.matches("\\d+")) {
            boolean success = scoreDao.deleteById(Integer.parseInt(id));

            if (success) {
                req.setAttribute("message", "成绩删除成功！");
            } else {
                req.setAttribute("error", "成绩删除失败，请重试！");
            }
        } else {
            req.setAttribute("error", "无效的成绩ID！");
        }

        // 重新查询成绩列表
        req.setAttribute("scores", scoreDao.findAll());
        req.setAttribute("scoreCount", scoreDao.getScoreCount());
        req.setAttribute("courses", scoreDao.getAllCourses());
        req.setAttribute("passRate", String.format("%.1f", scoreDao.getPassRate()));
        req.setAttribute("averageScore", String.format("%.1f", scoreDao.getAverageScore()));
        req.setAttribute("maxScore", String.format("%.1f", scoreDao.getMaxScore()));

        // 跳转页面
        req.getRequestDispatcher("/admin/admin_score_list.jsp").forward(req, resp);
    }
}