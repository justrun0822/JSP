package com.ztq.servlet;

import org.apache.commons.text.StringEscapeUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/sendMessage")
public class MessageServlet extends HttpServlet {
    
    private static final int MAX_MESSAGE_LENGTH = 500;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String message = request.getParameter("message");
        
        if (message == null || message.trim().isEmpty()) {
            response.sendRedirect("chat.jsp?error=empty");
            return;
        }
        
        message = message.trim();
        
        if (message.length() > MAX_MESSAGE_LENGTH) {
            response.sendRedirect("chat.jsp?error=toolong");
            return;
        }
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            username = "访客" + session.getId().substring(0, 6);
            session.setAttribute("username", username);
        }
        
        message = StringEscapeUtils.escapeHtml4(message);
        
        String formattedMessage = username + ": " + message;
        
        @SuppressWarnings("unchecked")
        List<String> messages = (List<String>) getServletContext().getAttribute("messages");
        if (messages == null) {
            messages = new ArrayList<>();
        }
        
        synchronized (getServletContext()) {
            messages.add(formattedMessage);
            if (messages.size() > 100) {
                messages.remove(0);
            }
            getServletContext().setAttribute("messages", messages);
        }
        
        response.sendRedirect("chat.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("chat.jsp");
    }
}
