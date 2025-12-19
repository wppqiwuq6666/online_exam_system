package com.exam.servlet.admin;

import com.exam.dao.CourseDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员删除课程
 */
@WebServlet("/admin/course/delete")
public class AdminDeleteCourseServlet extends HttpServlet {

    private CourseDao courseDao = new CourseDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        String id = req.getParameter("id");
        if (id != null && id.matches("\\d+")) {
            boolean success = courseDao.deleteById(Integer.parseInt(id));

            if (success) {
                req.setAttribute("message", "课程删除成功！");
            } else {
                req.setAttribute("error", "课程删除失败，请重试！");
            }
        } else {
            req.setAttribute("error", "无效的课程ID！");
        }

        // 重新查询课程列表
        req.setAttribute("courses", courseDao.findAll());
        req.setAttribute("courseCount", courseDao.getCourseCount());
        req.setAttribute("semesters", courseDao.getAllSemesters());

        // 跳转页面
        req.getRequestDispatcher("/admin/admin_course_list.jsp").forward(req, resp);
    }
}