package com.exam.servlet.teacher;

import com.exam.dao.QuestionDao;
import com.exam.entity.Question;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeacherQuestionListServlet", urlPatterns = {"/teacher/question/list"})
public class TeacherQuestionListServlet extends HttpServlet {

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

        // 获取搜索参数
        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        String subject = request.getParameter("subject");

        // 查询试题
        List<Question> questions;
        if (keyword != null || (type != null && !type.equals("all")) ||
            (subject != null && !subject.equals("all"))) {
            questions = questionDao.search(keyword, type, subject, user.getId());
        } else {
            questions = questionDao.findByTeacherId(user.getId());
        }

        // 获取所有科目
        List<String> subjects = questionDao.getAllSubjects();

        // 设置请求属性
        request.setAttribute("questions", questions);
        request.setAttribute("subjects", subjects);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedType", type);
        request.setAttribute("selectedSubject", subject);

        // 转发到题库列表页面
        request.getRequestDispatcher("/teacher/teacher_question_list.jsp")
                .forward(request, response);
    }
}