<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Request 对象信息展示</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
        }
        .info-section {
            margin-bottom: 30px;
        }
        .section-title {
            background-color: #667eea;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 10px;
        }
        .info-item {
            background-color: #f8f9fa;
            padding: 12px;
            border-radius: 5px;
            border-left: 3px solid #667eea;
        }
        .info-label {
            font-weight: bold;
            color: #333;
            display: inline-block;
            min-width: 180px;
        }
        .info-value {
            color: #555;
            word-break: break-all;
        }
        .highlight {
            background-color: #fff3cd;
            border-left-color: #ffc107;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .back-link:hover {
            background-color: #5568d3;
        }
        .empty-value {
            color: #999;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Request 对象信息展示</h1>
        <p class="subtitle">HTTP 请求的详细信息</p>
        
        <!-- 基本请求信息 -->
        <div class="info-section">
            <div class="section-title">🔹 基本请求信息</div>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">协议版本：</span>
                    <span class="info-value"><c:out value="${pageContext.request.protocol}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">请求方法：</span>
                    <span class="info-value"><c:out value="${pageContext.request.method}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">请求路径：</span>
                    <span class="info-value"><c:out value="${pageContext.request.servletPath}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">内容长度：</span>
                    <span class="info-value">${pageContext.request.contentLength} 字节</span>
                </div>
                <div class="info-item">
                    <span class="info-label">查询字符串：</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${not empty pageContext.request.queryString}">
                                <c:out value="${pageContext.request.queryString}"/>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-value">无</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
        
        <!-- HTTP 头信息 -->
        <div class="info-section">
            <div class="section-title">🔹 HTTP 请求头信息</div>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Host：</span>
                    <span class="info-value"><c:out value="${header.host}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">User-Agent：</span>
                    <span class="info-value"><c:out value="${header['user-agent']}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Accept：</span>
                    <span class="info-value"><c:out value="${header.accept}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Accept-Encoding：</span>
                    <span class="info-value"><c:out value="${header['accept-encoding']}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Accept-Language：</span>
                    <span class="info-value"><c:out value="${header['accept-language']}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Cookie：</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${not empty header.cookie}">
                                <c:out value="${header.cookie}"/>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-value">无</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
        
        <!-- 客户端信息 -->
        <div class="info-section">
            <div class="section-title">🔹 客户端信息</div>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">客户端 IP 地址：</span>
                    <span class="info-value"><c:out value="${pageContext.request.remoteAddr}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">客户端主机名：</span>
                    <span class="info-value"><c:out value="${pageContext.request.remoteHost}"/></span>
                </div>
                <div class="info-item">
                    <span class="info-label">客户端端口号：</span>
                    <span class="info-value">${pageContext.request.remotePort}</span>
                </div>
            </div>
        </div>
        
        <!-- 表单提交信息 -->
        <div class="info-section">
            <div class="section-title">🔹 表单提交的数据</div>
            <div class="info-grid">
                <div class="info-item highlight">
                    <span class="info-label">文本框内容：</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${not empty param.text}">
                                <c:out value="${param.text}"/>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-value">（未提交或为空）</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
        
        <a href="form.jsp" class="back-link">← 返回表单页面</a>
        <a href="index.jsp" class="back-link" style="margin-left: 10px;">🏠 返回首页</a>
    </div>
</body>
</html>
