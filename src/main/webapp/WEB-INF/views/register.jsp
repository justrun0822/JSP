<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册 - JSP 学习项目</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .register-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            max-width: 450px;
            width: 100%;
        }
        .register-container h1 {
            margin-bottom: 30px;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            border: 1px solid #f5c6cb;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            border: 1px solid #c3e6cb;
        }
        .form-hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1>📝 用户注册</h1>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                ❌ <c:out value="${error}"/>
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
            <div class="form-group">
                <label for="username">用户名 *</label>
                <input type="text" id="username" name="username" required 
                       minlength="3" maxlength="20" 
                       pattern="[a-zA-Z0-9_]+"
                       placeholder="3-20位字母、数字或下划线">
                <div class="form-hint">用户名将用于聊天室显示</div>
            </div>
            
            <div class="form-group">
                <label for="email">邮箱 *</label>
                <input type="email" id="email" name="email" required 
                       placeholder="your@email.com">
            </div>
            
            <div class="form-group">
                <label for="password">密码 *</label>
                <input type="password" id="password" name="password" required 
                       minlength="6" maxlength="50"
                       placeholder="至少6位字符">
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">确认密码 *</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required 
                       placeholder="再次输入密码">
            </div>
            
            <input type="submit" value="注册">
        </form>
        
        <div class="login-link">
            已有账号？<a href="${pageContext.request.contextPath}/login">立即登录</a>
        </div>
    </div>
    
    <script>
        // 实时验证密码一致性
        document.getElementById('confirmPassword').addEventListener('input', function() {
            var password = document.getElementById('password').value;
            var confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('两次密码输入不一致');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // 用户名实时验证
        document.getElementById('username').addEventListener('input', function() {
            var username = this.value;
            if (username.length > 0 && username.length < 3) {
                this.setCustomValidity('用户名至少3个字符');
            } else if (!/^[a-zA-Z0-9_]+$/.test(username)) {
                this.setCustomValidity('只能包含字母、数字和下划线');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
