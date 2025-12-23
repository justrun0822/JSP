package com.ztq.servlet;

import com.ztq.dao.MessageDAO;
import com.ztq.entity.Message;
import org.apache.commons.text.StringEscapeUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/sendMessage")
public class MessageServlet extends HttpServlet {
    
    private static final int MAX_MESSAGE_LENGTH = 500;
    private static final int MAX_MESSAGES_KEEP = 100;
    
    private MessageDAO messageDAO = new MessageDAO();
    
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
        
        Message message = new Message(username, messageContent);
        boolean success = messageDAO.addMessage(message);
        
        if (success) {
            int messageCount = messageDAO.getMessageCount();
            if (messageCount > MAX_MESSAGES_KEEP) {
                messageDAO.deleteOldMessages(MAX_MESSAGES_KEEP);
            }
        }
        
        response.sendRedirect("chat.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("chat.jsp");
    }
}
