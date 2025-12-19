package com.exam.servlet.admin;

import com.exam.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员删除用户
 */
@WebServlet("/admin/user/delete")
public class AdminDeleteUserServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码格式
        resp.setContentType("text/html;charset=UTF-8");

        String id = req.getParameter("id");
        if (id != null && id.matches("\\d+")) {
            userDao.deleteById(Integer.parseInt(id));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/user/list");
    }
}
