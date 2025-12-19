package com.exam.servlet.student;

import com.exam.dao.ExamDao;
import com.exam.entity.Exam;
import com.exam.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "StudentExamListServlet", urlPatterns = {"/student/exam/list"})
public class StudentExamListServlet extends HttpServlet {

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

        // 获取所有发布的考试
        List<Exam> exams = examDao.findExamsForStudent();

        // 分类考试
        List<Exam> availableExams = new ArrayList<>();
        List<Exam> ongoingExams = new ArrayList<>();
        List<Exam> endedExams = new ArrayList<>();

        for (Exam exam : exams) {
            if (exam.canTakeExam()) {
                availableExams.add(exam);
            } else if (exam.isEnded()) {
                endedExams.add(exam);
            } else if (exam.isNotStarted()) {
                ongoingExams.add(exam);
            }
        }

        // 设置请求属性
        request.setAttribute("availableExams", availableExams);
        request.setAttribute("ongoingExams", ongoingExams);
        request.setAttribute("endedExams", endedExams);
        request.setAttribute("allExams", exams);

        // 转发到考试列表页面
        request.getRequestDispatcher("/student/student_exam_list.jsp")
                .forward(request, response);
    }
}