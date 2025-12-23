package com.ztq.websocket;

import com.google.gson.Gson;
import com.ztq.service.MessageService;
import org.apache.commons.text.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint(value = "/websocket/chat")
public class ChatWebSocket {
    
    private static final Logger logger = LoggerFactory.getLogger(ChatWebSocket.class);
    private static final Gson gson = new Gson();
    private static final MessageService messageService = new MessageService();
    
    // 存储所有连接的客户端
    private static final CopyOnWriteArraySet<ChatWebSocket> clients = new CopyOnWriteArraySet<>();
    
    // 存储用户名和会话的映射
    private static final Map<String, Session> userSessions = new ConcurrentHashMap<>();
    
    // 存储正在输入的用户
    private static final CopyOnWriteArraySet<String> typingUsers = new CopyOnWriteArraySet<>();
    
    private Session session;
    private String username;
    private Long userId;
    
    @OnOpen
    public void onOpen(Session session) {
        this.session = session;
        clients.add(this);
        
        // 从 session 中获取用户信息
        Map<String, Object> userProperties = session.getUserProperties();
        this.username = (String) userProperties.get("username");
        this.userId = (Long) userProperties.get("userId");
        
        if (this.username == null) {
            this.username = "访客" + session.getId().substring(0, 6);
        }
        
        userSessions.put(this.username, session);
        
        logger.info("WebSocket 连接建立 - 用户: {}, SessionId: {}", username, session.getId());
        
        // 发送欢迎消息
        sendJoinMessage();
        
        // 广播在线人数
        broadcastOnlineCount();
    }
    
    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            WebSocketMessage wsMessage = gson.fromJson(message, WebSocketMessage.class);
            
            logger.debug("收到消息 - 类型: {}, 用户: {}", wsMessage.getType(), username);
            
            switch (wsMessage.getType()) {
                case "message":
                    handleChatMessage(wsMessage);
                    break;
                case "typing":
                    handleTyping(wsMessage);
                    break;
                case "stop_typing":
                    handleStopTyping();
                    break;
                default:
                    logger.warn("未知消息类型: {}", wsMessage.getType());
            }
            
        } catch (Exception e) {
            logger.error("处理 WebSocket 消息失败", e);
        }
    }
    
    @OnClose
    public void onClose(Session session, CloseReason reason) {
        clients.remove(this);
        userSessions.remove(this.username);
        typingUsers.remove(this.username);
        
        logger.info("WebSocket 连接关闭 - 用户: {}, 原因: {}", username, reason);
        
        // 发送离开消息
        sendLeaveMessage();
        
        // 广播在线人数
        broadcastOnlineCount();
    }
    
    @OnError
    public void onError(Session session, Throwable error) {
        logger.error("WebSocket 错误 - 用户: {}", username, error);
    }
    
    /**
     * 处理聊天消息
     */
    private void handleChatMessage(WebSocketMessage wsMessage) {
        String content = wsMessage.getContent();
        
        if (content == null || content.trim().isEmpty()) {
            return;
        }
        
        if (content.length() > 500) {
            content = content.substring(0, 500);
        }
        
        // XSS 防护
        content = StringEscapeUtils.escapeHtml4(content);
        
        // 保存到数据库
        messageService.saveMessage(username, content);
        
        // 构建广播消息
        WebSocketMessage broadcastMsg = new WebSocketMessage("message", username, content);
        broadcastMsg.setUserId(userId);
        broadcastMsg.setTimestamp(getCurrentTime());
        
        // 广播给所有客户端
        broadcast(gson.toJson(broadcastMsg));
        
        logger.info("广播消息 - 用户: {}, 内容长度: {}", username, content.length());
    }
    
    /**
     * 处理输入中状态
     */
    private void handleTyping(WebSocketMessage wsMessage) {
        if (!typingUsers.contains(username)) {
            typingUsers.add(username);
            
            WebSocketMessage typingMsg = new WebSocketMessage("typing", username, null);
            broadcast(gson.toJson(typingMsg));
            
            logger.debug("用户 {} 开始输入", username);
        }
    }
    
    /**
     * 处理停止输入状态
     */
    private void handleStopTyping() {
        if (typingUsers.remove(username)) {
            WebSocketMessage stopTypingMsg = new WebSocketMessage("stop_typing", username, null);
            broadcast(gson.toJson(stopTypingMsg));
            
            logger.debug("用户 {} 停止输入", username);
        }
    }
    
    /**
     * 发送加入消息
     */
    private void sendJoinMessage() {
        WebSocketMessage joinMsg = new WebSocketMessage("join", username, username + " 加入了聊天室");
        joinMsg.setTimestamp(getCurrentTime());
        broadcast(gson.toJson(joinMsg));
    }
    
    /**
     * 发送离开消息
     */
    private void sendLeaveMessage() {
        WebSocketMessage leaveMsg = new WebSocketMessage("leave", username, username + " 离开了聊天室");
        leaveMsg.setTimestamp(getCurrentTime());
        broadcast(gson.toJson(leaveMsg));
    }
    
    /**
     * 广播在线人数
     */
    private void broadcastOnlineCount() {
        WebSocketMessage onlineMsg = new WebSocketMessage("online", "system", null);
        onlineMsg.setOnlineCount(clients.size());
        broadcast(gson.toJson(onlineMsg));
    }
    
    /**
     * 广播消息给所有客户端
     */
    private void broadcast(String message) {
        for (ChatWebSocket client : clients) {
            try {
                synchronized (client.session) {
                    if (client.session.isOpen()) {
                        client.session.getBasicRemote().sendText(message);
                    }
                }
            } catch (IOException e) {
                logger.error("发送消息失败 - 用户: {}", client.username, e);
            }
        }
    }
    
    /**
     * 获取当前时间
     */
    private String getCurrentTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        return sdf.format(new Date());
    }
    
    /**
     * 获取在线人数
     */
    public static int getOnlineCount() {
        return clients.size();
    }
}
