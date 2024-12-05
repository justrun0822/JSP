<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>ShowCurrentTime</title>
</head>
<body>
<h1>Show current time JSP Page</h1>
<font color="#dc143c">
<%-- 方式一 --%>
    <%--    <%--%>
    <%--        Date date = new Date();--%>
    <%--        out.println("Current time is " + date);--%>
    <%--    %>--%>

<%-- 方式二 --%>
    The current time is
    <%@ include file="getTime.jsp" %>
</font>
</body>
</html>
