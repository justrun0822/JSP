# WebSocket 实时聊天功能说明

本文档介绍项目中新增的 WebSocket 实时聊天功能。

---

## 📋 功能概述

**WebSocket 实时聊天** 是对原有 Ajax 轮询聊天室的重大升级，实现了真正的实时双向通信。

### 主要特性

1. **✅ 实时通信** - 无需刷新，消息即时送达
2. **✅ 在线状态** - 实时显示在线人数
3. **✅ 输入提示** - 显示其他用户正在输入
4. **✅ 自动重连** - 断线后自动尝试重连
5. **✅ 系统消息** - 用户加入/离开提示
6. **✅ 持久化存储** - 消息保存到数据库

---

## 🏗️ 技术架构

### 后端技术栈

- **WebSocket API** (javax.websocket 1.1)
- **Gson** 2.10.1 (JSON 序列化)
- **SLF4J + Logback** (日志)
- **MySQL** (消息持久化)

### 前端技术栈

- **原生 WebSocket API**
- **JavaScript ES6+**
- **CSS3 动画**

### 架构图

```
客户端 (Browser)
    ↕ WebSocket 连接
服务端 (Tomcat)
    ↓
ChatWebSocket 端点
    ↓
MessageService → MessageDAO → MySQL
```

---

## 📂 文件结构

### 后端文件

```
com.ztq.websocket/
├── ChatWebSocket.java          # WebSocket 端点类
├── WebSocketMessage.java       # 消息实体类
└── WebSocketConfig.java        # WebSocket 配置类
```

### 前端文件

```
webapp/
├── chat-realtime.jsp           # 实时聊天页面
└── js/
    └── websocket-chat.js       # WebSocket 客户端
```

---

## 🔧 核心实现

### 1. WebSocket 端点

**文件:** `ChatWebSocket.java`

**注解:** `@ServerEndpoint(value = "/websocket/chat")`

**关键方法:**
- `@OnOpen` - 连接建立
- `@OnMessage` - 接收消息
- `@OnClose` - 连接关闭
- `@OnError` - 错误处理

**功能:**
- 管理所有活跃连接
- 处理聊天消息、输入状态
- 广播消息给所有客户端
- 维护在线用户列表

### 2. 消息类型

**WebSocketMessage 支持的消息类型:**

| 类型 | 方向 | 说明 |
|------|------|------|
| `message` | 双向 | 聊天消息 |
| `join` | 服务端→客户端 | 用户加入 |
| `leave` | 服务端→客户端 | 用户离开 |
| `online` | 服务端→客户端 | 在线人数更新 |
| `typing` | 客户端→服务端 | 正在输入 |
| `stop_typing` | 双向 | 停止输入 |

### 3. 消息格式

**发送消息 (客户端→服务端):**
```json
{
  "type": "message",
  "content": "Hello, World!"
}
```

**接收消息 (服务端→客户端):**
```json
{
  "type": "message",
  "username": "test123",
  "content": "Hello, World!",
  "userId": 1,
  "timestamp": "14:30:25"
}
```

### 4. 连接管理

**存储结构:**
```java
// 所有活跃连接
CopyOnWriteArraySet<ChatWebSocket> clients

// 用户名→Session 映射
ConcurrentHashMap<String, Session> userSessions

// 正在输入的用户
CopyOnWriteArraySet<String> typingUsers
```

**线程安全:**
- 使用并发集合类
- 同步发送消息
- 原子操作更新状态

---

## 🚀 使用指南

### 访问实时聊天室

1. 启动应用
2. 访问: `http://localhost:8080/JSP/chat-realtime.jsp`
3. 自动建立 WebSocket 连接

### 发送消息

1. 在输入框输入文本
2. 按 **Enter** 发送
3. 消息即时显示在所有客户端

### 查看在线人数

- 右上角显示实时在线人数
- 绿色徽章带动画效果

### 输入中提示

1. 开始输入时，其他用户看到 "XXX 正在输入..."
2. 停止输入 1 秒后自动取消提示

---

## 🔄 自动重连机制

### 重连策略

- **最大重连次数:** 5 次
- **重连延迟:** 指数退避算法
  - 第 1 次: 2 秒
  - 第 2 次: 4 秒
  - 第 3 次: 8 秒
  - 第 4 次: 16 秒
  - 第 5 次: 30 秒（上限）

### 连接状态显示

- 🟢 **已连接** - 绿色，连接正常
- 🔴 **连接已断开** - 红色，连接断开
- 🟡 **重连中...** - 黄色，正在重连

---

## 📊 性能优化

### 1. 消息广播优化

```java
// 并发发送，避免阻塞
for (ChatWebSocket client : clients) {
    synchronized (client.session) {
        if (client.session.isOpen()) {
            client.session.getBasicRemote().sendText(message);
        }
    }
}
```

### 2. 输入状态防抖

```javascript
// 1秒内多次输入只发送一次
const TYPING_TIMER_LENGTH = 1000;
clearTimeout(typingTimer);
typingTimer = setTimeout(() => {
    sendStopTyping();
}, TYPING_TIMER_LENGTH);
```

### 3. 数据库异步写入

- 消息先广播给所有客户端（快速响应）
- 然后异步保存到数据库（持久化）

---

## 🔒 安全措施

### 1. XSS 防护

**后端:**
```java
content = StringEscapeUtils.escapeHtml4(content);
```

**前端:**
```javascript
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
```

### 2. 输入验证

- 消息长度限制: 500 字符
- 非空检查
- 连接状态检查

### 3. 会话管理

- HTTP Session 与 WebSocket Session 关联
- 用户身份验证
- 自动超时清理

---

## 🐛 常见问题

### 1. WebSocket 连接失败

**可能原因:**
- Tomcat 版本过低（需要 8.5+）
- 防火墙阻止 WebSocket
- 代理服务器不支持

**解决方案:**
```bash
# 检查 Tomcat 版本
./catalina.sh version

# 确保 WebSocket API 存在
ls -l lib/websocket-api.jar
```

### 2. 消息发送失败

**错误信息:** "连接已断开，请稍后重试"

**解决方案:**
- 检查网络连接
- 等待自动重连
- 刷新页面重新连接

### 3. 无法看到其他用户消息

**可能原因:**
- 连接未建立成功
- 消息广播失败
- 浏览器控制台有错误

**调试方法:**
```javascript
// 打开浏览器控制台查看日志
console.log('WebSocket 状态:', ws.readyState);
// 0=CONNECTING, 1=OPEN, 2=CLOSING, 3=CLOSED
```

### 4. 输入中提示不显示

**检查项:**
- JavaScript 是否加载成功
- 输入框事件是否绑定
- WebSocket 连接是否正常

---

## 📈 对比分析

### WebSocket vs Ajax 轮询

| 特性 | WebSocket | Ajax 轮询 |
|------|-----------|----------|
| **实时性** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **性能** | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| **服务器负载** | 低 | 高 |
| **网络流量** | 低 | 高 |
| **延迟** | <100ms | 2-5秒 |
| **电量消耗** | 低 | 中 |
| **实现复杂度** | 中 | 低 |

### 性能数据

**WebSocket:**
- 建立连接: 1 次 HTTP 握手
- 消息传输: 2-6 字节头部
- 延迟: 通常 <50ms

**Ajax 轮询 (3秒间隔):**
- 每次请求: 完整 HTTP 请求/响应
- 消息传输: ~500 字节头部
- 延迟: 0-3 秒

---

## 🔧 配置说明

### 修改 WebSocket 路径

**文件:** `ChatWebSocket.java`
```java
@ServerEndpoint(value = "/websocket/chat") // 修改路径
```

**前端同步修改:** `websocket-chat.js`
```javascript
const wsUrl = `${protocol}//${host}${contextPath}/websocket/chat`;
```

### 调整在线用户存储

**使用 Redis (可选):**
```java
// 替换 ConcurrentHashMap
RedisTemplate<String, Session> userSessions;
```

### 修改重连参数

**文件:** `websocket-chat.js`
```javascript
const MAX_RECONNECT_ATTEMPTS = 5;    // 最大重连次数
const TYPING_TIMER_LENGTH = 1000;    // 输入提示延迟(ms)
```

---

## 🚀 扩展建议

### 1. 私聊功能

```java
// 点对点消息发送
public void sendToUser(String username, String message) {
    Session session = userSessions.get(username);
    if (session != null && session.isOpen()) {
        session.getBasicRemote().sendText(message);
    }
}
```

### 2. 聊天室房间

```java
// 多房间支持
@ServerEndpoint(value = "/websocket/chat/{roomId}")
public class ChatWebSocket {
    @PathParam("roomId") String roomId;
    // ...
}
```

### 3. 消息撤回

```java
// 添加消息 ID
WebSocketMessage deleteMsg = new WebSocketMessage("delete", username, messageId);
```

### 4. 文件传输

```java
// 支持二进制消息
@OnMessage
public void onBinaryMessage(ByteBuffer data, Session session) {
    // 处理文件上传
}
```

### 5. 表情和富文本

```javascript
// 解析 Markdown 或 Emoji
content = parseMarkdown(content);
content = parseEmoji(content);
```

---

## 📚 相关文档

- [WebSocket API 规范](https://www.oracle.com/technical-resources/articles/java/jsr356.html)
- [Tomcat WebSocket 文档](https://tomcat.apache.org/tomcat-8.5-doc/websocketapi/index.html)
- [MDN WebSocket API](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket)

---

## 🎯 最佳实践

### 1. 错误处理

```java
try {
    session.getBasicRemote().sendText(message);
} catch (IOException e) {
    logger.error("发送失败", e);
    clients.remove(this); // 移除失败的连接
}
```

### 2. 内存管理

```java
// 定期清理断开的连接
@Scheduled(fixedRate = 60000) // 每分钟
public void cleanupSessions() {
    clients.removeIf(client -> !client.session.isOpen());
}
```

### 3. 日志记录

```java
logger.info("用户 {} 连接 - SessionId: {}", username, sessionId);
logger.debug("收到消息 - 类型: {}, 长度: {}", type, content.length());
logger.error("处理失败", exception);
```

### 4. 监控指标

- 在线人数
- 消息吞吐量
- 平均延迟
- 错误率
- 连接时长

---

**文档版本:** 1.0.0  
**更新日期:** 2025-12-23  
**作者:** JSP 学习项目团队
