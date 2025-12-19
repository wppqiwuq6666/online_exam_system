package com.exam.servlet.admin;

import com.exam.dao.ClassDao;
import com.exam.entity.Class;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员添加班级
 */
@WebServlet("/admin/class/add")
public class AdminAddClassServlet extends HttpServlet {

    private ClassDao classDao = new ClassDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置请求编码格式
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // 获取表单数据
        String className = req.getParameter("className");
        String grade = req.getParameter("grade");
        String teacherName = req.getParameter("teacherName");
        String description = req.getParameter("description");
        String studentCountStr = req.getParameter("studentCount");

        // 设置默认学生数量
        int studentCount = 0;
        if (studentCountStr != null && !studentCountStr.trim().isEmpty()) {
            try {
                studentCount = Integer.parseInt(studentCountStr.trim());
            } catch (NumberFormatException e) {
                studentCount = 0;
            }
        }

        if (className != null && !className.trim().isEmpty() && grade != null && !grade.trim().isEmpty()) {
            Class c = new Class();
            c.setClassName(className.trim());
            c.setGrade(grade.trim());
            c.setTeacherName(teacherName != null ? teacherName.trim() : "");
            c.setDescription(description != null ? description.trim() : "");
            c.setStudentCount(studentCount);

            boolean success = classDao.addClass(c);

            if (success) {
                req.setAttribute("message", "班级添加成功！");
            } else {
                req.setAttribute("error", "班级添加失败，请重试！");
            }
        } else {
            req.setAttribute("error", "班级名称和年级不能为空！");
        }

        // 重新查询班级列表
        req.setAttribute("classes", classDao.findAll());
        req.setAttribute("classCount", classDao.getClassCount());

        // 跳转页面
        req.getRequestDispatcher("/admin/admin_class_list.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        // 默认跳转到添加班级页面
        req.getRequestDispatcher("/admin/admin_add_class.jsp").forward(req, resp);
    }
}