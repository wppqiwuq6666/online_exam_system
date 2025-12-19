package com.exam.servlet.admin;

import com.exam.dao.ClassDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员删除班级
 */
@WebServlet("/admin/class/delete")
public class AdminDeleteClassServlet extends HttpServlet {

    private ClassDao classDao = new ClassDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        String id = req.getParameter("id");
        if (id != null && id.matches("\\d+")) {
            boolean success = classDao.deleteById(Integer.parseInt(id));

            if (success) {
                req.setAttribute("message", "班级删除成功！");
            } else {
                req.setAttribute("error", "班级删除失败，请重试！");
            }
        } else {
            req.setAttribute("error", "无效的班级ID！");
        }

        // 重新查询班级列表
        req.setAttribute("classes", classDao.findAll());
        req.setAttribute("classCount", classDao.getClassCount());

        // 跳转页面
        req.getRequestDispatcher("/admin/admin_class_list.jsp").forward(req, resp);
    }
}