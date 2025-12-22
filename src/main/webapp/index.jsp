<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP 学习项目 - 首页</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
        }
        .time-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            margin: 20px 0;
            color: #495057;
        }
        .nav-section {
            margin-top: 30px;
        }
        .nav-section h2 {
            color: #333;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }
        .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        .nav-card {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
            border: 1px solid #dee2e6;
        }
        .nav-card:hover {
            background-color: #667eea;
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .nav-card h3 {
            margin: 0 0 10px 0;
            font-size: 18px;
        }
        .nav-card p {
            margin: 0;
            font-size: 14px;
            opacity: 0.8;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>🎉 Hello World!</h1>
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
            <a href="CountUsers.jsp" class="nav-card">
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
