<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>在线考试系统 - 登录</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg,
                        rgba(102, 126, 234, 0.7),
                        rgba(118, 75, 162, 0.6),
                        rgba(0, 0, 0, 0.3)),
                        url('${pageContext.request.contextPath}/images/glass_background.jpg') center/cover;
            background-attachment: fixed;
            position: relative;
            overflow: hidden;
        }

        /* 动态背景元素 */
        .bg-animation {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            z-index: 1;
        }

        .floating-shape {
            position: absolute;
            border-radius: 50%;
            background: linear-gradient(45deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            backdrop-filter: blur(5px);
            animation: float 15s ease-in-out infinite;
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
            animation-delay: 5s;
        }

        .shape3 {
            width: 100px;
            height: 100px;
            bottom: 20%;
            left: 20%;
            animation-delay: 10s;
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

        /* 玻璃拟态登录容器 */
        .login-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 500px;
            margin: 20px;
        }

        .glass-login-box {
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.15),
                        rgba(255, 255, 255, 0.05),
                        rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 35px 60px rgba(0, 0, 0, 0.2),
                        0 15px 35px rgba(102, 126, 234, 0.1),
                        inset 0 0 30px rgba(255, 255, 255, 0.1),
                        inset 0 0 60px rgba(255, 255, 255, 0.05);
            padding: 60px 50px;
            position: relative;
            overflow: hidden;
            animation: slideInUp 0.8s ease-out, shimmer-border 3s ease-in-out infinite;
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

        .glass-login-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
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

        @keyframes shimmer-border {
            0%, 100% {
                border-color: rgba(255, 255, 255, 0.3);
                box-shadow: 0 35px 60px rgba(0, 0, 0, 0.2),
                           0 15px 35px rgba(102, 126, 234, 0.1),
                           inset 0 0 30px rgba(255, 255, 255, 0.1),
                           inset 0 0 60px rgba(255, 255, 255, 0.05);
            }
            50% {
                border-color: rgba(255, 255, 255, 0.5);
                box-shadow: 0 35px 60px rgba(0, 0, 0, 0.2),
                           0 15px 35px rgba(102, 126, 234, 0.2),
                           inset 0 0 40px rgba(255, 255, 255, 0.15),
                           inset 0 0 80px rgba(255, 255, 255, 0.08);
            }
        }

        /* Logo区域 */
        .logo-section {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
        }

        .logo-icon {
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

        .system-title {
            color: white;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .system-subtitle {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1rem;
            font-weight: 300;
        }

        /* 表单样式 */
        .form-floating-custom {
            position: relative;
            margin-bottom: 25px;
        }

        .form-input {
            width: 100%;
            padding: 20px 20px 20px 55px;
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

        /* 选择框样式 */
        .custom-select {
            appearance: none;
            width: 100%;
            padding: 18px 20px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .custom-select option {
            background: #2d3748;
            color: white;
        }

        .custom-select:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(102, 126, 234, 0.5);
            box-shadow: 0 0 20px rgba(102, 126, 234, 0.2);
        }

        /* 登录按钮 */
        .login-btn {
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
            margin-top: 35px;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3),
                        inset 0 2px 10px rgba(255, 255, 255, 0.1);
        }

        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }

        .login-btn:hover::before {
            left: 100%;
        }

        .login-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4),
                        0 8px 25px rgba(118, 75, 162, 0.3),
                        inset 0 2px 15px rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        /* 错误信息样式 */
        .error-message {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 10px;
            color: #ff6b6b;
            padding: 12px 20px;
            margin-top: 20px;
            text-align: center;
            backdrop-filter: blur(10px);
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        /* 角色选择卡片 */
        .role-cards {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .role-card {
            flex: 1;
            padding: 18px 15px;
            background: linear-gradient(135deg,
                        rgba(255, 255, 255, 0.08),
                        rgba(255, 255, 255, 0.03));
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            text-align: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            backdrop-filter: blur(12px);
            position: relative;
            overflow: hidden;
        }

        .role-card::before {
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

        .role-card:hover::before {
            left: 100%;
        }

        .role-card:hover,
        .role-card.active {
            background: linear-gradient(135deg,
                        rgba(102, 126, 234, 0.25),
                        rgba(118, 75, 162, 0.2));
            border-color: rgba(102, 126, 234, 0.6);
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2),
                        inset 0 0 20px rgba(255, 255, 255, 0.1);
        }

        .role-icon {
            font-size: 2rem;
            margin-bottom: 8px;
            display: block;
        }

        .role-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
        }

        /* 额外的视觉增强 */
        .glass-reflection {
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg,
                        transparent 30%,
                        rgba(255, 255, 255, 0.1) 50%,
                        transparent 70%);
            animation: rotate 10s linear infinite;
            pointer-events: none;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* 粒子背景效果 */
        .particles {
            position: absolute;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 1;
        }

        .particle {
            position: absolute;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 50%;
            animation: float-particle 15s infinite ease-in-out;
        }

        @keyframes float-particle {
            0%, 100% {
                transform: translateY(100vh) translateX(0) scale(0);
                opacity: 0;
            }
            10% {
                transform: translateY(90vh) translateX(10px) scale(1);
                opacity: 0.4;
            }
            90% {
                transform: translateY(-10vh) translateX(-10px) scale(1);
                opacity: 0.4;
            }
            100% {
                transform: translateY(-20vh) translateX(0) scale(0);
                opacity: 0;
            }
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .glass-login-box {
                padding: 40px 30px;
                margin: 20px;
                border-radius: 25px;
            }

            .system-title {
                font-size: 1.8rem;
            }

            .system-subtitle {
                font-size: 0.9rem;
            }

            .role-cards {
                flex-direction: column;
                gap: 12px;
            }

            .shape1, .shape2, .shape3 {
                display: none;
            }

            .form-input {
                padding: 18px 20px 18px 50px;
                font-size: 15px;
            }

            .login-btn {
                padding: 18px;
                font-size: 17px;
            }

            .glass-reflection {
                display: none;
            }
        }

        /* 装饰性元素 */
        .decoration-dots {
            position: absolute;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.1) 0%, transparent 70%);
            animation: float-dots 10s ease-in-out infinite;
        }

        .dots1 {
            top: 10%;
            right: 10%;
        }

        .dots2 {
            bottom: 15%;
            left: 5%;
        }

        @keyframes float-dots {
            0%, 100% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(20px, -20px) scale(1.1); }
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

    <!-- 粒子效果 -->
    <div class="particles" id="particles"></div>

    <!-- 装饰元素 -->
    <div class="decoration-dots dots1"></div>
    <div class="decoration-dots dots2"></div>

    <!-- 登录容器 -->
    <div class="login-container">
        <div class="glass-login-box">
            <!-- 玻璃反射效果 -->
            <div class="glass-reflection"></div>
            <!-- Logo和标题 -->
            <div class="logo-section">
                <div class="logo-icon">
                    <i class="bi bi-mortarboard-fill"></i>
                </div>
                <h1 class="system-title">在线考试系统</h1>
                <p class="system-subtitle">智能化教育管理平台</p>
            </div>

            <!-- 登录表单 -->
            <form action="login" method="post" id="loginForm">
                <!-- 用户名输入 -->
                <div class="form-floating-custom">
                    <input type="text"
                           id="username"
                           name="username"
                           class="form-input"
                           placeholder="请输入用户名"
                           required>
                    <i class="bi bi-person input-icon"></i>
                </div>

                <!-- 密码输入 -->
                <div class="form-floating-custom">
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-input"
                           placeholder="请输入密码"
                           required>
                    <i class="bi bi-lock input-icon"></i>
                </div>

                <!-- 角色选择 -->
                <div class="form-floating-custom">
                    <select id="role" name="role" class="custom-select" required>
                        <option value="">请选择角色</option>
                        <option value="admin">管理员</option>
                        <option value="teacher">教师</option>
                        <option value="student">学生</option>
                    </select>
                </div>

                <!-- 角色选择卡片（可视化选择） -->
                <div class="role-cards">
                    <div class="role-card" onclick="selectRole('admin')">
                        <i class="bi bi-shield-fill-check role-icon"></i>
                        <span class="role-label">管理员</span>
                    </div>
                    <div class="role-card" onclick="selectRole('teacher')">
                        <i class="bi bi-mortarboard-fill role-icon"></i>
                        <span class="role-label">教师</span>
                    </div>
                    <div class="role-card" onclick="selectRole('student')">
                        <i class="bi bi-book-fill role-icon"></i>
                        <span class="role-label">学生</span>
                    </div>
                </div>

                <!-- 登录按钮 -->
                <button type="submit" class="login-btn">
                    <i class="bi bi-box-arrow-in-right me-2"></i>安全登录
                </button>

                <!-- 错误信息显示 -->
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <div class="error-message">
                    <i class="bi bi-exclamation-triangle me-2"></i><%=error%>
                </div>
                <% } %>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 角色选择功能
        function selectRole(role) {
            document.getElementById('role').value = role;

            // 更新卡片样式
            document.querySelectorAll('.role-card').forEach(card => {
                card.classList.remove('active');
            });
            event.currentTarget.classList.add('active');
        }

        // 输入框焦点效果
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.querySelector('.input-icon').style.color = '#667eea';
            });

            input.addEventListener('blur', function() {
                this.parentElement.querySelector('.input-icon').style.color = 'rgba(255, 255, 255, 0.7)';
            });
        });

        // 表单提交动画
        document.getElementById('loginForm').addEventListener('submit', function() {
            const btn = document.querySelector('.login-btn');
            const originalContent = btn.innerHTML;
            btn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>正在登录...';
            btn.disabled = true;

            // 3秒后恢复按钮状态（防止表单提交失败时按钮永久禁用）
            setTimeout(() => {
                btn.innerHTML = originalContent;
                btn.disabled = false;
            }, 3000);
        });

        // 监听选择框变化，同步更新角色卡片
        document.getElementById('role').addEventListener('change', function() {
            const selectedRole = this.value;
            document.querySelectorAll('.role-card').forEach(card => {
                card.classList.remove('active');
            });

            if (selectedRole) {
                const roleCards = document.querySelectorAll('.role-card');
                const roleIndex = selectedRole === 'admin' ? 0 : selectedRole === 'teacher' ? 1 : 2;
                if (roleCards[roleIndex]) {
                    roleCards[roleIndex].classList.add('active');
                }
            }
        });

        // 页面加载动画
        window.addEventListener('load', function() {
            document.querySelector('.glass-login-box').style.opacity = '1';
        });

        // 生成粒子效果
        function createParticles() {
            const particlesContainer = document.getElementById('particles');
            const particleCount = 30;

            for (let i = 0; i < particleCount; i++) {
                const particle = document.createElement('div');
                particle.className = 'particle';

                // 随机大小
                const size = Math.random() * 4 + 1;
                particle.style.width = size + 'px';
                particle.style.height = size + 'px';

                // 随机位置
                particle.style.left = Math.random() * 100 + '%';
                particle.style.top = Math.random() * 100 + '%';

                // 随机动画延迟
                particle.style.animationDelay = Math.random() * 15 + 's';
                particle.style.animationDuration = (Math.random() * 10 + 15) + 's';

                particlesContainer.appendChild(particle);
            }
        }

        // 动态背景鼠标跟随效果
        document.addEventListener('mousemove', function(e) {
            const shapes = document.querySelectorAll('.floating-shape');
            const x = e.clientX / window.innerWidth;
            const y = e.clientY / window.innerHeight;

            shapes.forEach((shape, index) => {
                const speed = (index + 1) * 20;
                shape.style.transform = `translate(${x * speed}px, ${y * speed}px)`;
            });
        });

        // 页面加载时生成粒子
        createParticles();
    </script>
</body>
</html>
