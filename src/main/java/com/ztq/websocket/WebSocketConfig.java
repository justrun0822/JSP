package com.ztq.websocket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;

public class WebSocketConfig extends ServerEndpointConfig.Configurator {
    
    private static final Logger logger = LoggerFactory.getLogger(WebSocketConfig.class);
    
    @Override
    public void modifyHandshake(ServerEndpointConfig config, 
                                HandshakeRequest request, 
                                HandshakeResponse response) {
        
        // 获取 HTTP Session
        HttpSession httpSession = (HttpSession) request.getHttpSession();
        
        if (httpSession != null) {
            // 从 HTTP Session 中获取用户信息
            String username = (String) httpSession.getAttribute("username");
            Long userId = (Long) httpSession.getAttribute("userId");
            
            // 将用户信息存储到 WebSocket Session 的 UserProperties 中
            config.getUserProperties().put("username", username);
            config.getUserProperties().put("userId", userId);
            
            logger.debug("WebSocket 握手 - 用户: {}, ID: {}", username, userId);
        }
        
        super.modifyHandshake(config, request, response);
    }
}
