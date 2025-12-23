<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>实时聊天室 - WebSocket</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat.css">
    <style>
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .online-badge {
            background-color: #28a745;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .online-dot {
            width: 8px;
            height: 8px;
            background-color: white;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        
        .connection-status {
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            display: none;
            margin-bottom: 10px;
        }
        
        .status-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .status-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .ws-message {
            animation: fadeIn 0.3s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .message-time {
            color: #999;
            font-size: 12px;
            margin-right: 8px;
        }
        
        .message-user {
            color: #667eea;
            font-weight: bold;
            margin-right: 8px;
        }
        
        .message-content {
            color: #333;
        }
        
        .system-message {
            text-align: center;
            padding: 8px;
            margin: 10px 0;
            border-radius: 5px;
            font-size: 14px;
            font-style: italic;
        }
        
        .system-join {
            background-color: #d4edda;
            color: #155724;
        }
        
        .system-leave {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .typing-indicator {
            padding: 10px;
            margin: 10px 0;
            background-color: #f8f9fa;
            border-radius: 5px;
            font-size: 14px;
            color: #666;
            font-style: italic;
            display: none;
        }
        
        .typing-user {
            color: #667eea;
            font-weight: bold;
            margin-right: 5px;
        }
        
        .realtime-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .feature-list {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 10px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        
        .feature-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 13px;
            color: #666;
        }
        
        .feature-icon {
            color: #28a745;
        }
        
        .back-to-old {
            margin-top: 15px;
            text-align: center;
        }
        
        .back-to-old a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-to-old a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container" style="max-width: 900px; margin: 20px auto; padding: 20px;">
    
    <div class="header">
        <div class="header-left">
            <h1>💬 实时聊天室</h1>
            <span class="realtime-badge">🚀 WebSocket</span>
        </div>
        <div>
            <div class="online-badge">
                <span class="online-dot"></span>
                <span>在线: <strong id="onlineCount">0</strong></span>
            </div>
        </div>
    </div>
    
    <div class="user-info">
        👤 当前用户: <strong>${empty sessionScope.username ? '访客' : sessionScope.username}</strong>
        <c:if test="${not empty sessionScope.userId}">
            <span style="color: #28a745; margin-left: 10px;">✓ 已登录</span>
        </c:if>
        <c:if test="${empty sessionScope.userId}">
            <a href="${pageContext.request.contextPath}/login?returnUrl=${pageContext.request.contextPath}/chat-realtime.jsp" 
               style="margin-left: 10px; color: #667eea; text-decoration: none;">
                登录以使用完整功能 →
            </a>
        </c:if>
    </div>
    
    <div class="feature-list">
        <div class="feature-item">
            <span class="feature-icon">✓</span>
            <span>无需刷新，实时接收消息</span>
        </div>
        <div class="feature-item">
            <span class="feature-icon">✓</span>
            <span>在线人数实时显示</span>
        </div>
        <div class="feature-item">
            <span class="feature-icon">✓</span>
            <span>输入中状态提示</span>
        </div>
        <div class="feature-item">
            <span class="feature-icon">✓</span>
            <span>自动重连机制</span>
        </div>
    </div>
    
    <!-- 连接状态 -->
    <div id="connectionStatus" class="connection-status"></div>
    
    <!-- 输入中提示 -->
    <div id="typingIndicator" class="typing-indicator">
        <span id="typingText"></span>
    </div>
    
    <!-- 聊天记录 -->
    <div class="chat-box" id="chatBox">
        <div class="empty-hint">连接到服务器后即可开始聊天...</div>
    </div>
    
    <!-- 发送消息表单 -->
    <form id="messageForm" class="form-container" onsubmit="return false;">
        <div style="flex: 1;">
            <input type="text" id="messageInput" 
                   placeholder="输入消息（最多500字），Enter发送..." 
                   maxlength="500" 
                   autocomplete="off" />
            <div class="char-counter" id="charCounter">0 / 500</div>
        </div>
        <button type="button" id="sendBtn" class="btn btn-primary">发送</button>
    </form>
    
    <div class="back-to-old">
        <a href="${pageContext.request.contextPath}/chat.jsp">← 返回传统聊天室（Ajax 刷新）</a> | 
        <a href="${pageContext.request.contextPath}/index.jsp">返回首页</a>
    </div>
    
</div>

<script src="${pageContext.request.contextPath}/js/websocket-chat.js"></script>

</body>
</html>
