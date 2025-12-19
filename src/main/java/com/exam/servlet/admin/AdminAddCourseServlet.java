package com.exam.servlet.admin;

import com.exam.dao.CourseDao;
import com.exam.entity.Course;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员添加课程
 */
@WebServlet("/admin/course/add")
public class AdminAddCourseServlet extends HttpServlet {

    private CourseDao courseDao = new CourseDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置请求编码格式
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // 获取表单数据
        String courseName = req.getParameter("courseName");
        String courseCode = req.getParameter("courseCode");
        String description = req.getParameter("description");
        String teacherName = req.getParameter("teacherName");
        String creditStr = req.getParameter("credit");
        String semester = req.getParameter("semester");
        String status = req.getParameter("status");

        // 设置默认值
        int credit = 0;
        if (creditStr != null && !creditStr.trim().isEmpty()) {
            try {
                credit = Integer.parseInt(creditStr.trim());
            } catch (NumberFormatException e) {
                credit = 0;
            }
        }

        if (courseName != null && !courseName.trim().isEmpty() &&
            courseCode != null && !courseCode.trim().isEmpty() &&
            semester != null && !semester.trim().isEmpty()) {

            Course c = new Course();
            c.setCourseName(courseName.trim());
            c.setCourseCode(courseCode.trim());
            c.setDescription(description != null ? description.trim() : "");
            c.setTeacherName(teacherName != null ? teacherName.trim() : "");
            c.setCredit(credit);
            c.setSemester(semester.trim());
            c.setStatus(status != null ? status.trim() : "active");

            boolean success = courseDao.addCourse(c);

            if (success) {
                req.setAttribute("message", "课程添加成功！");
            } else {
                req.setAttribute("error", "课程添加失败，请重试！");
            }
        } else {
            req.setAttribute("error", "课程名称、课程代码和学期不能为空！");
        }

        // 重新查询课程列表
        req.setAttribute("courses", courseDao.findAll());
        req.setAttribute("courseCount", courseDao.getCourseCount());
        req.setAttribute("semesters", courseDao.getAllSemesters());

        // 跳转页面
        req.getRequestDispatcher("/admin/admin_course_list.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        // 默认跳转到添加课程页面
        req.getRequestDispatcher("/admin/admin_add_course.jsp").forward(req, resp);
    }
}