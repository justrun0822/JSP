<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // 获取用户输入的消息
    String message = request.getParameter("message");

    // 获取现有的聊天记录（如果有）
    List<String> messages = (List<String>) application.getAttribute("messages");
    if (messages == null) {
        messages = new ArrayList<>();
    }

    // 将新消息添加到聊天记录
    messages.add(message);

    // 将更新后的聊天记录存储回application对象
    application.setAttribute("messages", messages);

    // 重定向回聊天页面
    response.sendRedirect("chat.jsp");
%>
