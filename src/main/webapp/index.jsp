<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP 学习项目 - 首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body class="gradient-bg">
<div class="container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h1>🎉 Hello World!</h1>
        <div style="display: flex; gap: 10px;">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <span style="color: #667eea; font-weight: bold;">👤 ${sessionScope.username}</span>
                    <a href="${pageContext.request.contextPath}/logout" 
                       style="padding: 8px 16px; background-color: #dc3545; color: white; text-decoration: none; border-radius: 4px;">
                        退出
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" 
                       style="padding: 8px 16px; background-color: #667eea; color: white; text-decoration: none; border-radius: 4px;">
                        登录
                    </a>
                    <a href="${pageContext.request.contextPath}/register" 
                       style="padding: 8px 16px; background-color: #28a745; color: white; text-decoration: none; border-radius: 4px;">
                        注册
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <p class="subtitle">欢迎来到 JSP 学习项目</p>
    
    <div class="time-info">
        <jsp:useBean id="currentDate" class="java.util.Date"/>
        <strong>今天是:</strong> <fmt:formatDate value="${currentDate}" pattern="yyyy年MM月dd日 EEEE HH:mm:ss"/>
    </div>
    
    <div class="nav-section">
        <h2>📚 功能模块</h2>
        <div class="nav-grid">
            <a href="chat.jsp" class="nav-card">
                <h3>💬 聊天室</h3>
                <p>简易在线聊天功能</p>
            </a>
            <a href="visitor" class="nav-card">
                <h3>👥 访客计数</h3>
                <p>统计网站访问人数</p>
            </a>
            <a href="ShowCurrentTime.jsp" class="nav-card">
                <h3>⏰ 时间显示</h3>
                <p>显示当前系统时间</p>
            </a>
            <a href="form.jsp" class="nav-card">
                <h3>📝 表单提交</h3>
                <p>Request 对象演示</p>
            </a>
            <a href="register.html" class="nav-card">
                <h3>📋 用户注册</h3>
                <p>注册表单示例</p>
            </a>
        </div>
    </div>
</div>
</body>
</html>
