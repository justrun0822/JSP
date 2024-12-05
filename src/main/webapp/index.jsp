<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>HelloWorld</title>
</head>
<body bgcolor="#6495ed">
<br/>
<center>
    <h2>Hello World!</h2>
    <%
        out.println("This is my first JSP Page!");
        out.println("<br/>");
        out.println("Today is " + new java.util.Date());
    %>
</center>
</body>
</html>
