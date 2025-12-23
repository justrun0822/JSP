package com.ztq.servlet;

import com.ztq.entity.Message;
import com.ztq.service.MessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(ChatServlet.class);
    private static final int DEFAULT_PAGE_SIZE = 20;
    
    private MessageService messageService = new MessageService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        
        int page = 1;
        int pageSize = DEFAULT_PAGE_SIZE;
        
        try {
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
            if (pageSizeParam != null) {
                pageSize = Integer.parseInt(pageSizeParam);
            }
        } catch (NumberFormatException e) {
            logger.warn("页码参数错误: page={}, pageSize={}", pageParam, pageSizeParam);
        }
        
        // 确保参数合法
        page = Math.max(1, page);
        pageSize = Math.min(Math.max(10, pageSize), 50);
        
        List<Message> messages = messageService.getMessagesByPage(page, pageSize);
        int totalCount = messageService.getTotalCount();
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        request.setAttribute("messages", messages);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPages", totalPages);
        
        logger.debug("分页请求 - 页码: {}, 每页: {}, 总数: {}", page, pageSize, totalCount);
        
        request.getRequestDispatcher("/chat.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
