<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登录 - JSP 学习项目</title>
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
        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            max-width: 400px;
            width: 100%;
        }
        .login-container h1 {
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
        .remember-me {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .remember-me input[type="checkbox"] {
            width: auto;
            margin-right: 8px;
        }
        .remember-me label {
            margin: 0;
            font-weight: normal;
        }
        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        .register-link a {
            color: #667eea;
            text-decoration: none;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>🔐 用户登录</h1>
        
        <c:if test="${param.registered == 'true'}">
            <div class="success-message">
                ✅ 注册成功！请登录
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                ❌ <c:out value="${error}"/>
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" required 
                       value="<c:out value='${username}'/>"
                       placeholder="请输入用户名">
            </div>
            
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" required 
                       placeholder="请输入密码">
            </div>
            
            <div class="remember-me">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">记住我（7天）</label>
            </div>
            
            <input type="hidden" name="returnUrl" value="${param.returnUrl}">
            
            <input type="submit" value="登录">
        </form>
        
        <div class="register-link">
            还没有账号？<a href="${pageContext.request.contextPath}/register">立即注册</a>
        </div>
        
        <div class="register-link" style="margin-top: 10px;">
            <a href="${pageContext.request.contextPath}/index.jsp">← 返回首页</a>
        </div>
    </div>
</body>
</html>
