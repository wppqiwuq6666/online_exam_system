<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%@ page import="com.exam.entity.Exam" %>
<%
    User u = (User) session.getAttribute("currentUser");
    if (u == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }
    if (!"student".equals(u.getRole())) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
    Exam exam = (Exam) request.getAttribute("exam");
    Integer questionCount = (Integer) request.getAttribute("questionCount");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>考试完成 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{background:#f8f6ff;}
        .header-section{background:linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%); color:white; padding:40px 0; margin-bottom:30px;}
        .success-card{background:white; border-radius:15px; box-shadow:0 4px 20px rgba(155, 89, 182, 0.15); padding:40px; text-align:center; max-width:600px; margin:0 auto;}
        .success-icon{width:100px; height:100px; background:linear-gradient(135deg, #27ae60, #229954); border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 30px; color:white; font-size:3rem;}
        .info-item{display:flex; justify-content:space-between; align-items:center; padding:15px 0; border-bottom:1px solid #eee;}
        .info-item:last-child{border-bottom:none;}
        .info-label{font-weight:500; color:#495057;}
        .info-value{color:#212529; font-weight:600;}
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
                <div class="col-12 text-center">
                    <h2><i class="bi bi-check-circle me-2"></i>考试完成</h2>
                    <p class="mb-0">恭喜您完成了本次考试！</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="success-card">
            <div class="success-icon">
                <i class="bi bi-check-lg"></i>
            </div>

            <h4 class="mb-4">考试提交成功！</h4>
            <p class="text-muted mb-4">
                您的试卷已成功提交，系统将自动进行评分。考试成绩将在教师审核后公布。
            </p>

            <div class="bg-light rounded p-4 mb-4">
                <h6 class="mb-3"><i class="bi bi-info-circle me-2"></i>考试信息</h6>
                <% if (exam != null) { %>
                    <div class="info-item">
                        <span class="info-label">考试名称</span>
                        <span class="info-value"><%=exam.getTitle()%></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">考试时间</span>
                        <span class="info-value"><%=exam.getDuration()%> 分钟</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">总分</span>
                        <span class="info-value"><%=exam.getTotalScore()%> 分</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">及格分数</span>
                        <span class="info-value"><%=exam.getPassScore()%> 分</span>
                    </div>
                <% } %>
                <div class="info-item">
                    <span class="info-label">答题数量</span>
                    <span class="info-value"><%=questionCount != null ? questionCount : 0%> 题</span>
                </div>
                <div class="info-item">
                    <span class="info-label">提交时间</span>
                    <span class="info-value"><%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date())%></span>
                </div>
            </div>

            <div class="alert alert-info">
                <i class="bi bi-lightbulb me-2"></i>
                <strong>温馨提示：</strong>
                <ul class="mb-0 mt-2 text-start">
                    <li>请及时关注成绩公布信息</li>
                    <li>如有疑问，请联系任课教师</li>
                    <li>您可以查看历次考试成绩记录</li>
                </ul>
            </div>

            <div class="d-flex justify-content-center gap-3">
                <a href="<%=request.getContextPath()%>/student/exam/list" class="btn btn-purple text-white">
                    <i class="bi bi-arrow-left me-1"></i>返回考试列表
                </a>
                <a href="<%=request.getContextPath()%>/student/home.jsp" class="btn btn-outline-purple">
                    <i class="bi bi-house me-1"></i>返回首页
                </a>
            </div>
        </div>
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
        .btn-outline-purple {
            background: transparent;
            border: 2px solid #9b59b6;
            color: #9b59b6;
        }
        .btn-outline-purple:hover {
            background: #9b59b6;
            color: white;
        }
    </style>
</body>
</html>