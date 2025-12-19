<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.exam.entity.User" %>
<%
    User u = (User) session.getAttribute("currentUser");
    if (u == null) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }
    if (!"student".equals(u.getRole())) { response.sendRedirect(request.getContextPath()+"/login.jsp"); return; }

    String displayName = u.getDisplayName() != null && !u.getDisplayName().isEmpty() ? u.getDisplayName() : u.getUsername();
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    String activeTab = (String) request.getAttribute("activeTab");
%>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>个人设置 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{background:#f8f6ff;}
        .header-section{background:linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%); color:white; padding:30px 0; margin-bottom:30px;}
        .profile-section{background:white; padding:30px; border-radius:10px; box-shadow:0 2px 10px rgba(155, 89, 182, 0.1); margin-bottom:20px;}
        .nav-tabs .nav-link.active{background:linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%); border-color:#9b59b6; color:white;}
        .nav-tabs .nav-link{color:#495057; border:1px solid #dee2e6; margin-bottom:-1px;}
        .form-label{font-weight:500; color:#333;}
        .required{color:#dc3545;}
        .avatar-section{text-align:center; margin-bottom:30px;}
        .avatar{width:120px; height:120px; border-radius:50%; background:linear-gradient(135deg, #9b59b6, #8e44ad); display:flex; align-items:center; justify-content:center; margin:0 auto 15px; color:white; font-size:3rem; font-weight:600; box-shadow:0 8px 25px rgba(155, 89, 182, 0.3);}
        .info-card{background:#f8f9fa; border-radius:8px; padding:20px; border-left:4px solid #9b59b6;}
        .info-item{display:flex; justify-content:space-between; align-items:center; padding:8px 0; border-bottom:1px solid #dee2e6;}
        .info-item:last-child{border-bottom:none;}
        .info-label{font-weight:500; color:#495057;}
        .info-value{color:#212529;}
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
            <h2><i class="bi bi-person-gear me-2"></i>个人设置</h2>
            <p class="mb-0">管理您的个人信息和账户安全</p>
        </div>
    </div>

    <div class="container">
        <!-- 成功提示 -->
        <% if (success != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-1"></i>
                <% if ("profile".equals(success)) { %>
                    个人信息更新成功！
                <% } else if ("password".equals(success)) { %>
                    密码修改成功！
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- 错误提示 -->
        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-1"></i><%=error%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <!-- 左侧用户信息 -->
            <div class="col-lg-4 mb-4">
                <div class="profile-section">
                    <div class="avatar-section">
                        <div class="avatar">
                            <%=displayName.charAt(0)%>
                        </div>
                        <h5><%=displayName%></h5>
                        <p class="text-muted">学生账户</p>
                    </div>

                    <div class="info-card">
                        <h6 class="mb-3"><i class="bi bi-person me-2"></i>基本信息</h6>
                        <div class="info-item">
                            <span class="info-label">用户名</span>
                            <span class="info-value"><%=u.getUsername()%></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">角色</span>
                            <span class="info-value">
                                <span class="badge bg-purple">学生</span>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">显示名称</span>
                            <span class="info-value"><%=displayName%></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 右侧设置选项 -->
            <div class="col-lg-8">
                <div class="profile-section">
                    <!-- 导航标签 -->
                    <ul class="nav nav-tabs mb-4" id="profileTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link <%=activeTab == null || !"password".equals(activeTab) ? "active" : ""%>"
                                    id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab">
                                <i class="bi bi-person me-1"></i>个人信息
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link <%= "password".equals(activeTab) ? "active" : ""%>"
                                    id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button" role="tab">
                                <i class="bi bi-shield-lock me-1"></i>修改密码
                            </button>
                        </li>
                    </ul>

                    <!-- 标签内容 -->
                    <div class="tab-content" id="profileTabsContent">
                        <!-- 个人信息标签 -->
                        <div class="tab-pane fade <%=activeTab == null || !"password".equals(activeTab) ? "show active" : ""%>"
                             id="profile" role="tabpanel">
                            <h5 class="mb-4"><i class="bi bi-person me-2"></i>编辑个人信息</h5>
                            <form method="post" action="<%=request.getContextPath()%>/student/profile">
                                <input type="hidden" name="action" value="updateProfile">

                                <div class="mb-4">
                                    <label class="form-label">用户名</label>
                                    <input type="text" class="form-control" value="<%=u.getUsername()%>" readonly>
                                    <div class="form-text">用户名不可修改</div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">显示名称 <span class="required">*</span></label>
                                    <input type="text" class="form-control" name="displayName"
                                           value="<%=u.getDisplayName() != null ? u.getDisplayName() : ""%>" required
                                           placeholder="请输入您的显示名称">
                                    <div class="form-text">显示名称将用于系统内显示</div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">角色</label>
                                    <input type="text" class="form-control" value="学生" readonly>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="<%=request.getContextPath()%>/student/home.jsp" class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>返回首页
                                    </a>
                                    <button type="submit" class="btn btn-purple text-white">
                                        <i class="bi bi-check-circle me-1"></i>保存信息
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- 修改密码标签 -->
                        <div class="tab-pane fade <%= "password".equals(activeTab) ? "show active" : ""%>"
                             id="password" role="tabpanel">
                            <h5 class="mb-4"><i class="bi bi-shield-lock me-2"></i>修改登录密码</h5>
                            <form method="post" action="<%=request.getContextPath()%>/student/profile" id="passwordForm">
                                <input type="hidden" name="action" value="changePassword">

                                <div class="mb-4">
                                    <label class="form-label">当前密码 <span class="required">*</span></label>
                                    <input type="password" class="form-control" name="oldPassword" required
                                           placeholder="请输入当前密码">
                                    <div class="form-text">请输入您当前使用的密码</div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">新密码 <span class="required">*</span></label>
                                    <input type="password" class="form-control" name="newPassword" id="newPassword" required
                                           minlength="6" placeholder="请输入新密码（至少6位）">
                                    <div class="form-text">密码长度不少于6位</div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">确认新密码 <span class="required">*</span></label>
                                    <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" required
                                           minlength="6" placeholder="请再次输入新密码">
                                    <div class="form-text">请再次输入新密码以确认</div>
                                </div>

                                <!-- 密码强度提示 -->
                                <div class="mb-4">
                                    <div class="alert alert-info">
                                        <i class="bi bi-info-circle me-1"></i>
                                        <strong>密码安全建议：</strong>
                                        <ul class="mb-0 mt-2">
                                            <li>使用至少8位字符</li>
                                            <li>包含大小写字母、数字和特殊字符</li>
                                            <li>避免使用生日、姓名等容易被猜测的信息</li>
                                            <li>定期更换密码以提高安全性</li>
                                        </ul>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="<%=request.getContextPath()%>/student/home.jsp" class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>返回首页
                                    </a>
                                    <button type="submit" class="btn btn-purple text-white">
                                        <i class="bi bi-shield-lock me-1"></i>修改密码
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="text-center py-4 mt-5 border-top">
        <p class="text-muted mb-0">在线考试系统 - 学生端</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 密码确认验证
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('新密码与确认密码不匹配！');
                return false;
            }

            if (newPassword.length < 6) {
                e.preventDefault();
                alert('新密码长度不能少于6位！');
                return false;
            }

            return true;
        });
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
        .badge-purple {
            background: linear-gradient(135deg, #9b59b6, #8e44ad) !important;
        }
    </style>
</body>
</html>