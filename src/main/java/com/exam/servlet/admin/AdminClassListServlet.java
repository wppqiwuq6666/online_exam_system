package com.exam.servlet.admin;

import com.exam.dao.ClassDao;
import com.exam.entity.Class;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员查看所有班级
 */
@WebServlet("/admin/class/list")
public class AdminClassListServlet extends HttpServlet {

    private ClassDao classDao = new ClassDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        // 获取搜索关键词
        String keyword = req.getParameter("search");
        List<Class> classes;

        if (keyword != null && !keyword.trim().isEmpty()) {
            classes = classDao.searchClasses(keyword.trim());
        } else {
            classes = classDao.findAll();
        }

        // 设置属性传给 JSP
        req.setAttribute("classes", classes);
        req.setAttribute("classCount", classDao.getClassCount());
        req.setAttribute("searchKeyword", keyword);

        // 跳转页面
        req.getRequestDispatcher("/admin/admin_class_list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}