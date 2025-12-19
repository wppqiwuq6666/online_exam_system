<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,com.exam.entity.Course" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    Integer courseCount = (Integer) request.getAttribute("courseCount");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    String selectedSemester = (String) request.getAttribute("selectedSemester");
    List<String> semesters = (List<String>) request.getAttribute("semesters");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>课程管理 - 在线考试系统</title>
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

        /* 页面标题横幅 */
        .page-banner {
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.15),
                        rgba(255, 255, 255, 0.05),
                        rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border-radius: 25px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15),
                        0 15px 35px rgba(102, 126, 234, 0.1),
                        inset 0 0 30px rgba(255, 255, 255, 0.1);
            padding: 40px 30px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
            animation: slideInDown 0.8s ease-out;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .page-content {
            position: relative;
            z-index: 2;
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
            margin-bottom: 25px;
        }

        /* 统计卡片 */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.15);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 10px;
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
        }

        /* 控制栏 */
        .control-bar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .filter-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .search-box {
            position: relative;
            flex: 1;
            min-width: 300px;
        }

        .search-box input {
            padding-left: 45px;
            border-radius: 25px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.1);
            color: white;
            transition: all 0.3s ease;
        }

        .search-box input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .search-box input:focus {
            border-color: rgba(102, 126, 234, 0.6);
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 20px rgba(102, 126, 234, 0.2);
            color: white;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
            z-index: 10;
        }

        .semester-select {
            min-width: 200px;
        }

        .semester-select select {
            padding: 12px 15px;
            border-radius: 25px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.1);
            color: white;
            backdrop-filter: blur(10px);
        }

        .semester-select select option {
            background: #2d3748;
            color: white;
        }

        .btn-add-course {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-add-course:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            color: white;
        }

        /* 课程卡片 */
        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .course-card {
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
            padding: 30px;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            animation: fadeInUp 0.8s ease-out forwards;
            opacity: 0;
        }

        .course-card:nth-child(1) { animation-delay: 0.1s; }
        .course-card:nth-child(2) { animation-delay: 0.2s; }
        .course-card:nth-child(3) { animation-delay: 0.3s; }
        .course-card:nth-child(4) { animation-delay: 0.4s; }
        .course-card:nth-child(5) { animation-delay: 0.5s; }
        .course-card:nth-child(6) { animation-delay: 0.6s; }

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

        .course-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg,
                        transparent,
                        rgba(255, 255, 255, 0.1),
                        transparent);
            transition: left 0.6s ease;
        }

        .course-card:hover::before {
            left: 100%;
        }

        .course-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.15),
                        0 15px 35px rgba(102, 126, 234, 0.2),
                        inset 0 0 30px rgba(255, 255, 255, 0.15);
            border-color: rgba(102, 126, 234, 0.4);
        }

        .course-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8));
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .course-card:hover .course-icon {
            transform: scale(1.1);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .course-name {
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .course-code {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
            margin-bottom: 8px;
            font-family: 'Courier New', monospace;
        }

        .course-info {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 5px;
            font-size: 0.95rem;
        }

        .course-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-right: 8px;
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        .semester-badge {
            background: rgba(40, 167, 69, 0.2);
            color: #d4edda;
            border: 1px solid rgba(40, 167, 69, 0.3);
        }

        .credit-badge {
            background: rgba(255, 193, 7, 0.2);
            color: #fff3cd;
            border: 1px solid rgba(255, 193, 7, 0.3);
        }

        .status-badge {
            background: rgba(40, 167, 69, 0.2);
            color: #d4edda;
            border: 1px solid rgba(40, 167, 69, 0.3);
        }

        .status-badge.inactive {
            background: rgba(220, 53, 69, 0.2);
            color: #f8d7da;
            border: 1px solid rgba(220, 53, 69, 0.3);
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-action {
            padding: 8px 15px;
            border-radius: 20px;
            border: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-delete {
            background: rgba(220, 53, 69, 0.2);
            color: #ff6b6b;
        }

        .btn-delete:hover {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            transform: translateY(-2px);
        }

        .btn-edit {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border-color: rgba(255, 193, 7, 0.3);
        }

        .btn-edit:hover {
            background: rgba(255, 193, 7, 0.8);
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
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: 20px;
        }

        /* 返回按钮 */
        .btn-back {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 25px;
            padding: 12px 25px;
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
            margin-bottom: 30px;
        }

        .btn-back:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            color: white;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }

            .course-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .stats-row {
                grid-template-columns: repeat(2, 1fr);
            }

            .filter-row {
                flex-direction: column;
            }

            .course-card {
                padding: 25px 20px;
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
        <!-- 返回按钮 -->
        <a href="${pageContext.request.contextPath}/admin/home.jsp" class="btn-back">
            <i class="bi bi-arrow-left me-2"></i>返回控制台
        </a>

        <!-- 页面标题横幅 -->
        <div class="page-banner">
            <div class="page-content">
                <h1 class="page-title">
                    <i class="bi bi-book-fill me-3"></i>课程管理
                </h1>
                <p class="page-subtitle">管理所有课程信息，包括课程创建、编辑和删除</p>
            </div>
        </div>

        <!-- 统计卡片 -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-number"><%=courseCount != null ? courseCount : 0%></div>
                <div class="stat-label">课程总数</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">100%</div>
                <div class="stat-label">管理覆盖率</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">24/7</div>
                <div class="stat-label">系统运行</div>
            </div>
        </div>

        <!-- 控制栏 -->
        <div class="control-bar">
            <div class="filter-row">
                <form method="get" action="${pageContext.request.contextPath}/admin/course/list" class="search-box">
                    <i class="bi bi-search"></i>
                    <input type="text" name="search" value="<%=searchKeyword != null ? searchKeyword : ""%>"
                           placeholder="搜索课程名称、代码或教师..." class="form-control">
                </form>

                <form method="get" action="${pageContext.request.contextPath}/admin/course/list" class="semester-select">
                    <select name="semester" class="form-control" onchange="this.form.submit()">
                        <option value="all">所有学期</option>
                        <% if (semesters != null) { %>
                            <% for (String semester : semesters) { %>
                                <option value="<%=semester%>" <%=semester.equals(selectedSemester) ? "selected" : ""%>><%=semester%></option>
                            <% } %>
                        <% } %>
                    </select>
                </form>
            </div>

            <div style="text-align: right;">
                <a href="${pageContext.request.contextPath}/admin/course/add" class="btn-add-course">
                    <i class="bi bi-plus-circle me-2"></i>添加课程
                </a>
            </div>
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

        <!-- 课程列表 -->
        <% if (courses == null || courses.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-book"></i>
                <h3>暂无课程</h3>
                <p>系统中还没有任何课程，点击上方按钮添加第一门课程</p>
            </div>
        <% } else { %>
            <div class="course-grid">
                <% for(Course c : courses) { %>
                    <div class="course-card">
                        <div class="course-icon">
                            <i class="bi bi-book-fill"></i>
                        </div>
                        <h3 class="course-name"><%=c.getCourseName()%></h3>
                        <div class="course-code">
                            <i class="bi bi-hash me-1"></i><%=c.getCourseCode()%>
                        </div>
                        <div class="course-info">
                            <i class="bi bi-person me-1"></i>授课教师：<%=c.getTeacherName() != null && !c.getTeacherName().isEmpty() ? c.getTeacherName() : "未分配"%>
                        </div>
                        <div class="course-info">
                            <i class="bi bi-123 me-1"></i>学分：<%=c.getCredit()%>
                        </div>
                        <div class="course-badges">
                            <span class="course-badge semester-badge">
                                <i class="bi bi-calendar3 me-1"></i><%=c.getSemester()%>
                            </span>
                            <span class="course-badge credit-badge">
                                <i class="bi bi-award me-1"></i><%=c.getCredit()%>学分
                            </span>
                            <span class="course-badge status-badge <%= "inactive".equals(c.getStatus()) ? "inactive" : "" %>">
                                <i class="bi bi-circle me-1"></i><%= "active".equals(c.getStatus()) ? "开课中" : "已停用" %>
                            </span>
                        </div>
                        <% if (c.getDescription() != null && !c.getDescription().isEmpty()) { %>
                            <div class="course-info" style="margin-top: 15px;">
                                <i class="bi bi-info-circle me-1"></i><%=c.getDescription()%>
                            </div>
                        <% } %>
                        <div class="action-buttons">
                            <a href="edit?id=<%=c.getId()%>" class="btn-action btn-edit">
                                <i class="bi bi-pencil"></i>编辑
                            </a>
                            <a href="delete?id=<%=c.getId()%>"
                               class="btn-action btn-delete"
                               onclick="return confirm('确定要删除课程 \"<%=c.getCourseName()%>\" 吗？')">
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

        // 搜索框自动提交
        document.querySelector('.search-box input').addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                this.form.submit();
            }
        });
    </script>
</body>
</html>