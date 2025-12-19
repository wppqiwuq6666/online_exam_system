package com.exam.servlet;

import com.exam.dao.UserDao;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // ✅ 调用实际存在的 login() 方法，而不是不存在的 findByUsername()
        User user = userDao.login(username, password, role);

        if (user != null) {
            // 登录成功
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(60 * 30); // 30分钟

            // 根据角色跳转不同首页
            switch (role) {
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/admin/home.jsp");
                    break;
                case "teacher":
                    response.sendRedirect(request.getContextPath() + "/teacher/home.jsp");
                    break;
                case "student":
                    response.sendRedirect(request.getContextPath() + "/student/home.jsp");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    break;
            }

        } else {
            // 登录失败
            request.setAttribute("error", "用户名或密码或角色不正确");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
