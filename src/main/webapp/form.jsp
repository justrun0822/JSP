<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>表单提交 - Request 对象演示</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .form-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            max-width: 500px;
            width: 100%;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #667eea;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body class="gradient-bg container-centered">
    <div class="form-container">
        <h1>📝 表单提交演示</h1>
        <p class="subtitle">提交后将展示 Request 对象的详细信息</p>
        
        <div class="info-box">
            <p>💡 此表单用于演示 JSP 的 Request 对象，提交后会显示 HTTP 请求的详细信息，包括协议、方法、头信息、客户端信息等。</p>
        </div>
        
        <form name="form" method="post" action="request.jsp">
            <div class="form-group">
                <label for="text">请输入信息：</label>
                <input type="text" id="text" name="text" placeholder="输入任意内容..." required>
            </div>
            
            <input type="submit" name="submit" value="提交并查看 Request 信息">
        </form>
        
        <a href="index.jsp" class="back-link">← 返回首页</a>
    </div>
</body>
</html>
