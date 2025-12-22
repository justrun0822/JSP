<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>访客计数</title>
</head>
<body align="center">
<font color="#6495ed" size="15">
    <%
        synchronized(application) {
            Integer count = (Integer) application.getAttribute("visitorCount");
            if (count == null) {
                count = 0;
            }
            count++;
            application.setAttribute("visitorCount", count);
            
            out.println("Total number of visitors : " + count);
    %>
    <br/>
    您是本站第<%=count%>位访客！
    <%
        }
    %>
</font>

</body>
</html>
