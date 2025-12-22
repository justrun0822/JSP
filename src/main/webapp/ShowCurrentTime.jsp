<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>显示当前时间</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }
        .time-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 0 auto;
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .time-display {
            font-size: 24px;
            color: #dc143c;
            text-align: center;
            margin: 20px 0;
            padding: 20px;
            background-color: #fff5f5;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="time-container">
    <h1>显示当前时间</h1>
    <div class="time-display">
        <jsp:useBean id="now" class="java.util.Date"/>
        当前时间是: <fmt:formatDate value="${now}" pattern="yyyy年MM月dd日 HH:mm:ss"/>
    </div>
</div>
</body>
</html>
