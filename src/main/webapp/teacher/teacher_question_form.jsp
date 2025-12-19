<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%@ page import="com.exam.entity.Question" %>
<%
    User u = (User) session.getAttribute("currentUser");
    if (u == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }
    if (!"teacher".equals(u.getRole())) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
    Question question = (Question) request.getAttribute("question");
    Boolean isEdit = (Boolean) request.getAttribute("isEdit");
    String error = (String) request.getAttribute("error");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=isEdit != null && isEdit ? "编辑试题" : "添加试题"%> - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{background:#f7fbf8;}
        .header-section{background:linear-gradient(135deg, #667eea 0%, #764ba2 100%); color:white; padding:30px 0; margin-bottom:30px;}
        .form-section{background:white; padding:30px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1);}
        .form-label{font-weight:500; color:#333;}
        .required{color:#dc3545;}
    </style>
</head>
<body>
    <!-- 头部导航 -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background:#4a5568;">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/teacher/home.jsp">
                <i class="bi bi-mortarboard-fill me-2"></i>在线考试系统
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text text-white me-3">
                    <i class="bi bi-person-circle me-1"></i><%=displayName%> (教师)
                </span>
                <a href="<%=request.getContextPath()%>/logout" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i>退出
                </a>
            </div>
        </div>
    </nav>

    <!-- 页面标题 -->
    <div class="header-section">
        <div class="container">
            <h2><i class="bi bi-journal-text me-2"></i><%=isEdit != null && isEdit ? "编辑试题" : "添加试题"%></h2>
            <p class="mb-0"><%=isEdit != null && isEdit ? "修改试题信息" : "创建新的试题"%></p>
        </div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-section">
                    <!-- 错误提示 -->
                    <% if (error != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-circle me-1"></i><%=error%>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>

                    <form method="post" action="<%=request.getContextPath()%>/teacher/question/<%=isEdit != null && isEdit ? "edit" : "add"%>" id="questionForm">
                        <input type="hidden" name="isEdit" value="<%=isEdit != null && isEdit ? "true" : "false"%>">
                        <% if (isEdit != null && isEdit && question != null) { %>
                            <input type="hidden" name="id" value="<%=question.getId()%>">
                        <% } %>

                        <!-- 题型 -->
                        <div class="mb-3">
                            <label class="form-label">题型 <span class="required">*</span></label>
                            <select class="form-select" name="type" id="questionType" onchange="toggleOptions()" required>
                                <option value="">请选择题型</option>
                                <option value="single" <%=question != null && "single".equals(question.getType()) ? "selected" : ""%>>单选题</option>
                                <option value="multiple" <%=question != null && "multiple".equals(question.getType()) ? "selected" : ""%>>多选题</option>
                                <option value="essay" <%=question != null && "essay".equals(question.getType()) ? "selected" : ""%>>主观题</option>
                            </select>
                        </div>

                        <!-- 题干 -->
                        <div class="mb-3">
                            <label class="form-label">题干 <span class="required">*</span></label>
                            <textarea class="form-control" name="title" id="title" rows="4" required
                                      placeholder="请输入试题题干..."><%=question != null ? question.getTitle() : ""%></textarea>
                            <div class="form-text">支持HTML格式</div>
                        </div>

                        <!-- 选项（单选/多选题） -->
                        <div class="mb-3" id="optionsSection">
                            <label class="form-label">选项 <span class="required">*</span></label>
                            <textarea class="form-control" name="options" id="options" rows="4"
                                      placeholder="请输入选项，每行一个选项，如：&#10;A. 选项1&#10;B. 选项2&#10;C. 选项3&#10;D. 选项4"><%=question != null ? question.getOptions() : ""%></textarea>
                            <div class="form-text">每行一个选项，单选题请以A、B、C、D开头，多选题同理</div>
                        </div>

                        <!-- 正确答案 -->
                        <div class="mb-3">
                            <label class="form-label">正确答案 <span class="required">*</span></label>
                            <input type="text" class="form-control" name="answer" id="answer" required
                                   value="<%=question != null ? question.getAnswer() : ""%>"
                                   placeholder="单选题输入如：A，多选题输入如：AB，主观题输入具体答案">
                            <div class="form-text">
                                单选题填写字母（如：A），多选题填写多个字母（如：AB），主观题填写具体答案
                            </div>
                        </div>

                        <!-- 答案解析 -->
                        <div class="mb-3">
                            <label class="form-label">答案解析</label>
                            <textarea class="form-control" name="analysis" id="analysis" rows="3"
                                      placeholder="请输入答案解析（选填）..."><%=question != null && question.getAnalysis() != null ? question.getAnalysis() : ""%></textarea>
                        </div>

                        <!-- 难度 -->
                        <div class="mb-3">
                            <label class="form-label">难度 <span class="required">*</span></label>
                            <select class="form-select" name="difficulty" required>
                                <option value="">请选择难度</option>
                                <option value="1" <%=question != null && question.getDifficulty() == 1 ? "selected" : ""%>>简单</option>
                                <option value="2" <%=question != null && question.getDifficulty() == 2 ? "selected" : ""%>>中等</option>
                                <option value="3" <%=question != null && question.getDifficulty() == 3 ? "selected" : ""%>>困难</option>
                            </select>
                        </div>

                        <!-- 科目 -->
                        <div class="mb-4">
                            <label class="form-label">科目 <span class="required">*</span></label>
                            <input type="text" class="form-control" name="subject" required
                                   value="<%=question != null ? question.getSubject() : ""%>"
                                   placeholder="如：数学、语文、英语等">
                        </div>

                        <!-- 按钮组 -->
                        <div class="d-flex justify-content-between">
                            <a href="<%=request.getContextPath()%>/teacher/question/list" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i>返回列表
                            </a>
                            <div>
                                <button type="reset" class="btn btn-outline-danger me-2">
                                    <i class="bi bi-arrow-clockwise me-1"></i>重置
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle me-1"></i><%=isEdit != null && isEdit ? "更新试题" : "保存试题"%>
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <footer class="text-center py-4 mt-5 border-top">
        <p class="text-muted mb-0">在线考试系统 - 教师端</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleOptions() {
            var type = document.getElementById('questionType').value;
            var optionsSection = document.getElementById('optionsSection');
            var answerInput = document.getElementById('answer');

            if (type === 'essay') {
                optionsSection.style.display = 'none';
                answerInput.placeholder = '请输入主观题的具体答案要点';
            } else {
                optionsSection.style.display = 'block';
                if (type === 'single') {
                    answerInput.placeholder = '单选题填写字母（如：A）';
                } else if (type === 'multiple') {
                    answerInput.placeholder = '多选题填写多个字母（如：AB或ABC）';
                }
            }
        }

        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            toggleOptions();
        });
    </script>
</body>
</html>