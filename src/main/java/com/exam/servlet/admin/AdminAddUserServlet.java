package com.exam.servlet.admin;

import com.exam.dao.UserDao;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员添加用户
 */
@WebServlet("/admin/user/add")
public class AdminAddUserServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置请求编码格式
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // 获取表单数据
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        System.out.println("✅ 已触发添加用户逻辑: " + req.getParameter("username"));

        if (username != null && password != null && role != null) {
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);
            userDao.addUser(user);
        }

        // 添加完成后跳回用户列表
        resp.sendRedirect(req.getContextPath() + "/admin/user/list");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        // 默认跳转到添加用户页面
        req.getRequestDispatcher("/admin/admin_add_user.jsp").forward(req, resp);
    }
}
