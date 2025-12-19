<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.exam.entity.Score" %>
<%
    // 获取数据
    List<Score> scores = (List<Score>) request.getAttribute("scores");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    String selectedCourse = (String) request.getAttribute("selectedCourse");
    List<String> courses = (List<String>) request.getAttribute("courses");
    Integer scoreCount = (Integer) request.getAttribute("scoreCount");
    String passRate = (String) request.getAttribute("passRate");
    String averageScore = (String) request.getAttribute("averageScore");
    String maxScore = (String) request.getAttribute("maxScore");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>成绩管理 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg,
                        rgba(102, 126, 234, 0.7),
                        rgba(118, 75, 162, 0.6),
                        rgba(0, 0, 0, 0.3)),
                        url('${pageContext.request.contextPath}/images/glass_background.jpg') center/cover;
            background-attachment: fixed;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* 动态背景元素 */
        .bg-animation {
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            z-index: 1;
            pointer-events: none;
        }

        .floating-shape {
            position: absolute;
            border-radius: 50%;
            background: linear-gradient(45deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            backdrop-filter: blur(5px);
            animation: float 20s ease-in-out infinite;
        }

        .shape1 {
            width: 200px;
            height: 200px;
            top: 10%;
            left: 10%;
            animation-delay: 0s;
        }

        .shape2 {
            width: 150px;
            height: 150px;
            top: 70%;
            right: 10%;
            animation-delay: 7s;
        }

        .shape3 {
            width: 100px;
            height: 100px;
            bottom: 20%;
            left: 20%;
            animation-delay: 14s;
        }

        @keyframes float {
            0%, 100% {
                transform: translate(0, 0) rotate(0deg);
                opacity: 0.3;
            }
            25% {
                transform: translate(30px, -30px) rotate(90deg);
                opacity: 0.5;
            }
            50% {
                transform: translate(-20px, 20px) rotate(180deg);
                opacity: 0.3;
            }
            75% {
                transform: translate(20px, 30px) rotate(270deg);
                opacity: 0.5;
            }
        }

        /* 导航栏 */
        .navbar-custom {
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* 主容器 */
        .main-container {
            position: relative;
            z-index: 10;
            padding: 100px 20px 30px 20px;
            min-height: 100vh;
        }

        /* 页面标题 */
        .page-header {
            text-align: center;
            margin-bottom: 40px;
            color: white;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .page-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* 统计卡片 */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.15),
                        rgba(255, 255, 255, 0.05),
                        rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1),
                        0 10px 25px rgba(102, 126, 234, 0.1),
                        inset 0 0 20px rgba(255, 255, 255, 0.1);
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
            animation: fadeInUp 0.8s ease-out;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15),
                        0 15px 35px rgba(102, 126, 234, 0.2);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: white;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: white;
            margin-bottom: 10px;
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
        }

        /* 搜索和筛选容器 */
        .search-container {
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.15),
                        rgba(255, 255, 255, 0.05),
                        rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 25px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1),
                        0 15px 35px rgba(102, 126, 234, 0.1),
                        inset 0 0 20px rgba(255, 255, 255, 0.1);
            padding: 30px;
            margin-bottom: 40px;
            animation: slideInDown 0.8s ease-out;
        }

        .search-title {
            color: white;
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 20px;
            text-align: center;
        }

        .search-form {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        .form-control-custom {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 15px;
            color: white;
            padding: 12px 15px;
            font-size: 16px;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .form-control-custom::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-control-custom:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(102, 126, 234, 0.6);
            box-shadow: 0 0 20px rgba(102, 126, 234, 0.2);
        }

        select.form-control-custom {
            appearance: none;
            cursor: pointer;
        }

        select.form-control-custom option {
            background: #2d3748;
            color: white;
        }

        .btn-search {
            background: linear-gradient(135deg,
                        rgba(102, 126, 234, 0.9),
                        rgba(118, 75, 162, 0.8));
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            color: white;
            padding: 12px 30px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            height: fit-content;
            backdrop-filter: blur(10px);
        }

        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            color: white;
        }

        /* 成绩卡片 */
        .score-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .score-card {
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.15),
                        rgba(255, 255, 255, 0.05),
                        rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1),
                        0 10px 25px rgba(102, 126, 234, 0.1),
                        inset 0 0 20px rgba(255, 255, 255, 0.1);
            padding: 25px;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            animation: fadeInUp 0.8s ease-out;
        }

        .score-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15),
                        0 15px 35px rgba(102, 126, 234, 0.2);
        }

        .score-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .score-icon {
            width: 50px;
            height: 50px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8));
        }

        .score-status {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-passed {
            background: rgba(40, 167, 69, 0.3);
            color: #d4edda;
            border: 1px solid rgba(40, 167, 69, 0.4);
        }

        .status-failed {
            background: rgba(220, 53, 69, 0.3);
            color: #f8d7da;
            border: 1px solid rgba(220, 53, 69, 0.4);
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.3);
            color: #fff3cd;
            border: 1px solid rgba(255, 193, 7, 0.4);
        }

        .score-title {
            color: white;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .score-info {
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        .score-info i {
            margin-right: 8px;
            color: rgba(255, 255, 255, 0.7);
        }

        .score-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .score-value {
            font-size: 1.8rem;
            font-weight: 700;
            color: white;
        }

        .score-percentage {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
        }

        .score-grade {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8));
            color: white;
            padding: 8px 15px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-action {
            padding: 8px 16px;
            border-radius: 12px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-delete {
            background: rgba(220, 53, 69, 0.2);
            color: #ff6b6b;
            border-color: rgba(220, 53, 69, 0.3);
        }

        .btn-delete:hover {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            transform: translateY(-2px);
        }

        /* 消息提示 */
        .alert-message {
            padding: 15px 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideInDown 0.5s ease-out;
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.2);
            color: #d4edda;
            border-color: rgba(40, 167, 69, 0.3);
        }

        .alert-error {
            background: rgba(220, 53, 69, 0.2);
            color: #f8d7da;
            border-color: rgba(220, 53, 69, 0.3);
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: rgba(255, 255, 255, 0.8);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: rgba(255, 255, 255, 0.5);
        }

        .empty-state h3 {
            font-size: 1.8rem;
            margin-bottom: 15px;
            color: white;
        }

        .empty-state p {
            font-size: 1.1rem;
            opacity: 0.8;
        }

        /* 动画 */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }

            .stats-container {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .search-form {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .score-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .main-container {
                padding: 80px 15px 30px 15px;
            }

            .shape1, .shape2, .shape3 {
                display: none;
            }
        }
    </style>
</head>
<body>
    <!-- 动态背景 -->
    <div class="bg-animation">
        <div class="floating-shape shape1"></div>
        <div class="floating-shape shape2"></div>
        <div class="floating-shape shape3"></div>
    </div>

    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/admin/home.jsp">
                <i class="bi bi-mortarboard-fill me-2"></i>在线考试系统
            </a>
            <div class="navbar-nav ms-auto">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i>退出
                </a>
            </div>
        </div>
    </nav>

    <!-- 主容器 -->
    <div class="main-container">
        <!-- 页面标题 -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="bi bi-graph-up me-3"></i>成绩管理
            </h1>
            <p class="page-subtitle">查看和管理所有学生的考试成绩统计</p>
        </div>

        <!-- 统计卡片 -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div class="stat-number"><%=scoreCount != null ? scoreCount : 0%></div>
                <div class="stat-label">总成绩记录</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="bi bi-percent"></i>
                </div>
                <div class="stat-number"><%=passRate != null ? passRate : "0"%>%</div>
                <div class="stat-label">及格率</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="bi bi-calculator"></i>
                </div>
                <div class="stat-number"><%=averageScore != null ? averageScore : "0"%></div>
                <div class="stat-label">平均分</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="bi bi-trophy-fill"></i>
                </div>
                <div class="stat-number"><%=maxScore != null ? maxScore : "0"%></div>
                <div class="stat-label">最高分</div>
            </div>
        </div>

        <!-- 搜索和筛选 -->
        <div class="search-container">
            <h3 class="search-title">
                <i class="bi bi-search me-2"></i>搜索与筛选
            </h3>
            <form action="${pageContext.request.contextPath}/admin/score/list" method="get" class="search-form">
                <div class="form-group">
                    <label class="form-label">关键词搜索</label>
                    <input type="text"
                           name="search"
                           class="form-control-custom"
                           placeholder="学生姓名、课程名称、考试名称"
                           value="<%=searchKeyword != null ? searchKeyword : ""%>">
                </div>
                <div class="form-group">
                    <label class="form-label">课程筛选</label>
                    <select name="course" class="form-control-custom">
                        <option value="all">所有课程</option>
                        <% if (courses != null) {
                               for (String course : courses) { %>
                        <option value="<%=course%>" <%=course.equals(selectedCourse) ? "selected" : ""%>><%=course%></option>
                        <%   }
                           } %>
                    </select>
                </div>
                <button type="submit" class="btn-search">
                    <i class="bi bi-search me-2"></i>搜索
                </button>
            </form>
        </div>

        <!-- 消息提示 -->
        <% if (message != null) { %>
            <div class="alert-message alert-success">
                <i class="bi bi-check-circle me-2"></i><%=message%>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert-message alert-error">
                <i class="bi bi-exclamation-triangle me-2"></i><%=error%>
            </div>
        <% } %>

        <!-- 成绩列表 -->
        <% if (scores == null || scores.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-graph-down"></i>
                <h3>暂无成绩记录</h3>
                <p>系统中还没有任何成绩记录</p>
            </div>
        <% } else { %>
            <div class="score-grid">
                <%
                    for(Score s : scores) {
                        // 处理状态样式
                        String statusClass = "status-pending";
                        String statusText = "待审核";
                        if (s.getStatus() != null) {
                            if ("passed".equals(s.getStatus())) {
                                statusClass = "status-passed";
                                statusText = "及格";
                            } else if ("failed".equals(s.getStatus())) {
                                statusClass = "status-failed";
                                statusText = "不及格";
                            }
                        }

                        // 处理考试标题
                        String examTitle = s.getExamTitle() != null ? s.getExamTitle() : "考试";

                        // 处理学生姓名
                        String studentName = s.getStudentName() != null ? s.getStudentName() : "未知学生";

                        // 处理课程名称
                        String courseName = s.getCourseName() != null ? s.getCourseName() : "未知课程";

                        // 处理考试时间
                        String examDateStr = "";
                        if (s.getExamTime() != null) {
                            examDateStr = s.getExamTime().toString().substring(0, 10);
                        }

                        // 处理百分比
                        double percentage = s.getPercentage();
                        String percentageStr = String.format("%.1f", percentage);
                %>
                    <div class="score-card">
                        <div class="score-header">
                            <div class="score-icon">
                                <i class="bi bi-person-badge"></i>
                            </div>
                            <span class="score-status <%=statusClass%>">
                                <%=statusText%>
                            </span>
                        </div>
                        <h3 class="score-title"><%=examTitle%></h3>
                        <div class="score-info">
                            <i class="bi bi-person"></i><%=studentName%>
                        </div>
                        <div class="score-info">
                            <i class="bi bi-book"></i><%=courseName%>
                        </div>
                        <% if (!examDateStr.isEmpty()) { %>
                        <div class="score-info">
                            <i class="bi bi-calendar"></i><%=examDateStr%>
                        </div>
                        <% } %>
                        <div class="score-details">
                            <div>
                                <div class="score-value"><%=s.getScore()%>/<%=s.getMaxScore()%></div>
                                <div class="score-percentage">(<%=percentageStr%>%)</div>
                            </div>
                            <div class="score-grade"><%=s.getGrade()%></div>
                        </div>
                        <div class="action-buttons">
                            <a href="delete?id=<%=s.getId()%>"
                               class="btn-action btn-delete"
                               onclick="return confirm('确定要删除这条成绩记录吗？')">
                                <i class="bi bi-trash"></i>删除
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 页面加载动画
        document.addEventListener('DOMContentLoaded', function() {
            document.body.style.opacity = '1';
        });

        // 动态背景鼠标跟随效果
        document.addEventListener('mousemove', function(e) {
            const shapes = document.querySelectorAll('.floating-shape');
            const x = e.clientX / window.innerWidth;
            const y = e.clientY / window.innerHeight;

            shapes.forEach((shape, index) => {
                const speed = (index + 1) * 15;
                shape.style.transform = `translate(${x * speed}px, ${y * speed}px)`;
            });
        });

        // 搜索框焦点效果
        document.querySelectorAll('.form-control-custom').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });

            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>