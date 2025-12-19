package com.exam.servlet.student;

import com.exam.dao.ExamDao;
import com.exam.entity.Exam;
import com.exam.entity.Question;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentExamServlet", urlPatterns = {"/student/exam/take", "/student/exam/submit"})
public class StudentExamServlet extends HttpServlet {

    private final ExamDao examDao = new ExamDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户登录和角色
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"student".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String servletPath = request.getServletPath();
        if (servletPath.endsWith("/take")) {
            // 显示考试界面
            showExamInterface(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/student/exam/list");
        }
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

        String servletPath = request.getServletPath();
        if (servletPath.endsWith("/submit")) {
            // 提交考试答案
            submitExam(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/student/exam/list");
        }
    }

    private void showExamInterface(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String examIdStr = request.getParameter("id");
        if (examIdStr == null || examIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/exam/list");
            return;
        }

        try {
            int examId = Integer.parseInt(examIdStr);
            Exam exam = examDao.findById(examId);

            if (exam == null || !exam.canTakeExam()) {
                response.sendRedirect(request.getContextPath() + "/student/exam/list?error=not_available");
                return;
            }

            // 获取考试试题
            List<Question> questions = examDao.getExamQuestions(examId);
            if (questions.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/student/exam/list?error=no_questions");
                return;
            }

            // 设置请求属性
            request.setAttribute("exam", exam);
            request.setAttribute("questions", questions);
            request.setAttribute("user", user);

            // 转发到考试页面
            request.getRequestDispatcher("/student/student_take_exam.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/exam/list?error=invalid_id");
        }
    }

    private void submitExam(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String examIdStr = request.getParameter("examId");
        if (examIdStr == null || examIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/exam/list");
            return;
        }

        try {
            int examId = Integer.parseInt(examIdStr);
            Exam exam = examDao.findById(examId);

            if (exam == null) {
                response.sendRedirect(request.getContextPath() + "/student/exam/list?error=exam_not_found");
                return;
            }

            // TODO: 这里应该实现答案保存和评分逻辑
            // 目前简化处理，直接显示成功页面

            // 获取用户答案
            List<Question> questions = examDao.getExamQuestions(examId);

            // 保存考试记录（简化版）
            // 在实际应用中，这里需要：
            // 1. 保存学生的答案
            // 2. 计算得分
            // 3. 保存成绩记录
            // 4. 更新考试统计

            request.setAttribute("exam", exam);
            request.setAttribute("user", user);
            request.setAttribute("questionCount", questions.size());

            // 转发到考试完成页面
            request.getRequestDispatcher("/student/student_exam_complete.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/exam/list?error=invalid_id");
        }
    }
}