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

@WebServlet(name = "TeacherQuestionAddServlet", urlPatterns = {"/teacher/question/add", "/teacher/question/edit"})
public class TeacherQuestionAddServlet extends HttpServlet {

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

        String servletPath = request.getServletPath();
        if (servletPath.endsWith("/edit")) {
            // 编辑模式，获取试题信息
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/teacher/question/list");
                return;
            }

            int id = Integer.parseInt(idStr);
            Question question = questionDao.findById(id);

            // 检查试题是否存在且属于当前教师
            if (question == null || question.getTeacherId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/teacher/question/list");
                return;
            }

            request.setAttribute("question", question);
            request.setAttribute("isEdit", true);
        } else {
            // 添加模式
            request.setAttribute("isEdit", false);
        }

        request.getRequestDispatcher("/teacher/teacher_question_form.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置编码
        request.setCharacterEncoding("UTF-8");

        // 检查用户登录和角色
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"teacher".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 获取表单参数
        String title = request.getParameter("title");
        String type = request.getParameter("type");
        String options = request.getParameter("options");
        String answer = request.getParameter("answer");
        String analysis = request.getParameter("analysis");
        String difficultyStr = request.getParameter("difficulty");
        String subject = request.getParameter("subject");
        String isEditStr = request.getParameter("isEdit");
        String idStr = request.getParameter("id");

        // 参数验证
        if (title == null || title.trim().isEmpty() ||
            type == null || answer == null || answer.trim().isEmpty() ||
            difficultyStr == null || subject == null || subject.trim().isEmpty()) {

            request.setAttribute("error", "请填写完整的试题信息");
            request.getRequestDispatcher("/teacher/teacher_question_form.jsp")
                    .forward(request, response);
            return;
        }

        int difficulty = Integer.parseInt(difficultyStr);
        boolean isEdit = "true".equals(isEditStr);

        try {
            if (isEdit) {
                // 更新试题
                int id = Integer.parseInt(idStr);
                Question question = questionDao.findById(id);

                if (question == null || question.getTeacherId() != user.getId()) {
                    response.sendRedirect(request.getContextPath() + "/teacher/question/list");
                    return;
                }

                question.setTitle(title);
                question.setType(type);
                question.setOptions(options);
                question.setAnswer(answer);
                question.setAnalysis(analysis);
                question.setDifficulty(difficulty);
                question.setSubject(subject);

                boolean success = questionDao.update(question);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/teacher/question/list?success=updated");
                } else {
                    request.setAttribute("error", "更新失败，请重试");
                    request.getRequestDispatcher("/teacher/teacher_question_form.jsp")
                            .forward(request, response);
                }
            } else {
                // 添加新试题
                Question question = new Question(title, type, options, answer,
                                               analysis, difficulty, subject, user.getId());

                boolean success = questionDao.add(question);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/teacher/question/list?success=added");
                } else {
                    request.setAttribute("error", "添加失败，请重试");
                    request.getRequestDispatcher("/teacher/teacher_question_form.jsp")
                            .forward(request, response);
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "参数格式错误");
            request.getRequestDispatcher("/teacher/teacher_question_form.jsp")
                    .forward(request, response);
        }
    }
}