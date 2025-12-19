<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%@ page import="com.exam.entity.Exam" %>
<%@ page import="com.exam.entity.Question" %>
<%@ page import="java.util.List" %>
<%
    User u = (User) session.getAttribute("currentUser");
    if (u == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }
    if (!"student".equals(u.getRole())) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
    Exam exam = (Exam) request.getAttribute("exam");
    List<Question> questions = (List<Question>) request.getAttribute("questions");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=exam != null ? exam.getTitle() : "考试"%> - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{background:#f8f6ff;}
        .exam-header{background:linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%); color:white; padding:20px 0; position:sticky; top:0; z-index:100;}
        .question-card{background:white; border-radius:10px; box-shadow:0 2px 8px rgba(155, 89, 182, 0.1); margin-bottom:20px; padding:25px;}
        .question-number{background:linear-gradient(135deg, #9b59b6, #8e44ad); color:white; width:30px; height:30px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size:14px;}
        .option-item{background:#f8f9fa; border-radius:8px; padding:15px; margin-bottom:10px; border:2px solid transparent; transition:all 0.2s; cursor:pointer;}
        .option-item:hover{background:#e9ecef; border-color:#9b59b6;}
        .option-item.selected{background:#f3e5f5; border-color:#9b59b6;}
        .timer-display{font-size:1.2rem; font-weight:bold; background:rgba(255,255,255,0.2); padding:8px 16px; border-radius:20px;}
        .progress-info{background:rgba(255,255,255,0.2); padding:10px 16px; border-radius:15px;}
        .btn-submit{background:linear-gradient(135deg, #27ae60, #229954); border:none; color:white; padding:12px 30px;}
        .btn-submit:hover{background:linear-gradient(135deg, #229954, #1e8449); color:white;}
    </style>
</head>
<body>
    <!-- 考试头部信息 -->
    <div class="exam-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-3">
                    <h5 class="mb-0"><i class="bi bi-pencil-square me-2"></i><%=exam != null ? exam.getTitle() : "考试"%></h5>
                </div>
                <div class="col-md-3">
                    <div class="timer-display">
                        <i class="bi bi-clock me-2"></i>
                        <span id="examTimer">--:--:--</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="progress-info">
                        <div class="d-flex align-items-center">
                            <span class="me-3">题目进度</span>
                            <div class="progress flex-grow-1" style="height:8px;">
                                <div class="progress-bar" id="progressBar" role="progressbar" style="width: 0%; background:rgba(255,255,255,0.8)"></div>
                            </div>
                            <span class="ms-2"><span id="answeredCount">0</span>/<%=questions != null ? questions.size() : 0%></span>
                        </div>
                    </div>
                </div>
                <div class="col-md-2 text-end">
                    <button class="btn btn-light btn-sm" onclick="submitExam()">
                        <i class="bi bi-check-circle me-1"></i>提交试卷
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 考试主体 -->
    <div class="container mt-4">
        <form id="examForm" method="post" action="<%=request.getContextPath()%>/student/exam/submit">
            <input type="hidden" name="examId" value="<%=exam != null ? exam.getId() : ""%>">

            <% if (questions != null && !questions.isEmpty()) {
                for (int i = 0; i < questions.size(); i++) {
                    Question q = questions.get(i);
            %>
                <div class="question-card" data-question-id="<%=q.getId()%>">
                    <div class="d-flex align-items-start mb-3">
                        <div class="question-number me-3"><%=i+1%></div>
                        <div class="flex-grow-1">
                            <h6 class="mb-3"><%=q.getTitle()%></h6>

                            <% if ("essay".equals(q.getType())) { %>
                                <!-- 主观题 -->
                                <div class="mb-3">
                                    <textarea class="form-control" name="answer_<%=q.getId()%>" rows="4"
                                              placeholder="请输入您的答案..." onchange="markAnswered(<%=q.getId()%>)"></textarea>
                                </div>
                            <% } else { %>
                                <!-- 单选题/多选题 -->
                                <div class="mb-3">
                                    <% if (q.getOptions() != null && !q.getOptions().isEmpty()) {
                                        String[] options = q.getOptions().split("\n");
                                        for (int j = 0; j < options.length; j++) {
                                            String option = options[j].trim();
                                            if (!option.isEmpty()) {
                                    %>
                                        <div class="option-item" onclick="selectOption(this, <%=q.getId()%>, '<%=option.substring(0, 1)%>', '<%=q.getType()%>')">
                                            <div class="form-check">
                                                <input class="form-check-input" type="<%="multiple".equals(q.getType()) ? "checkbox" : "radio"%>"
                                                       name="<%="multiple".equals(q.getType()) ? "answer_" + q.getId() : "answer_" + q.getId()%>"
                                                       value="<%=option.substring(0, 1)%>" id="option_<%=q.getId()%>_<%=j%>"
                                                       onchange="markAnswered(<%=q.getId()%>)">
                                                <label class="form-check-label w-100" for="option_<%=q.getId()%>_<%=j%>">
                                                    <strong><%=option.substring(0, 1)%>.</strong> <%=option.substring(option.indexOf(')') + 1).trim()%>
                                                </label>
                                            </div>
                                        </div>
                                    <%
                                            }
                                        }
                                    } %>
                                </div>
                            <% } %>

                            <div class="text-muted small">
                                <i class="bi bi-info-circle me-1"></i>
                                题型：<%=q.getTypeText()%> | 难度：<%=q.getDifficultyText()%> | 科目：<%=q.getSubject()%>
                            </div>
                        </div>
                    </div>
                </div>
            <% }
            } else { %>
                <div class="text-center py-5">
                    <i class="bi bi-exclamation-triangle" style="font-size:3rem; color:#dc3545;"></i>
                    <h5 class="mt-3">暂无试题</h5>
                    <p class="text-muted">该考试还没有添加试题，请联系教师</p>
                </div>
            <% } %>
        </form>
    </div>

    <footer class="text-center py-4 mt-5 border-top">
        <p class="text-muted mb-0">在线考试系统 - 学生端</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let answeredQuestions = new Set();
        let totalQuestions = <%=questions != null ? questions.size() : 0%>;
        let remainingTime = <%=exam != null ? exam.getDuration() * 60 : 3600%>; // 转换为秒

        // 更新进度条
        function updateProgress() {
            const answered = answeredQuestions.size;
            const progress = (answered / totalQuestions) * 100;
            document.getElementById('progressBar').style.width = progress + '%';
            document.getElementById('answeredCount').textContent = answered;
        }

        // 标记题目已回答
        function markAnswered(questionId) {
            answeredQuestions.add(questionId);
            updateProgress();
        }

        // 选择选项
        function selectOption(element, questionId, value, type) {
            if (type === 'single') {
                // 单选题：取消其他选项
                const container = element.closest('.question-card');
                const checkboxes = container.querySelectorAll('.option-item');
                checkboxes.forEach(item => item.classList.remove('selected'));
                element.classList.add('selected');
            } else {
                // 多选题：切换选中状态
                element.classList.toggle('selected');
            }
            markAnswered(questionId);
        }

        // 倒计时
        function updateTimer() {
            if (remainingTime <= 0) {
                document.getElementById('examTimer').textContent = '00:00:00';
                alert('考试时间到！系统将自动提交试卷。');
                submitExam();
                return;
            }

            const hours = Math.floor(remainingTime / 3600);
            const minutes = Math.floor((remainingTime % 3600) / 60);
            const seconds = remainingTime % 60;

            const timeStr = String(hours).padStart(2, '0') + ':' +
                           String(minutes).padStart(2, '0') + ':' +
                           String(seconds).padStart(2, '0');

            document.getElementById('examTimer').textContent = timeStr;
            remainingTime--;
        }

        // 提交考试
        function submitExam() {
            if (answeredQuestions.size < totalQuestions) {
                if (!confirm('您还有题目未作答，确定要提交试卷吗？')) {
                    return;
                }
            }

            if (confirm('确定要提交试卷吗？提交后无法修改答案。')) {
                document.getElementById('examForm').submit();
            }
        }

        // 页面加载时启动计时器
        document.addEventListener('DOMContentLoaded', function() {
            updateProgress();
            setInterval(updateTimer, 1000);

            // 防止意外关闭页面
            window.addEventListener('beforeunload', function(e) {
                if (answeredQuestions.size > 0) {
                    e.preventDefault();
                    e.returnValue = '您有未提交的考试答案，确定要离开吗？';
                }
            });
        });
    </script>
</body>
</html>