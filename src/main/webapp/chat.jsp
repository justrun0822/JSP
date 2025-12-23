<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ztq.dao.MessageDAO" %>
<%@ page import="com.ztq.entity.Message" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    MessageDAO messageDAO = new MessageDAO();
    List<Message> messages = messageDAO.getRecentMessages(100);
    request.setAttribute("messages", messages);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>简易聊天室</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat.css">
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
        <c:when test="${empty messages}">
            <div class="empty-hint">暂无消息，快来发送第一条消息吧！</div>
        </c:when>
        <c:otherwise>
            <c:forEach var="message" items="${messages}">
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
