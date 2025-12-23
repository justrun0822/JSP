package com.ztq.websocket;

public class WebSocketMessage {
    
    private String type;        // 消息类型：message, join, leave, typing, online
    private String username;    // 用户名
    private String content;     // 消息内容
    private Long userId;        // 用户ID
    private String timestamp;   // 时间戳
    private Integer onlineCount; // 在线人数
    
    public WebSocketMessage() {
    }
    
    public WebSocketMessage(String type, String username, String content) {
        this.type = type;
        this.username = username;
        this.content = content;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public String getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }
    
    public Integer getOnlineCount() {
        return onlineCount;
    }
    
    public void setOnlineCount(Integer onlineCount) {
        this.onlineCount = onlineCount;
    }
}
