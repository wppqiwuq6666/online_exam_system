<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
    <title>添加用户 - 在线考试系统</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container-wrapper {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 0;
            overflow: hidden;
            display: flex;
            min-height: 600px;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .left-panel {
            flex: 1;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(120deg); }
            66% { transform: translate(-20px, 20px) rotate(240deg); }
        }

        .right-panel {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .header-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .header-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            color: #2d3748;
        }

        .header-section p {
            color: #718096;
            font-size: 1.1rem;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin: 20px 0;
        }

        .feature-list li {
            padding: 10px 0;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
        }

        .feature-list i {
            margin-right: 15px;
            font-size: 1.2rem;
        }

        .form-floating {
            margin-bottom: 20px;
        }

        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-cancel {
            background: #e2e8f0;
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            color: #4a5568;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 10px;
        }

        .btn-cancel:hover {
            background: #cbd5e0;
        }

        .avatar-icon {
            width: 120px;
            height: 120px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            font-size: 3rem;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .role-icons {
            display: flex;
            justify-content: space-around;
            margin: 30px 0;
        }

        .role-icon {
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 15px;
            border-radius: 15px;
        }

        .role-icon:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-5px);
        }

        .role-icon i {
            font-size: 2.5rem;
            margin-bottom: 10px;
            display: block;
        }

        .stats-container {
            display: flex;
            justify-content: space-around;
            margin: 30px 0;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        @media (max-width: 768px) {
            .form-container {
                flex-direction: column;
                margin: 20px;
            }

            .left-panel {
                padding: 30px 20px;
            }

            .right-panel {
                padding: 30px 20px;
            }

            .header-section h1 {
                font-size: 2rem;
            }
        }

        .input-icon {
            position: relative;
        }

        .input-icon i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            z-index: 10;
        }

        .input-icon .form-control {
            padding-left: 45px;
        }
    </style>
</head>
<body>
    <div class="container-wrapper">
        <div class="form-container">
            <!-- 左侧面板 -->
            <div class="left-panel">
                <div class="avatar-icon">
                    <i class="bi bi-person-plus-fill"></i>
                </div>

                <h2 class="text-center mb-4">添加新用户</h2>
                <p class="text-center mb-4">扩展您的团队，让更多人参与到在线考试系统中</p>

                <div class="stats-container">
                    <div class="stat-item">
                        <span class="stat-number">3</span>
                        <span class="stat-label">用户角色</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">100+</span>
                        <span class="stat-label">系统功能</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">24/7</span>
                        <span class="stat-label">系统可用</span>
                    </div>
                </div>

                <ul class="feature-list">
                    <li><i class="bi bi-shield-check"></i> 安全可靠的用户管理</li>
                    <li><i class="bi bi-people-fill"></i> 支持多种用户角色</li>
                    <li><i class="bi bi-speedometer2"></i> 高效的系统性能</li>
                    <li><i class="bi bi-graph-up"></i> 实时数据统计</li>
                </ul>
            </div>

            <!-- 右侧面板 -->
            <div class="right-panel">
                <div class="header-section">
                    <h1>创建新账户</h1>
                    <p>填写以下信息来创建新的用户账户</p>
                </div>

                <form action="${pageContext.request.contextPath}/admin/user/add" method="post">
                    <div class="input-icon mb-3">
                        <i class="bi bi-person"></i>
                        <input type="text" name="username" class="form-control" placeholder="用户名" required />
                    </div>

                    <div class="input-icon mb-3">
                        <i class="bi bi-lock"></i>
                        <input type="password" name="password" class="form-control" placeholder="密码" required />
                    </div>

                    <div class="form-floating mb-4">
                        <select name="role" class="form-control" id="roleSelect" required>
                            <option value="">请选择角色</option>
                            <option value="admin">管理员</option>
                            <option value="teacher">教师</option>
                            <option value="student">学生</option>
                        </select>
                        <label for="roleSelect">用户角色</label>
                    </div>

                    <div class="role-icons">
                        <div class="role-icon" onclick="document.getElementById('roleSelect').value='admin'">
                            <i class="bi bi-shield-fill-check text-info"></i>
                            <small>管理员</small>
                        </div>
                        <div class="role-icon" onclick="document.getElementById('roleSelect').value='teacher'">
                            <i class="bi bi-mortarboard-fill text-success"></i>
                            <small>教师</small>
                        </div>
                        <div class="role-icon" onclick="document.getElementById('roleSelect').value='student'">
                            <i class="bi bi-book-fill text-primary"></i>
                            <small>学生</small>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="bi bi-person-plus me-2"></i>创建用户
                    </button>

                    <a href="${pageContext.request.contextPath}/admin/user/list" class="btn-cancel text-center d-block text-decoration-none">
                        <i class="bi bi-arrow-left me-2"></i>返回用户列表
                    </a>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 添加输入框焦点效果
        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.querySelector('i').style.color = '#667eea';
            });

            input.addEventListener('blur', function() {
                this.parentElement.querySelector('i').style.color = '#a0aec0';
            });
        });

        // 角色选择高亮效果
        document.querySelectorAll('.role-icon').forEach(icon => {
            icon.addEventListener('click', function() {
                document.querySelectorAll('.role-icon').forEach(i => i.style.background = 'transparent');
                this.style.background = 'rgba(255, 255, 255, 0.1)';
            });
        });

        // 表单提交动画
        document.querySelector('form').addEventListener('submit', function() {
            const submitBtn = document.querySelector('.btn-submit');
            submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>正在创建...';
            submitBtn.disabled = true;
        });
    </script>
</body>
</html>
