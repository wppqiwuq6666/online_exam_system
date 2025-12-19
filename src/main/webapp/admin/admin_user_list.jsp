<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,com.exam.entity.User" %>
<%
  List<User> users = (List<User>) request.getAttribute("users");
  int adminCount = 0, teacherCount = 0, studentCount = 0;
  for(User u : users) {
    if("admin".equals(u.getRole())) adminCount++;
    else if("teacher".equals(u.getRole())) teacherCount++;
    else if("student".equals(u.getRole())) studentCount++;
  }
%>
<!doctype html>
<html>
<head>
    <title>用户管理 - 在线考试系统</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        /* 顶部横幅样式 */
        .hero-banner {
            background: linear-gradient(rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8)),
                        url('${pageContext.request.contextPath}/images/tech_background.png') center/cover;
            color: white;
            padding: 60px 0;
            position: relative;
            overflow: hidden;
        }

        .hero-banner::before {
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

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-description {
            font-size: 1.2rem;
            margin-bottom: 30px;
            opacity: 0.9;
        }

        /* 统计卡片样式 */
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
            margin-bottom: 20px;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .stats-card.admin {
            border-left-color: #dc3545;
        }

        .stats-card.teacher {
            border-left-color: #28a745;
        }

        .stats-card.student {
            border-left-color: #007bff;
        }

        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: white;
        }

        .stats-icon.admin {
            background: linear-gradient(135deg, #dc3545, #c82333);
        }

        .stats-icon.teacher {
            background: linear-gradient(135deg, #28a745, #1e7e34);
        }

        .stats-icon.student {
            background: linear-gradient(135deg, #007bff, #0056b3);
        }

        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 5px;
        }

        .stats-label {
            color: #718096;
            font-size: 1rem;
        }

        /* 控制栏样式 */
        .control-bar {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .search-box {
            position: relative;
            max-width: 400px;
        }

        .search-box input {
            padding-left: 45px;
            border-radius: 25px;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }

        .search-box input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            z-index: 10;
        }

        .btn-add-user {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-add-user:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            color: white;
        }

        /* 用户卡片样式 */
        .user-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .user-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #f0f0f0;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .user-info h5 {
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .user-role {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .user-role.admin {
            background: #fee;
            color: #dc3545;
        }

        .user-role.teacher {
            background: #d4edda;
            color: #155724;
        }

        .user-role.student {
            background: #d1ecf1;
            color: #0c5460;
        }

        .user-id {
            color: #a0aec0;
            font-size: 0.9rem;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
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

        .btn-edit {
            background: #e3f2fd;
            color: #1976d2;
        }

        .btn-edit:hover {
            background: #1976d2;
            color: white;
            transform: translateY(-2px);
        }

        .btn-delete {
            background: #ffebee;
            color: #d32f2f;
        }

        .btn-delete:hover {
            background: #d32f2f;
            color: white;
            transform: translateY(-2px);
        }

        /* 过滤标签样式 */
        .filter-tags {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-tag {
            padding: 8px 20px;
            border-radius: 20px;
            border: 2px solid #e2e8f0;
            background: white;
            color: #4a5568;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .filter-tag:hover,
        .filter-tag.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }

            .stats-card {
                margin-bottom: 15px;
            }

            .control-bar {
                padding: 15px;
            }

            .user-card {
                padding: 20px;
            }

            .user-avatar {
                width: 60px;
                height: 60px;
            }

            .action-buttons {
                flex-direction: column;
                width: 100%;
            }
        }

        /* 加载动画 */
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 50px;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 空状态样式 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #718096;
        }

        .empty-state i {
            font-size: 4rem;
            color: #cbd5e0;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- 顶部横幅 -->
    <div class="hero-banner">
        <div class="container">
            <div class="hero-content">
                <h1 class="hero-title">
                    <i class="bi bi-people-fill me-3"></i>用户管理中心
                </h1>
                <p class="hero-description">
                    管理系统中的所有用户账户，包括管理员、教师和学生角色
                </p>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <!-- 统计卡片 -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stats-card admin">
                    <div class="stats-icon admin">
                        <i class="bi bi-shield-fill-check"></i>
                    </div>
                    <div class="stats-number"><%= adminCount %></div>
                    <div class="stats-label">管理员</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card teacher">
                    <div class="stats-icon teacher">
                        <i class="bi bi-mortarboard-fill"></i>
                    </div>
                    <div class="stats-number"><%= teacherCount %></div>
                    <div class="stats-label">教师</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card student">
                    <div class="stats-icon student">
                        <i class="bi bi-book-fill"></i>
                    </div>
                    <div class="stats-number"><%= studentCount %></div>
                    <div class="stats-label">学生</div>
                </div>
            </div>
        </div>

        <!-- 控制栏 -->
        <div class="control-bar">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <div class="search-box">
                        <i class="bi bi-search"></i>
                        <input type="text" class="form-control" id="searchInput" placeholder="搜索用户名...">
                    </div>
                </div>
                <div class="col-md-6 text-end">
                    <a href="${pageContext.request.contextPath}/admin/user/add" class="btn-add-user">
                        <i class="bi bi-person-plus-fill me-2"></i>添加新用户
                    </a>
                </div>
            </div>
        </div>

        <!-- 过滤标签 -->
        <div class="filter-tags">
            <div class="filter-tag active" data-filter="all">
                <i class="bi bi-people me-2"></i>全部用户
            </div>
            <div class="filter-tag" data-filter="admin">
                <i class="bi bi-shield me-2"></i>管理员
            </div>
            <div class="filter-tag" data-filter="teacher">
                <i class="bi bi-mortarboard me-2"></i>教师
            </div>
            <div class="filter-tag" data-filter="student">
                <i class="bi bi-book me-2"></i>学生
            </div>
        </div>

        <!-- 用户列表 -->
        <div class="row" id="userList">
            <% if(users == null || users.isEmpty()) { %>
                <div class="col-12">
                    <div class="empty-state">
                        <i class="bi bi-people"></i>
                        <h3>暂无用户</h3>
                        <p>系统中还没有任何用户，点击上方按钮添加第一个用户</p>
                    </div>
                </div>
            <% } else { %>
                <% for(User u : users) { %>
                    <div class="col-lg-6 col-xl-4 user-item" data-role="<%=u.getRole()%>" data-username="<%=u.getUsername().toLowerCase()%>">
                        <div class="user-card">
                            <div class="d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/images/<%= "admin".equals(u.getRole()) ? "admin_avatar.jpg" : "teacher".equals(u.getRole()) ? "teacher_avatar.png" : "student_avatar.jpg" %>"
                                     alt="<%=u.getRole()%>" class="user-avatar me-3">
                                <div class="user-info flex-grow-1">
                                    <h5><%=u.getUsername()%></h5>
                                    <span class="user-role <%=u.getRole()%>">
                                        <% if("admin".equals(u.getRole())) { %>
                                            <i class="bi bi-shield-fill me-1"></i>管理员
                                        <% } else if("teacher".equals(u.getRole())) { %>
                                            <i class="bi bi-mortarboard-fill me-1"></i>教师
                                        <% } else { %>
                                            <i class="bi bi-book-fill me-1"></i>学生
                                        <% } %>
                                    </span>
                                    <div class="user-id mt-1">
                                        <i class="bi bi-hash me-1"></i>ID: <%=u.getId()%>
                                    </div>
                                </div>
                            </div>
                            <div class="action-buttons mt-3">
                                <button class="btn-action btn-edit" onclick="editUser(<%=u.getId()%>)">
                                    <i class="bi bi-pencil"></i>编辑
                                </button>
                                <a href="delete?id=<%=u.getId()%>"
                                   class="btn-action btn-delete"
                                   onclick="return confirm('确定要删除用户 &quot;<%=u.getUsername()%>&quot; 吗？')">
                                    <i class="bi bi-trash"></i>删除
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <!-- 加载动画 -->
        <div class="loading-spinner" id="loadingSpinner">
            <div class="spinner"></div>
            <p>加载中...</p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 搜索功能
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const userItems = document.querySelectorAll('.user-item');

            userItems.forEach(item => {
                const username = item.dataset.username;
                if (username.includes(searchTerm)) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });

        // 过滤功能
        document.querySelectorAll('.filter-tag').forEach(tag => {
            tag.addEventListener('click', function() {
                // 更新活动状态
                document.querySelectorAll('.filter-tag').forEach(t => t.classList.remove('active'));
                this.classList.add('active');

                const filter = this.dataset.filter;
                const userItems = document.querySelectorAll('.user-item');

                userItems.forEach(item => {
                    if (filter === 'all' || item.dataset.role === filter) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                });
            });
        });

        // 编辑用户功能（暂时为示例）
        function editUser(userId) {
            // 这里可以扩展为编辑功能
            alert('编辑功能待实现，用户ID: ' + userId);
        }

        // 页面加载动画
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.stats-card, .user-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });

        // 删除确认增强
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', function(e) {
                if (!confirm('确定要删除此用户吗？此操作不可恢复。')) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>
