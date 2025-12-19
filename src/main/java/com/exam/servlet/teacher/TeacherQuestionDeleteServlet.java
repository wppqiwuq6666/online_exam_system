package com.exam.servlet.teacher;

import com.exam.dao.QuestionDao;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "TeacherQuestionDeleteServlet", urlPatterns = {"/teacher/question/delete"})
public class TeacherQuestionDeleteServlet extends HttpServlet {

    private final QuestionDao questionDao = new QuestionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户登录和角色
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"teacher".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 获取试题ID
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/question/list");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            // 检查试题是否存在且属于当前教师
            var question = questionDao.findById(id);
            if (question == null || question.getTeacherId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/teacher/question/list?error=unauthorized");
                return;
            }

            // 删除试题
            boolean success = questionDao.delete(id);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/teacher/question/list?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/question/list?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/teacher/question/list?error=invalid_id");
        }
    }
}