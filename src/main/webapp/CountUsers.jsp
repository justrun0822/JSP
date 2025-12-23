<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (request.getAttribute("visitorCount") == null) {
        response.sendRedirect("visitor");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>访客计数</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        body {
            background-color: #f4f4f4;
            padding: 20px;
        }
        .counter-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 0 auto;
            text-align: center;
        }
        .counter-display {
            font-size: 48px;
            color: #6495ed;
            font-weight: bold;
            margin: 30px 0;
        }
        .counter-text {
            font-size: 20px;
            color: #6495ed;
            margin: 10px 0;
        }
        .info-note {
            background-color: #f0f7ff;
            border-left: 4px solid #6495ed;
            padding: 15px;
            margin-top: 20px;
            text-align: left;
            font-size: 14px;
            color: #555;
        }
    </style>
</head>
<body>
<div class="counter-container">
    <h1>👥 访客计数器</h1>
    <div class="counter-text">Total number of visitors</div>
    <div class="counter-display"><c:out value="${visitorCount}"/></div>
    <div class="counter-text">您是本站第 <strong><c:out value="${visitorCount}"/></strong> 位访客！</div>
    
    <div class="info-note">
        💡 <strong>提示：</strong>访客计数已保存到数据库，服务器重启后数据不会丢失。
    </div>
    
    <br/>
    <a href="index.jsp" class="back-link">返回首页</a>
</div>
</body>
</html>
