<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>简易聊天室</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .user-info { color: #666; font-size: 14px; }
        .chat-box { border: 1px solid #ccc; padding: 10px; height: 300px; overflow-y: scroll; background-color: #fff; margin-bottom: 10px; }
        .message { padding: 5px 10px; border-bottom: 1px solid #eee; }
        .empty-hint { color: #999; text-align: center; padding: 20px; }
        .error { color: #d9534f; background-color: #f2dede; border: 1px solid #ebccd1; padding: 10px; margin-bottom: 10px; border-radius: 4px; }
        .form-container { display: flex; gap: 10px; }
        input[type="text"] { padding: 10px; flex: 1; border: 1px solid #ccc; border-radius: 4px; }
        input[type="submit"] { padding: 10px 20px; background-color: #5cb85c; color: white; border: none; border-radius: 4px; cursor: pointer; }
        input[type="submit"]:hover { background-color: #4cae4c; }
    </style>
</head>
<body>

<div class="header">
    <h1>欢迎来到简易聊天室</h1>
    <div class="user-info">当前用户: ${empty sessionScope.username ? '访客' : sessionScope.username}</div>
</div>

<!-- 错误提示 -->
<c:if test="${param.error == 'empty'}">
    <div class="error">消息不能为空！</div>
</c:if>
<c:if test="${param.error == 'toolong'}">
    <div class="error">消息太长，请控制在500字以内！</div>
</c:if>

<!-- 显示聊天记录 -->
<div class="chat-box">
    <c:choose>
        <c:when test="${empty applicationScope.messages}">
            <div class="empty-hint">暂无消息，快来发送第一条消息吧！</div>
        </c:when>
        <c:otherwise>
            <c:forEach var="message" items="${applicationScope.messages}">
                <div class="message"><c:out value="${message}"/></div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<!-- 发送新消息 -->
<form action="sendMessage" method="post" class="form-container">
    <input type="text" name="message" placeholder="请输入消息（最多500字）" required maxlength="500" />
    <input type="submit" value="发送" />
</form>

</body>
</html>
