package com.exam.servlet.student;

import com.exam.dao.UserDao;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "StudentProfileServlet", urlPatterns = {"/student/profile"})
public class StudentProfileServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户登录和角色
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"student".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 获取最新的用户信息
        User updatedUser = userDao.findById(user.getId());
        if (updatedUser != null) {
            // 更新session中的用户信息
            request.getSession().setAttribute("currentUser", updatedUser);
            request.setAttribute("user", updatedUser);
        } else {
            request.setAttribute("user", user);
        }

        // 转发到个人设置页面
        request.getRequestDispatcher("/student/student_profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置编码
        request.setCharacterEncoding("UTF-8");

        // 检查用户登录和角色
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"student".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            // 更新个人信息
            updateProfile(request, response, user);
        } else if ("changePassword".equals(action)) {
            // 修改密码
            changePassword(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/student/profile");
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String displayName = request.getParameter("displayName");

        // 参数验证
        if (displayName == null || displayName.trim().isEmpty()) {
            request.setAttribute("error", "显示名称不能为空");
            doGet(request, response);
            return;
        }

        // 更新用户信息
        user.setDisplayName(displayName.trim());
        boolean success = userDao.update(user);

        if (success) {
            // 更新session
            request.getSession().setAttribute("currentUser", user);
            response.sendRedirect(request.getContextPath() + "/student/profile?success=profile");
        } else {
            request.setAttribute("error", "更新失败，请重试");
            doGet(request, response);
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 参数验证
        if (oldPassword == null || oldPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("error", "所有密码字段都必须填写");
            request.setAttribute("activeTab", "password");
            doGet(request, response);
            return;
        }

        // 验证新密码
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "新密码与确认密码不匹配");
            request.setAttribute("activeTab", "password");
            doGet(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "新密码长度不能少于6位");
            request.setAttribute("activeTab", "password");
            doGet(request, response);
            return;
        }

        // 修改密码
        boolean success = userDao.changePassword(user.getId(), oldPassword, newPassword);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/student/profile?success=password");
        } else {
            request.setAttribute("error", "旧密码不正确或修改失败");
            request.setAttribute("activeTab", "password");
            doGet(request, response);
        }
    }
}