<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>访客计数</title>
</head>
<body align="center">
<font color="#6495ed" size="15">
    <%-- 声明为全局变量 --%>
    <%!
        int count = 0;
0
        void accessCount() {
            count++;
        }
    %>
    <%
        accessCount();
    %>
    <%
        out.println("Total number of visitors : " + count);
    %>
    <br/>
    您是本站第<%=count%>位访客！
    <%
        int MAX = 10;
        if (count == MAX) {
            count = 0;
        }
    %>
</font>

</body>
</html>
