<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%@ page import="com.exam.entity.Question" %>
<%@ page import="java.util.List" %>
<%
    User u = (User) session.getAttribute("currentUser");
    if (u == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }
    if (!"teacher".equals(u.getRole())) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    List<String> subjects = (List<String>) request.getAttribute("subjects");
    String keyword = (String) request.getAttribute("keyword");
    String selectedType = (String) request.getAttribute("selectedType");
    String selectedSubject = (String) request.getAttribute("selectedSubject");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>题库管理 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{background:#f7fbf8;}
        .header-section{background:linear-gradient(135deg, #667eea 0%, #764ba2 100%); color:white; padding:30px 0; margin-bottom:30px;}
        .search-section{background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); margin-bottom:20px;}
        .question-card{background:white; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.08); transition:transform 0.2s; margin-bottom:15px;}
        .question-card:hover{transform:translateY(-2px); box-shadow:0 4px 12px rgba(0,0,0,0.15);}
        .difficulty-badge{font-size:0.8rem; padding:4px 8px;}
        .type-badge{font-size:0.8rem; padding:4px 8px;}
        .actions{white-space:nowrap;}
        .empty-state{text-align:center; padding:60px 20px; color:#666;}
        .empty-state i{font-size:4rem; color:#ddd; margin-bottom:20px;}
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
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2><i class="bi bi-journal-text me-2"></i>题库管理</h2>
                    <p class="mb-0">管理您的试题库，添加、编辑或删除试题</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="<%=request.getContextPath()%>/teacher/question/add" class="btn btn-light">
                        <i class="bi bi-plus-circle me-1"></i>添加试题
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- 成功/错误提示 -->
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-1"></i>
                <%
                    String success = request.getParameter("success");
                    if ("added".equals(success)) out.print("试题添加成功！");
                    else if ("updated".equals(success)) out.print("试题更新成功！");
                    else if ("deleted".equals(success)) out.print("试题删除成功！");
                %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-1"></i>
                <%
                    String error = request.getParameter("error");
                    if ("unauthorized".equals(error)) out.print("您没有权限删除此试题！");
                    else if ("delete_failed".equals(error)) out.print("删除失败，请重试！");
                    else if ("invalid_id".equals(error)) out.print("无效的试题ID！");
                    else out.print("操作失败，请重试！");
                %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- 搜索筛选 -->
        <div class="search-section">
            <form method="get" action="<%=request.getContextPath()%>/teacher/question/list">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">关键词</label>
                        <input type="text" class="form-control" name="keyword" value="<%=keyword != null ? keyword : ""%>" placeholder="搜索题干或解析">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">题型</label>
                        <select class="form-select" name="type">
                            <option value="all" <%=("all".equals(selectedType)) ? "selected" : ""%>>全部</option>
                            <option value="single" <%=("single".equals(selectedType)) ? "selected" : ""%>>单选题</option>
                            <option value="multiple" <%=("multiple".equals(selectedType)) ? "selected" : ""%>>多选题</option>
                            <option value="essay" <%=("essay".equals(selectedType)) ? "selected" : ""%>>主观题</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">科目</label>
                        <select class="form-select" name="subject">
                            <option value="all">全部</option>
                            <% if (subjects != null) {
                                for (String sub : subjects) { %>
                                    <option value="<%=sub%>" <%=sub.equals(selectedSubject) ? "selected" : ""%>><%=sub%></option>
                                <% }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search me-1"></i>搜索
                            </button>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-grid">
                            <a href="<%=request.getContextPath()%>/teacher/question/list" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-clockwise me-1"></i>重置
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- 试题列表 -->
        <% if (questions != null && !questions.isEmpty()) { %>
            <div class="row">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5>共找到 <%=questions.size()%> 道试题</h5>
                        <div>
                            <button class="btn btn-outline-primary btn-sm" onclick="exportQuestions()">
                                <i class="bi bi-download me-1"></i>导出
                            </button>
                        </div>
                    </div>

                    <% for (Question q : questions) { %>
                        <div class="question-card p-4">
                            <div class="row align-items-start">
                                <div class="col-md-8">
                                    <div class="mb-2">
                                        <span class="badge bg-primary type-badge me-2"><%=q.getTypeText()%></span>
                                        <span class="badge <%=
                                            q.getDifficulty() == 1 ? "bg-success" :
                                            q.getDifficulty() == 2 ? "bg-warning" : "bg-danger"
                                        %> difficulty-badge me-2"><%=q.getDifficultyText()%></span>
                                        <span class="badge bg-info text-dark"><%=q.getSubject()%></span>
                                    </div>
                                    <h6 class="mb-2"><%=q.getTitle()%></h6>
                                    <% if (q.getOptions() != null && !q.getOptions().isEmpty()) { %>
                                        <p class="text-muted mb-2"><small>选项：<%=q.getOptions()%></small></p>
                                    <% } %>
                                    <p class="text-muted mb-1"><small>正确答案：<%=q.getAnswer()%></small></p>
                                    <% if (q.getAnalysis() != null && !q.getAnalysis().isEmpty()) { %>
                                        <p class="text-muted mb-2"><small>解析：<%=q.getAnalysis()%></small></p>
                                    <% } %>
                                    <p class="text-muted mb-0"><small><i class="bi bi-clock me-1"></i><%=q.getCreateTime()%></small></p>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <div class="actions">
                                        <a href="<%=request.getContextPath()%>/teacher/question/edit?id=<%=q.getId()%>" class="btn btn-outline-primary btn-sm me-2">
                                            <i class="bi bi-pencil me-1"></i>编辑
                                        </a>
                                        <a href="<%=request.getContextPath()%>/teacher/question/delete?id=<%=q.getId()%>" class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('确定要删除这道试题吗？')">
                                            <i class="bi bi-trash me-1"></i>删除
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="bi bi-inbox"></i>
                <h5>暂无试题</h5>
                <p>您还没有添加任何试题，点击上方按钮开始添加吧！</p>
                <a href="<%=request.getContextPath()%>/teacher/question/add" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i>添加第一道试题
                </a>
            </div>
        <% } %>
    </div>

    <footer class="text-center py-4 mt-5 border-top">
        <p class="text-muted mb-0">在线考试系统 - 教师端</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function exportQuestions() {
            alert('导出功能开发中...');
        }
    </script>
</body>
</html>