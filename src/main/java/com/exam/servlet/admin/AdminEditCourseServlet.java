package com.exam.servlet.admin;

import com.exam.dao.CourseDao;
import com.exam.entity.Course;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员编辑课程
 */
@WebServlet("/admin/course/edit")
public class AdminEditCourseServlet extends HttpServlet {

    private CourseDao courseDao = new CourseDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        String id = req.getParameter("id");
        if (id != null && id.matches("\\d+")) {
            Course course = courseDao.findById(Integer.parseInt(id));
            if (course != null) {
                req.setAttribute("course", course);
                req.getRequestDispatcher("/admin/admin_edit_course.jsp").forward(req, resp);
                return;
            }
        }

        // 如果找不到课程或ID无效，返回课程列表
        req.setAttribute("error", "课程不存在或ID无效！");
        req.setAttribute("courses", courseDao.findAll());
        req.setAttribute("courseCount", courseDao.getCourseCount());
        req.setAttribute("semesters", courseDao.getAllSemesters());
        req.getRequestDispatcher("/admin/admin_course_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置请求编码格式
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // 获取表单数据
        String idStr = req.getParameter("id");
        String courseName = req.getParameter("courseName");
        String courseCode = req.getParameter("courseCode");
        String description = req.getParameter("description");
        String teacherName = req.getParameter("teacherName");
        String creditStr = req.getParameter("credit");
        String semester = req.getParameter("semester");
        String status = req.getParameter("status");

        // 验证ID
        if (idStr == null || !idStr.matches("\\d+")) {
            req.setAttribute("error", "无效的课程ID！");
            req.setAttribute("courses", courseDao.findAll());
            req.setAttribute("courseCount", courseDao.getCourseCount());
            req.setAttribute("semesters", courseDao.getAllSemesters());
            req.getRequestDispatcher("/admin/admin_course_list.jsp").forward(req, resp);
            return;
        }

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
            c.setId(Integer.parseInt(idStr));
            c.setCourseName(courseName.trim());
            c.setCourseCode(courseCode.trim());
            c.setDescription(description != null ? description.trim() : "");
            c.setTeacherName(teacherName != null ? teacherName.trim() : "");
            c.setCredit(credit);
            c.setSemester(semester.trim());
            c.setStatus(status != null ? status.trim() : "active");

            boolean success = courseDao.updateCourse(c);

            if (success) {
                req.setAttribute("message", "课程更新成功！");
            } else {
                req.setAttribute("error", "课程更新失败，请重试！");
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
}