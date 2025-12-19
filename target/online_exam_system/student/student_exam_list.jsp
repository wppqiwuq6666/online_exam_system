<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%@ page import="com.exam.entity.Exam" %>
<%@ page import="java.util.List" %>
<%
    User u = (User) session.getAttribute("currentUser");
    if (u == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }
    if (!"student".equals(u.getRole())) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
    List<Exam> availableExams = (List<Exam>) request.getAttribute("availableExams");
    List<Exam> ongoingExams = (List<Exam>) request.getAttribute("ongoingExams");
    List<Exam> endedExams = (List<Exam>) request.getAttribute("endedExams");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>考试中心 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{background:#f8f6ff;}
        .header-section{background:linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%); color:white; padding:30px 0; margin-bottom:30px;}
        .exam-card{background:white; border-radius:10px; box-shadow:0 2px 10px rgba(155, 89, 182, 0.1); transition:transform 0.2s; margin-bottom:20px;}
        .exam-card:hover{transform:translateY(-3px); box-shadow:0 4px 15px rgba(155, 89, 182, 0.2);}
        .status-badge{font-size:0.8rem; padding:6px 12px; border-radius:20px;}
        .time-info{font-size:0.9rem; color:#666;}
        .duration-badge{background:linear-gradient(135deg, #9b59b6, #8e44ad); color:white; padding:4px 8px; border-radius:12px; font-size:0.8rem;}
        .empty-state{text-align:center; padding:60px 20px; color:#999;}
        .empty-state i{font-size:4rem; color:#ddd; margin-bottom:20px;}
        .section-title{color:#9b59b6; border-bottom:2px solid #9b59b6; padding-bottom:5px; margin-bottom:20px;}
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
                    <h2><i class="bi bi-pencil-square me-2"></i>考试中心</h2>
                    <p class="mb-0">参加在线考试，展示您的学习成果</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="<%=request.getContextPath()%>/student/home.jsp" class="btn btn-light">
                        <i class="bi bi-house me-1"></i>返回首页
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
                <% if ("submitted".equals(request.getParameter("success"))) { %>
                    考试提交成功！
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-1"></i>
                <%
                    String error = request.getParameter("error");
                    if ("not_available".equals(error)) out.print("该考试当前不可参加！");
                    else if ("no_questions".equals(error)) out.print("该考试暂无试题！");
                    else if ("invalid_id".equals(error)) out.print("无效的考试ID！");
                    else out.print("操作失败，请重试！");
                %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- 可参加的考试 -->
        <div class="row mb-4">
            <div class="col-12">
                <h5 class="section-title"><i class="bi bi-play-circle me-2"></i>可参加的考试</h5>
                <% if (availableExams != null && !availableExams.isEmpty()) { %>
                    <div class="row">
                        <% for (Exam exam : availableExams) { %>
                            <div class="col-md-6 col-lg-4">
                                <div class="exam-card p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h6 class="mb-0"><%=exam.getTitle()%></h6>
                                        <span class="status-badge bg-success">进行中</span>
                                    </div>

                                    <p class="text-muted small mb-3">
                                        <%=exam.getDescription() != null ? exam.getDescription() : "暂无描述"%>
                                    </p>

                                    <div class="row g-2 mb-3">
                                        <div class="col-6">
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-clock me-2 text-purple"></i>
                                                <small class="time-info">时长：<%=exam.getDuration()%>分钟</small>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="d-flex align-items-center">
                                                <i class="bi bi-trophy me-2 text-purple"></i>
                                                <small class="time-info">总分：<%=exam.getTotalScore()%>分</small>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="time-info mb-3">
                                        <i class="bi bi-calendar-event me-2 text-purple"></i>
                                        考试时间：<%=exam.getStartTime()%> - <%=exam.getEndTime()%>
                                    </div>

                                    <div class="d-grid">
                                        <a href="<%=request.getContextPath()%>/student/exam/take?id=<%=exam.getId()%>"
                                           class="btn btn-purple text-white">
                                            <i class="bi bi-play-fill me-1"></i>开始考试
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-state bg-white rounded">
                        <i class="bi bi-inbox"></i>
                        <h6>暂无可参加的考试</h6>
                        <p class="small">目前没有正在进行中的考试</p>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- 即将开始的考试 -->
        <% if (ongoingExams != null && !ongoingExams.isEmpty()) { %>
        <div class="row mb-4">
            <div class="col-12">
                <h5 class="section-title"><i class="bi bi-hourglass-split me-2"></i>即将开始的考试</h5>
                <div class="row">
                    <% for (Exam exam : ongoingExams) { %>
                        <div class="col-md-6 col-lg-4">
                            <div class="exam-card p-4 opacity-75">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h6 class="mb-0"><%=exam.getTitle()%></h6>
                                    <span class="status-badge bg-warning text-dark">未开始</span>
                                </div>

                                <p class="text-muted small mb-3">
                                    <%=exam.getDescription() != null ? exam.getDescription() : "暂无描述"%>
                                </p>

                                <div class="time-info mb-3">
                                    <i class="bi bi-calendar-event me-2 text-purple"></i>
                                    开考时间：<%=exam.getStartTime()%>
                                </div>

                                <div class="d-grid">
                                    <button class="btn btn-secondary" disabled>
                                        <i class="bi bi-clock me-1"></i>尚未开始
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>

        <!-- 已结束的考试 -->
        <% if (endedExams != null && !endedExams.isEmpty()) { %>
        <div class="row">
            <div class="col-12">
                <h5 class="section-title"><i class="bi bi-check-circle me-2"></i>已结束的考试</h5>
                <div class="row">
                    <% for (Exam exam : endedExams) { %>
                        <div class="col-md-6 col-lg-4">
                            <div class="exam-card p-4">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h6 class="mb-0"><%=exam.getTitle()%></h6>
                                    <span class="status-badge bg-secondary">已结束</span>
                                </div>

                                <p class="text-muted small mb-3">
                                    <%=exam.getDescription() != null ? exam.getDescription() : "暂无描述"%>
                                </p>

                                <div class="time-info mb-3">
                                    <i class="bi bi-calendar-check me-2 text-purple"></i>
                                    结束时间：<%=exam.getEndTime()%>
                                </div>

                                <div class="d-grid">
                                    <button class="btn btn-outline-secondary" disabled>
                                        <i class="bi bi-x-circle me-1"></i>已过期
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <footer class="text-center py-4 mt-5 border-top">
        <p class="text-muted mb-0">在线考试系统 - 学生端</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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
        .text-purple {
            color: #9b59b6 !important;
        }
    </style>
</body>
</html>