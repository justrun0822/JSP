<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>表单提交 - Request 对象演示</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .form-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            max-width: 500px;
            width: 100%;
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
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            color: #333;
            font-weight: bold;
            margin-bottom: 8px;
        }
        input[type="text"] {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus {
            outline: none;
            border-color: #667eea;
        }
        input[type="submit"] {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            background-color: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #5568d3;
        }
        .info-box {
            background-color: #f0f7ff;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .info-box p {
            margin: 0;
            color: #555;
            font-size: 14px;
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
<body>
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
