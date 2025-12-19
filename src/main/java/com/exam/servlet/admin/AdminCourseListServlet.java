package com.exam.servlet.admin;

import com.exam.dao.CourseDao;
import com.exam.entity.Course;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员查看所有课程
 */
@WebServlet("/admin/course/list")
public class AdminCourseListServlet extends HttpServlet {

    private CourseDao courseDao = new CourseDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        // 获取搜索关键词和学期筛选
        String keyword = req.getParameter("search");
        String semester = req.getParameter("semester");
        List<Course> courses;

        if (keyword != null && !keyword.trim().isEmpty()) {
            courses = courseDao.searchCourses(keyword.trim());
        } else if (semester != null && !semester.trim().isEmpty() && !"all".equals(semester.trim())) {
            courses = courseDao.findBySemester(semester.trim());
        } else {
            courses = courseDao.findAll();
        }

        // 设置属性传给 JSP
        req.setAttribute("courses", courses);
        req.setAttribute("courseCount", courseDao.getCourseCount());
        req.setAttribute("searchKeyword", keyword);
        req.setAttribute("selectedSemester", semester);
        req.setAttribute("semesters", courseDao.getAllSemesters());

        // 跳转页面
        req.getRequestDispatcher("/admin/admin_course_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}