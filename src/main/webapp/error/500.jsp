<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>500 - 服务器错误</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .error-container {
            text-align: center;
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
        }
        .error-code {
            font-size: 72px;
            font-weight: bold;
            color: #d9534f;
            margin: 0;
        }
        .error-message {
            font-size: 24px;
            color: #666;
            margin: 20px 0;
        }
        .error-description {
            color: #999;
            margin: 20px 0;
        }
        .error-details {
            background-color: #f8f8f8;
            padding: 15px;
            border-left: 4px solid #d9534f;
            text-align: left;
            margin: 20px 0;
            display: none;
        }
        .error-details code {
            color: #c7254e;
            background-color: #f9f2f4;
            padding: 2px 4px;
            border-radius: 3px;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #5cb85c;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .back-link:hover {
            background-color: #4cae4c;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">500</div>
        <div class="error-message">服务器内部错误</div>
        <div class="error-description">抱歉，服务器处理请求时发生错误，请稍后再试</div>
        <% if (exception != null && request.getParameter("debug") != null) { %>
        <div class="error-details">
            <strong>错误信息：</strong><br/>
            <code><%= exception.getMessage() %></code>
        </div>
        <% } %>
        <a href="${pageContext.request.contextPath}/" class="back-link">返回首页</a>
    </div>
</body>
</html>
