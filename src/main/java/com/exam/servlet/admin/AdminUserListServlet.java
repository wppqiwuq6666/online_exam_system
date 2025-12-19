package com.exam.servlet.admin;

import com.exam.dao.UserDao;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员查看所有用户
 */
@WebServlet("/admin/user/list")
public class AdminUserListServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        // 获取所有用户
        List<User> users = userDao.findAll();
        // 设置属性传给 JSP
        req.setAttribute("users", users);
        // 跳转页面
        req.getRequestDispatcher("/admin/admin_user_list.jsp").forward(req, resp);
    }
}
