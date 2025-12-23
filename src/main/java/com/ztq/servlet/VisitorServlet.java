package com.ztq.servlet;

import com.ztq.dao.VisitorDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/visitor")
public class VisitorServlet extends HttpServlet {
    
    private VisitorDAO visitorDAO = new VisitorDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        long count = visitorDAO.incrementAndGetCount();
        
        request.setAttribute("visitorCount", count);
        
        request.getRequestDispatcher("/CountUsers.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
