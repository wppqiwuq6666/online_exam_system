<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%@ page import="com.exam.entity.Score" %>
<%@ page import="java.util.List" %>
<%
    User u = (User) session.getAttribute("currentUser");
    if (u == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }
    if (!"teacher".equals(u.getRole())) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
    List<Score> scores = (List<Score>) request.getAttribute("scores");
    List<String> courses = (List<String>) request.getAttribute("courses");
    String keyword = (String) request.getAttribute("keyword");
    String selectedCourse = (String) request.getAttribute("selectedCourse");
    String selectedStatus = (String) request.getAttribute("selectedStatus");

    // 统计数据
    Integer totalScores = (Integer) request.getAttribute("totalScores");
    String passRate = (String) request.getAttribute("passRate");
    String averageScore = (String) request.getAttribute("averageScore");
    String maxScore = (String) request.getAttribute("maxScore");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>成绩查看 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{background:#f7fbf8;}
        .header-section{background:linear-gradient(135deg, #667eea 0%, #764ba2 100%); color:white; padding:30px 0; margin-bottom:30px;}
        .search-section{background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); margin-bottom:20px;}
        .stats-section{background:white; padding:25px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); margin-bottom:20px;}
        .score-card{background:white; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.08); transition:transform 0.2s; margin-bottom:15px;}
        .score-card:hover{transform:translateY(-2px); box-shadow:0 4px 12px rgba(0,0,0,0.15);}
        .grade-badge{font-size:0.8rem; padding:4px 8px; font-weight:bold;}
        .status-badge{font-size:0.8rem; padding:4px 8px;}
        .score-number{font-size:1.2rem; font-weight:bold;}
        .percentage{font-size:0.9rem; color:#666;}
        .stats-card{text-align:center; padding:20px; border-radius:8px; background:linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border:1px solid #dee2e6;}
        .stats-number{font-size:2rem; font-weight:bold; color:#495057; margin-bottom:5px;}
        .stats-label{font-size:0.9rem; color:#6c757d;}
        .empty-state{text-align:center; padding:60px 20px; color:#666;}
        .empty-state i{font-size:4rem; color:#ddd; margin-bottom:20px;}
        .table-responsive{border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.08); background:white;}
        .table thead{background:linear-gradient(135deg, #667eea 0%, #764ba2 100%); color:white;}
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
                    <h2><i class="bi bi-graph-up me-2"></i>成绩查看</h2>
                    <p class="mb-0">查看学生的考试成绩，进行统计分析</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <button class="btn btn-light" onclick="exportScores()">
                        <i class="bi bi-download me-1"></i>导出报表
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- 统计概览 -->
        <div class="stats-section">
            <h5 class="mb-4"><i class="bi bi-bar-chart me-2"></i>成绩统计概览</h5>
            <div class="row">
                <div class="col-md-3 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=totalScores != null ? totalScores : 0%></div>
                        <div class="stats-label">总成绩数</div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=passRate != null ? passRate : "0"%>%</div>
                        <div class="stats-label">及格率</div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=averageScore != null ? averageScore : "0"%></div>
                        <div class="stats-label">平均分</div>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=maxScore != null ? maxScore : "0"%></div>
                        <div class="stats-label">最高分</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 搜索筛选 -->
        <div class="search-section">
            <form method="get" action="<%=request.getContextPath()%>/teacher/score/list">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">关键词</label>
                        <input type="text" class="form-control" name="keyword" value="<%=keyword != null ? keyword : ""%>" placeholder="搜索学生姓名、课程名称">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">课程</label>
                        <select class="form-select" name="course">
                            <option value="">全部课程</option>
                            <% if (courses != null) {
                                for (String c : courses) { %>
                                    <option value="<%=c%>" <%=c.equals(selectedCourse) ? "selected" : ""%>><%=c%></option>
                                <% }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">状态</label>
                        <select class="form-select" name="status">
                            <option value="">全部状态</option>
                            <option value="passed" <%=("passed".equals(selectedStatus)) ? "selected" : ""%>>及格</option>
                            <option value="failed" <%=("failed".equals(selectedStatus)) ? "selected" : ""%>>不及格</option>
                            <option value="pending" <%=("pending".equals(selectedStatus)) ? "selected" : ""%>>待定</option>
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
                            <a href="<%=request.getContextPath()%>/teacher/score/list" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-clockwise me-1"></i>重置
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- 成绩列表 -->
        <% if (scores != null && !scores.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>学生姓名</th>
                            <th>课程名称</th>
                            <th>考试名称</th>
                            <th>分数</th>
                            <th>等级</th>
                            <th>状态</th>
                            <th>考试时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Score score : scores) { %>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-2" style="width:32px;height:32px;font-size:14px;">
                                            <%=score.getStudentName() != null ? score.getStudentName().charAt(0) : "S"%>
                                        </div>
                                        <%=score.getStudentName() != null ? score.getStudentName() : "未知学生"%>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-info text-dark">
                                        <%=score.getCourseName() != null ? score.getCourseName() : "未知课程"%>
                                    </span>
                                </td>
                                <td>
                                    <small class="text-muted">
                                        <%=score.getExamTitle() != null ? score.getExamTitle() : "期末考试"%>
                                    </small>
                                </td>
                                <td>
                                    <div class="score-number text-primary">
                                        <%=String.format("%.1f", score.getScore())%>
                                        <span class="percentage">/ <%=String.format("%.1f", score.getMaxScore())%></span>
                                    </div>
                                    <div class="progress mt-1" style="height:4px;">
                                        <div class="progress-bar <%=score.getPercentage() >= 80 ? "bg-success" : score.getPercentage() >= 60 ? "bg-warning" : "bg-danger"%>"
                                             style="width:<%=score.getPercentage()%>%"></div>
                                    </div>
                                </td>
                                <td>
                                    <span class="grade-badge badge <%=
                                        "A".equals(score.getGrade()) ? "bg-success" :
                                        "B".equals(score.getGrade()) ? "bg-info" :
                                        "C".equals(score.getGrade()) ? "bg-primary" :
                                        "D".equals(score.getGrade()) ? "bg-warning" : "bg-danger"
                                    %>">
                                        <%=score.getGrade()%>
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge badge <%=
                                        score.isPassed() ? "bg-success" : "bg-danger"
                                    %>">
                                        <%=score.isPassed() ? "及格" : "不及格"%>
                                    </span>
                                </td>
                                <td>
                                    <small class="text-muted">
                                        <%=score.getExamTime() != null ?
                                            new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(score.getExamTime()) :
                                            "未知时间"%>
                                    </small>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <button class="btn btn-outline-primary" onclick="viewScoreDetail(<%=score.getId()%>)">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-outline-info" onclick="printScore(<%=score.getId()%>)">
                                            <i class="bi bi-printer"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <div class="empty-state">
                <i class="bi bi-inbox"></i>
                <h5>暂无成绩数据</h5>
                <p>目前还没有学生的考试成绩记录</p>
            </div>
        <% } %>
    </div>

    <footer class="text-center py-4 mt-5 border-top">
        <p class="text-muted mb-0">在线考试系统 - 教师端</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function exportScores() {
            alert('导出功能开发中...');
        }

        function viewScoreDetail(scoreId) {
            alert('查看详情功能开发中... Score ID: ' + scoreId);
        }

        function printScore(scoreId) {
            alert('打印功能开发中... Score ID: ' + scoreId);
        }
    </script>
</body>
</html>