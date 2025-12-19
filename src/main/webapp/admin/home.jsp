<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%
    // 获取当前登录用户
    User u = (User) session.getAttribute("currentUser");

    // 检查用户是否已登录
    if (u == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    // 检查用户角色
    if (!"admin".equals(u.getRole())) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    // 获取显示名称，如果displayName为空则使用username
    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员控制台 - 在线考试系统</title>
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

        /* 欢迎横幅 */
        .welcome-banner {
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
            margin-bottom: 40px;
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

        .welcome-content {
            position: relative;
            z-index: 2;
            color: white;
        }

        .welcome-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .welcome-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 25px;
        }

        .user-info {
            display: inline-flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 12px 20px;
            border-radius: 50px;
            backdrop-filter: blur(10px);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            font-weight: 600;
        }

        /* 功能卡片网格 */
        .function-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        /* 玻璃功能卡片 */
        .glass-card {
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

        .glass-card:nth-child(1) { animation-delay: 0.1s; }
        .glass-card:nth-child(2) { animation-delay: 0.2s; }
        .glass-card:nth-child(3) { animation-delay: 0.3s; }
        .glass-card:nth-child(4) { animation-delay: 0.4s; }

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

        .glass-card::before {
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

        .glass-card:hover::before {
            left: 100%;
        }

        .glass-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.15),
                        0 15px 35px rgba(102, 126, 234, 0.2),
                        inset 0 0 30px rgba(255, 255, 255, 0.15);
            border-color: rgba(102, 126, 234, 0.4);
        }

        .card-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .glass-card:hover .card-icon {
            transform: scale(1.1);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .card-title {
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .card-description {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .card-action {
            display: inline-flex;
            align-items: center;
            background: linear-gradient(135deg,
                        rgba(102, 126, 234, 0.9),
                        rgba(118, 75, 162, 0.8));
            color: white;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 15px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .card-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            color: white;
            background: linear-gradient(135deg,
                        rgba(102, 126, 234, 1),
                        rgba(118, 75, 162, 0.9));
        }

        /* 统计卡片 */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
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

        /* 页脚 */
        footer {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border-top: 1px solid rgba(255, 255, 255, 0.2);
            color: rgba(255, 255, 255, 0.8);
            text-align: center;
            padding: 30px 20px;
            margin-top: 60px;
            border-radius: 20px 20px 0 0;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .welcome-title {
                font-size: 2rem;
            }

            .function-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .stats-row {
                grid-template-columns: repeat(2, 1fr);
            }

            .glass-card {
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
                <span class="navbar-text text-white me-3">
                    <i class="bi bi-person-circle me-1"></i>
                    <%=displayName%> (管理员)
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i>退出
                </a>
            </div>
        </div>
    </nav>

    <!-- 主容器 -->
    <div class="main-container">
        <!-- 欢迎横幅 -->
        <div class="welcome-banner">
            <div class="welcome-content">
                <div class="d-flex align-items-center mb-4">
                    <div class="user-avatar">
                        <%=displayName.charAt(0)%>
                    </div>
                    <div>
                        <h1 class="welcome-title">欢迎回来，<%=displayName%></h1>
                        <p class="welcome-subtitle">系统管理员 • 控制面板</p>
                    </div>
                </div>

                <div class="user-info">
                    <i class="bi bi-shield-check me-2"></i>
                    管理员身份已验证
                </div>
            </div>
        </div>

        <!-- 统计卡片 -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-number">4</div>
                <div class="stat-label">管理模块</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">24/7</div>
                <div class="stat-label">系统运行</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">100%</div>
                <div class="stat-label">安全性</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">∞</div>
                <div class="stat-label">扩展性</div>
            </div>
        </div>

        <!-- 功能卡片网格 -->
        <div class="function-grid">
            <!-- 用户管理 -->
            <div class="glass-card">
                <div class="card-icon">
                    <i class="bi bi-people-fill"></i>
                </div>
                <h3 class="card-title">用户管理</h3>
                <p class="card-description">
                    新增、编辑、删除教师与学生账户。管理用户权限和角色分配，确保系统安全运行。
                </p>
                <a href="${pageContext.request.contextPath}/admin/user/list" class="card-action">
                    <i class="bi bi-arrow-right-circle me-2"></i>
                    进入管理
                </a>
            </div>

            <!-- 班级管理 -->
            <div class="glass-card">
                <div class="card-icon">
                    <i class="bi bi-building"></i>
                </div>
                <h3 class="card-title">班级管理</h3>
                <p class="card-description">
                    创建和管理班级信息，分配班主任，管理学生名单，维护班级基本信息。
                </p>
                <a href="${pageContext.request.contextPath}/admin/class/list" class="card-action">
                    <i class="bi bi-arrow-right-circle me-2"></i>
                    进入管理
                </a>
            </div>

            <!-- 课程管理 -->
            <div class="glass-card">
                <div class="card-icon">
                    <i class="bi bi-book-fill"></i>
                </div>
                <h3 class="card-title">课程管理</h3>
                <p class="card-description">
                    管理课程设置，分配任课教师，安排课程表，制定教学计划和考核标准。
                </p>
                <a href="${pageContext.request.contextPath}/admin/course/list" class="card-action">
                    <i class="bi bi-arrow-right-circle me-2"></i>
                    进入管理
                </a>
            </div>

            <!-- 成绩查询 -->
            <div class="glass-card">
                <div class="card-icon">
                    <i class="bi bi-graph-up"></i>
                </div>
                <h3 class="card-title">成绩查询</h3>
                <p class="card-description">
                    按班级、课程或教师查询学生成绩，生成统计报表，导出成绩数据。
                </p>
                <a href="${pageContext.request.contextPath}/admin/score/list" class="card-action">
                    <i class="bi bi-arrow-right-circle me-2"></i>
                    进入查询
                </a>
            </div>
        </div>

        <!-- 页脚 -->
        <footer>
            <p class="mb-2">
                <i class="bi bi-c-circle me-1"></i>
                2024 在线考试系统 - 智能化教育管理平台
            </p>
            <p class="small mb-0">
                <i class="bi bi-code-slash me-1"></i>
                技术栈：Java Web + MySQL + Bootstrap
            </p>
        </footer>
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
    </script>
</body>
</html>