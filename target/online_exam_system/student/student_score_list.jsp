<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%@ page import="com.exam.entity.Score" %>
<%@ page import="java.util.List" %>
<%
    User u = (User) session.getAttribute("currentUser");
    if (u == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }
    if (!"student".equals(u.getRole())) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
    List<Score> scores = (List<Score>) request.getAttribute("scores");

    // 统计数据
    Integer totalExams = (Integer) request.getAttribute("totalExams");
    Integer passedExams = (Integer) request.getAttribute("passedExams");
    String averageScore = (String) request.getAttribute("averageScore");
    String highestScore = (String) request.getAttribute("highestScore");
    String lowestScore = (String) request.getAttribute("lowestScore");
    String passRate = (String) request.getAttribute("passRate");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>我的成绩 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{background:#f8f6ff;}
        .header-section{background:linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%); color:white; padding:30px 0; margin-bottom:30px;}
        .stats-section{background:white; padding:25px; border-radius:10px; box-shadow:0 2px 10px rgba(155, 89, 182, 0.1); margin-bottom:20px;}
        .score-card{background:white; border-radius:8px; box-shadow:0 2px 8px rgba(155, 89, 182, 0.08); transition:transform 0.2s; margin-bottom:15px;}
        .score-card:hover{transform:translateY(-2px); box-shadow:0 4px 12px rgba(155, 89, 182, 0.15);}
        .grade-badge{font-size:0.8rem; padding:4px 8px; font-weight:bold;}
        .status-badge{font-size:0.8rem; padding:4px 8px;}
        .score-number{font-size:1.2rem; font-weight:bold;}
        .percentage{font-size:0.9rem; color:#666;}
        .stats-card{text-align:center; padding:20px; border-radius:8px; background:linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border:1px solid #dee2e6;}
        .stats-number{font-size:2rem; font-weight:bold; color:#9b59b6; margin-bottom:5px;}
        .stats-label{font-size:0.9rem; color:#6c757d;}
        .empty-state{text-align:center; padding:60px 20px; color:#666;}
        .empty-state i{font-size:4rem; color:#ddd; margin-bottom:20px;}
        .table-responsive{border-radius:8px; box-shadow:0 2px 8px rgba(155, 89, 182, 0.08); background:white;}
        .table thead{background:linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%); color:white;}
        .progress-info{background:#f8f9fa; padding:15px; border-radius:8px; margin-bottom:20px;}
        .progress-bar-purple{background:linear-gradient(135deg, #9b59b6, #8e44ad);}
    </style>
</head>
<body>
    <!-- 头部导航 -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background:#4a5568;">
        <div class="container">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/student/home.jsp">
                <i class="bi bi-mortarboard-fill me-2"></i>在线考试系统
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text text-white me-3">
                    <i class="bi bi-person-circle me-1"></i><%=displayName%> (学生)
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
                    <h2><i class="bi bi-award me-2"></i>我的成绩</h2>
                    <p class="mb-0">查看您的考试成绩，了解学习进度</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <button class="btn btn-light" onclick="exportScores()">
                        <i class="bi bi-download me-1"></i>导出成绩单
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
                <div class="col-md-2 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=totalExams != null ? totalExams : 0%></div>
                        <div class="stats-label">总考试数</div>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=passRate != null ? passRate : "0"%>%</div>
                        <div class="stats-label">及格率</div>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=averageScore != null ? averageScore : "0"%></div>
                        <div class="stats-label">平均分</div>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=highestScore != null ? highestScore : "0"%></div>
                        <div class="stats-label">最高分</div>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=lowestScore != null ? lowestScore : "0"%></div>
                        <div class="stats-label">最低分</div>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-number"><%=passedExams != null ? passedExams : 0%></div>
                        <div class="stats-label">及格数</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 学习进度 -->
        <% if (totalExams != null && totalExams > 0) { %>
        <div class="progress-info">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="fw-bold">学习进度</span>
                <span class="text-muted">已参加 <%=totalExams%> 次考试，其中 <%=passedExams%> 次及格</span>
            </div>
            <div class="progress" style="height:12px;">
                <div class="progress-bar progress-bar-purple" role="progressbar"
                     style="width: <%=passRate%>%" aria-valuenow="<%=passRate%>"
                     aria-valuemin="0" aria-valuemax="100">
                    <%=passRate%>%
                </div>
            </div>
        </div>
        <% } %>

        <!-- 成绩列表 -->
        <% if (scores != null && !scores.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>考试名称</th>
                            <th>科目</th>
                            <th>得分</th>
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
                                        <div class="rounded-circle bg-purple text-white d-flex align-items-center justify-content-center me-3" style="width:40px;height:40px;font-size:16px;">
                                            <%=score.getExamTitle() != null && score.getExamTitle().length() > 0 ? score.getExamTitle().charAt(0) : "E"%>
                                        </div>
                                        <div>
                                            <div class="fw-bold"><%=score.getExamTitle() != null ? score.getExamTitle() : "期末考试"%></div>
                                            <small class="text-muted">满分: <%=String.format("%.1f", score.getMaxScore())%>分</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-purple text-white">
                                        <%=score.getCourseName() != null ? score.getCourseName() : "未知科目"%>
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="score-number text-purple">
                                            <%=String.format("%.1f", score.getScore())%>
                                        </div>
                                        <div class="ms-2">
                                            <small class="percentage">(<%=String.format("%.1f", score.getPercentage())%>%)</small>
                                        </div>
                                    </div>
                                    <div class="progress mt-1" style="height:4px;">
                                        <div class="progress-bar <%=
                                            score.getPercentage() >= 80 ? "bg-success" :
                                            score.getPercentage() >= 60 ? "bg-warning" : "bg-danger"%>"
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
                                        <button class="btn btn-outline-purple" onclick="viewScoreDetail(<%=score.getId()%>)">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-outline-purple" onclick="printScore(<%=score.getId()%>)">
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
            <div class="empty-state bg-white rounded">
                <i class="bi bi-inbox"></i>
                <h5>暂无成绩记录</h5>
                <p>您还没有参加过任何考试</p>
                <a href="<%=request.getContextPath()%>/student/exam/list" class="btn btn-purple text-white">
                    <i class="bi bi-pencil-square me-1"></i>去参加考试
                </a>
            </div>
        <% } %>
    </div>

    <footer class="text-center py-4 mt-5 border-top">
        <p class="text-muted mb-0">在线考试系统 - 学生端</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function exportScores() {
            alert('成绩单导出功能开发中...');
        }

        function viewScoreDetail(scoreId) {
            alert('查看详情功能开发中... Score ID: ' + scoreId);
        }

        function printScore(scoreId) {
            alert('打印功能开发中... Score ID: ' + scoreId);
        }
    </script>
    <style>
        .btn-purple {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
            border: none;
            color: white;
        }
        .btn-purple:hover {
            background: linear-gradient(135deg, #8e44ad, #7d3c98);
            color: white;
        }
        .btn-outline-purple {
            background: transparent;
            border: 1px solid #9b59b6;
            color: #9b59b6;
        }
        .btn-outline-purple:hover {
            background: #9b59b6;
            color: white;
        }
        .bg-purple {
            background: linear-gradient(135deg, #9b59b6, #8e44ad) !important;
        }
        .text-purple {
            color: #9b59b6 !important;
        }
    </style>
</body>
</html>