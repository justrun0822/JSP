package com.ztq.servlet;

import com.ztq.service.MessageService;
import org.apache.commons.text.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/sendMessage")
public class MessageServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(MessageServlet.class);
    private static final int MAX_MESSAGE_LENGTH = 500;
    
    private MessageService messageService = new MessageService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String messageContent = request.getParameter("message");
        
        if (messageContent == null || messageContent.trim().isEmpty()) {
            response.sendRedirect("chat.jsp?error=empty");
            return;
        }
        
        messageContent = messageContent.trim();
        
        if (messageContent.length() > MAX_MESSAGE_LENGTH) {
            response.sendRedirect("chat.jsp?error=toolong");
            return;
        }
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            username = "访客" + session.getId().substring(0, 6);
            session.setAttribute("username", username);
        }
        
        messageContent = StringEscapeUtils.escapeHtml4(messageContent);
        
        logger.info("用户 {} 发送消息", username);
        boolean success = messageService.saveMessage(username, messageContent);
        
        if (!success) {
            logger.error("消息保存失败 - 用户: {}", username);
        }
        
        response.sendRedirect("chat.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("chat.jsp");
    }
}
