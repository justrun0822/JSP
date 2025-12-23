<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ztq.dao.MessageDAO" %>
<%@ page import="com.ztq.entity.Message" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (request.getAttribute("messages") == null) {
        MessageDAO messageDAO = new MessageDAO();
        List<Message> messages = messageDAO.getRecentMessages(100);
        request.setAttribute("messages", messages);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>简易聊天室</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat.css">
    <style>
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        .toolbar button {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        #toggleRefresh {
            background-color: #28a745;
            color: white;
        }
        .char-counter {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            text-align: right;
        }
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 20px 0;
            gap: 10px;
        }
        .pagination a, .pagination span {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
            color: #333;
        }
        .pagination a:hover {
            background-color: #667eea;
            color: white;
        }
        .pagination .current {
            background-color: #667eea;
            color: white;
            font-weight: bold;
        }
        .user-actions {
            display: flex;
            gap: 10px;
        }
        .btn-logout {
            background-color: #dc3545;
            color: white;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-logout:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<div class="header">
    <h1>💬 简易聊天室</h1>
    <div class="user-actions">
        <div class="user-info">
            👤 ${empty sessionScope.username ? '访客' : sessionScope.username}
            <c:if test="${not empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">退出</a>
            </c:if>
        </div>
    </div>
</div>

<div class="toolbar">
    <button id="toggleRefresh" onclick="toggleAutoRefresh()">▶ 开启自动刷新</button>
    <c:if test="${not empty sessionScope.userId}">
        <span>✅ 已登录用户</span>
    </c:if>
    <c:if test="${empty sessionScope.userId}">
        <a href="${pageContext.request.contextPath}/login?returnUrl=${pageContext.request.contextPath}/chat.jsp" 
           style="padding: 8px 16px; background-color: #667eea; color: white; text-decoration: none; border-radius: 4px;">
            登录以使用完整功能
        </a>
    </c:if>
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
<form action="sendMessage" method="post" class="form-container" id="messageForm">
    <div style="flex: 1;">
        <input type="text" id="messageInput" name="message" 
               placeholder="请输入消息（最多500字）" 
               required maxlength="500" />
        <div class="char-counter" id="charCounter">0 / 500</div>
    </div>
    <input type="submit" value="发送" />
</form>

<c:if test="${not empty totalPages && totalPages > 1}">
    <div class="pagination">
        <c:if test="${currentPage > 1}">
            <a href="?page=${currentPage - 1}&pageSize=${pageSize}">« 上一页</a>
        </c:if>
        
        <c:forEach begin="1" end="${totalPages}" var="i">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span class="current">${i}</span>
                </c:when>
                <c:otherwise>
                    <a href="?page=${i}&pageSize=${pageSize}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        
        <c:if test="${currentPage < totalPages}">
            <a href="?page=${currentPage + 1}&pageSize=${pageSize}">下一页 »</a>
        </c:if>
        
        <span style="margin-left: 20px;">
            共 ${totalCount} 条消息，第 ${currentPage}/${totalPages} 页
        </span>
    </div>
</c:if>

<script src="${pageContext.request.contextPath}/js/chat.js"></script>
</body>
</html>
