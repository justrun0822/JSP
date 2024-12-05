<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
<html>
<head>
    <title>显示信息</title>
</head>
<body>
<br/> 用户使用的协议:
<%
    String protocol = request.getProtocol();
    out.println(protocol);
%>
<br/> 用户提交信息的方法:
<%
    String method = request.getMethod();
    out.println(method);
%>

<br> 文本框提交的信息:
<%
    String text = request.getParameter("text");
    out.println(text);
%>
</body>
</html>
