<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>显示信息</title>
</head>
<body>
<br/> 用户使用的协议:
<%
    String protocol = request.getProtocol();
    out.println(protocol);
%>
<br/> 获取接收客户提交信息的页面：
<%
    String path = request.getServletPath();
    out.println(path);
%>

<br/> 客户提交信息的长度:
<%
    int length = request.getContentLength();
    out.println(length);
%>
<br/> 用户提交信息的方法:
<%
    String method = request.getMethod();
    out.println(method);
%>

<br/> HTTP 头文件中的 user-agent:
<%
    String agent = request.getHeader("user-agent");
    out.println(agent);
%>

<br/> http 头文件中的 accept:
<%
    String accept = request.getHeader("accept");
    out.println(accept);
%>

<br/> HTTP 头文件中的 host:
<%
    String host = request.getHeader("Host");
    out.println(host);
%>

<br/> http 头文件中的accept-encoding:
<%
    String acceptEncoding = request.getHeader("accept-encoding");
    out.println(acceptEncoding);
%>

<br/> HTTP 头文件中的 cookie:
<%
    String cookie = request.getHeader("cookie");
    out.println(cookie);
%>
<br/> 获取客户提交信息的IP地址:
<%
    String ip = request.getRemoteAddr();
    out.println(ip);
%>

<br/> 获取客户提交信息的主机名:
<%
    String hostName = request.getRemoteHost();
    out.println(hostName);
%>

<br/> 获取客户提交信息的端口号:
<%
    int port = request.getRemotePort();
    out.println(port);
%>

<br/> 获取客户提交信息的端口号:
<%
    String queryString = request.getQueryString();
    out.println(queryString);
%>

<br> 文本框提交的信息:
<%
    String text = request.getParameter("text");
    out.println(text);
%>
</body>
</html>
