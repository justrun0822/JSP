<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<html>
<head>
    <title>简易聊天室</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }
        .chat-box { border: 1px solid #ccc; padding: 10px; height: 300px; overflow-y: scroll; background-color: #fff; }
        .message { padding: 5px 10px; border-bottom: 1px solid #eee; }
        input[type="text"] { padding: 10px; width: 80%; }
        input[type="submit"] { padding: 10px; }
    </style>
</head>
<body>

<h1>欢迎来到简易聊天室</h1>

<!-- 显示聊天记录 -->
<div class="chat-box">
    <%
        // 获取应用级别的聊天记录
        List<String> messages = (List<String>) application.getAttribute("messages");
        if (messages == null) {
            messages = new ArrayList<>();
        }
        // 显示所有消息
        for (String message : messages) {
            out.println("<div class='message'>" + message + "</div>");
        }
    %>
</div>

<!-- 发送新消息 -->
<form action="sendMessage.jsp" method="post">
    <input type="text" name="message" placeholder="请输入消息" required />
    <input type="submit" value="发送" />
</form>

</body>
</html>
