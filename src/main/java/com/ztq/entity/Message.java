package com.ztq.entity;

import java.sql.Timestamp;

public class Message {
    
    private Long id;
    private String username;
    private String content;
    private Timestamp createTime;
    
    public Message() {
    }
    
    public Message(String username, String content) {
        this.username = username;
        this.content = content;
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
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
    
    public Timestamp getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }
    
    @Override
    public String toString() {
        return username + ": " + content;
    }
}
