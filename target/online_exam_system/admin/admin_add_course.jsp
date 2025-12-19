<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>添加课程 - 在线考试系统</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* 表单容器 */
        .form-container {
            width: 100%;
            max-width: 600px;
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.15),
                        rgba(255, 255, 255, 0.05),
                        rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 35px 60px rgba(0, 0, 0, 0.15),
                        0 15px 35px rgba(102, 126, 234, 0.1),
                        inset 0 0 30px rgba(255, 255, 255, 0.1);
            padding: 50px 40px;
            position: relative;
            overflow: hidden;
            animation: slideInUp 0.8s ease-out;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg,
                        transparent,
                        rgba(255, 255, 255, 0.5),
                        transparent);
            animation: shimmer 3s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { opacity: 0; }
            50% { opacity: 1; }
        }

        /* 表单标题 */
        .form-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
            z-index: 2;
        }

        .form-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2rem;
            color: white;
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .form-title {
            color: white;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .form-subtitle {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1rem;
        }

        /* 表单样式 */
        .form-floating-custom {
            position: relative;
            margin-bottom: 25px;
        }

        .form-input {
            width: 100%;
            padding: 18px 20px 18px 55px;
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.1),
                        rgba(255, 255, 255, 0.05));
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 18px;
            color: white;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            backdrop-filter: blur(15px);
            box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.1),
                        0 4px 15px rgba(102, 126, 234, 0.05);
        }

        .form-input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-input:focus {
            outline: none;
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.15),
                        rgba(255, 255, 255, 0.08));
            border-color: rgba(102, 126, 234, 0.6);
            box-shadow: inset 0 2px 10px rgba(0, 0, 0, 0.15),
                        0 8px 25px rgba(102, 126, 234, 0.25),
                        0 0 30px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .input-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.2rem;
            z-index: 5;
            transition: all 0.3s ease;
        }

        .form-input:focus + .input-icon {
            color: rgba(102, 126, 234, 1);
        }

        textarea.form-input {
            resize: vertical;
            min-height: 100px;
            padding-top: 18px;
            padding-left: 20px;
        }

        select.form-input {
            appearance: none;
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.1),
                        rgba(255, 255, 255, 0.05));
            color: white;
            cursor: pointer;
        }

        select.form-input option {
            background: #2d3748;
            color: white;
        }

        /* 提交按钮 */
        .btn-submit {
            width: 100%;
            padding: 20px;
            background: linear-gradient(135deg,
                        rgba(102, 126, 234, 0.9),
                        rgba(118, 75, 162, 0.8),
                        rgba(102, 126, 234, 0.7));
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            color: white;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            margin-top: 30px;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3),
                        inset 0 2px 10px rgba(255, 255, 255, 0.1);
        }

        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg,
                        transparent,
                        rgba(255, 255, 255, 0.2),
                        transparent);
            transition: left 0.5s ease;
        }

        .btn-submit:hover::before {
            left: 100%;
        }

        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4),
                        0 8px 25px rgba(118, 75, 162, 0.3),
                        inset 0 2px 15px rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
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
            .form-container {
                padding: 40px 30px;
                margin: 20px;
            }

            .form-title {
                font-size: 1.8rem;
            }

            .form-subtitle {
                font-size: 0.9rem;
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
        <a href="${pageContext.request.contextPath}/admin/course/list" class="btn-back">
            <i class="bi bi-arrow-left me-2"></i>返回课程列表
        </a>

        <!-- 表单容器 -->
        <div class="form-container">
            <!-- 表单标题 -->
            <div class="form-header">
                <div class="form-icon">
                    <i class="bi bi-plus-circle"></i>
                </div>
                <h1 class="form-title">添加新课程</h1>
                <p class="form-subtitle">填写课程基本信息，创建新的课程档案</p>
            </div>

            <!-- 添加课程表单 -->
            <form action="${pageContext.request.contextPath}/admin/course/add" method="post">
                <!-- 课程名称 -->
                <div class="form-floating-custom">
                    <input type="text"
                           name="courseName"
                           class="form-input"
                           placeholder="请输入课程名称"
                           required />
                    <i class="bi bi-book input-icon"></i>
                </div>

                <!-- 课程代码 -->
                <div class="form-floating-custom">
                    <input type="text"
                           name="courseCode"
                           class="form-input"
                           placeholder="请输入课程代码（如：CS101）"
                           required />
                    <i class="bi bi-hash input-icon"></i>
                </div>

                <!-- 授课教师 -->
                <div class="form-floating-custom">
                    <input type="text"
                           name="teacherName"
                           class="form-input"
                           placeholder="请输入授课教师姓名" />
                    <i class="bi bi-person input-icon"></i>
                </div>

                <!-- 学分 -->
                <div class="form-floating-custom">
                    <input type="number"
                           name="credit"
                           class="form-input"
                           placeholder="请输入学分"
                           min="1"
                           max="10"
                           value="3" />
                    <i class="bi bi-123 input-icon"></i>
                </div>

                <!-- 学期 -->
                <div class="form-floating-custom">
                    <select name="semester" class="form-input" required>
                        <option value="">请选择学期</option>
                        <option value="2024年春季学期">2024年春季学期</option>
                        <option value="2024年秋季学期">2024年秋季学期</option>
                        <option value="2025年春季学期">2025年春季学期</option>
                        <option value="2025年秋季学期">2025年秋季学期</option>
                    </select>
                    <i class="bi bi-calendar3 input-icon"></i>
                </div>

                <!-- 课程状态 -->
                <div class="form-floating-custom">
                    <select name="status" class="form-input">
                        <option value="active">开课中</option>
                        <option value="inactive">已停用</option>
                    </select>
                    <i class="bi bi-circle input-icon"></i>
                </div>

                <!-- 课程描述 -->
                <div class="form-floating-custom">
                    <textarea name="description"
                              class="form-input"
                              placeholder="请输入课程描述（可选）"></textarea>
                    <i class="bi bi-info-circle input-icon"></i>
                </div>

                <!-- 提交按钮 -->
                <button type="submit" class="btn-submit">
                    <i class="bi bi-check-circle me-2"></i>创建课程
                </button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 页面加载动画
        document.addEventListener('DOMContentLoaded', function() {
            document.body.style.opacity = '1';
        });

        // 输入框焦点效果
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function() {
                const icon = this.parentElement.querySelector('.input-icon');
                if (icon) {
                    icon.style.color = '#667eea';
                }
            });

            input.addEventListener('blur', function() {
                const icon = this.parentElement.querySelector('.input-icon');
                if (icon) {
                    icon.style.color = 'rgba(255, 255, 255, 0.7)';
                }
            });
        });

        // 表单提交动画
        document.querySelector('form').addEventListener('submit', function() {
            const btn = document.querySelector('.btn-submit');
            const originalContent = btn.innerHTML;
            btn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>正在创建...';
            btn.disabled = true;

            // 3秒后恢复按钮状态（防止表单提交失败时按钮永久禁用）
            setTimeout(() => {
                btn.innerHTML = originalContent;
                btn.disabled = false;
            }, 3000);
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