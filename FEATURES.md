# 新功能说明文档

本次更新添加了日志系统、Service 层、用户登录注册、消息分页和 JavaScript 增强功能。

---

## 🆕 新增功能

### 1. 📝 日志系统（Logback）

**功能描述：**
- 集成 SLF4J + Logback 日志框架
- 分级日志输出（DEBUG/INFO/WARN/ERROR）
- 控制台和文件双输出
- 按日期自动滚动日志文件

**日志配置：**
- 日志文件位置：`logs/jsp-app.log`（INFO 及以上）
- 错误日志：`logs/jsp-error.log`（仅 ERROR）
- 日志保留：30 天
- 项目包日志级别：DEBUG

**使用示例：**
```java
private static final Logger logger = LoggerFactory.getLogger(XXX.class);
logger.info("用户 {} 登录成功", username);
logger.error("数据库操作失败", exception);
```

---

### 2. 🏗️ Service 层架构

**功能描述：**
- 引入 Service 层实现 MVC 三层架构
- Controller（Servlet）→ Service → DAO
- 业务逻辑与数据访问分离

**新增 Service 类：**

**MessageService：**
- `saveMessage(username, content)` - 保存消息
- `getRecentMessages(limit)` - 获取最近消息
- `getMessagesByPage(page, pageSize)` - 分页查询
- `getTotalCount()` - 获取消息总数
- 自动清理旧消息（保留最近 100 条）

**VisitorService：**
- `incrementVisitorCount()` - 访客计数增加
- `getTotalVisitors()` - 获取访客总数

**UserService：**
- `register(username, password, email)` - 用户注册
- `login(username, password)` - 用户登录
- `getUserById(id)` - 根据 ID 获取用户
- `getUserByUsername(username)` - 根据用户名获取用户
- 密码使用 BCrypt 加密存储

---

### 3. 👤 用户登录/注册系统

**功能描述：**
- 完整的用户注册和登录功能
- 密码 BCrypt 加密存储
- Session 会话管理
- "记住我"功能（7天）

**数据库表：users**
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_time TIMESTAMP NULL
);
```

**新增页面：**
- `/register` - 用户注册页面
- `/login` - 用户登录页面
- `/logout` - 退出登录

**表单验证：**
- 用户名：3-20位字母、数字或下划线
- 密码：至少6位字符
- 邮箱：标准邮箱格式验证
- 实时密码一致性检查

**登录后功能：**
- 聊天室显示真实用户名
- 退出登录按钮
- Session 持久化用户信息

---

### 4. 📄 消息分页功能

**功能描述：**
- 支持消息分页浏览
- 可自定义每页显示数量（10-50条）
- 页码导航（上一页/下一页/跳转）

**新增 Servlet：**
- `ChatServlet (/chat)` - 处理分页请求

**分页参数：**
- `page` - 页码（默认1）
- `pageSize` - 每页条数（默认20）

**使用示例：**
```
/chat?page=2&pageSize=20
```

**DAO 新增方法：**
```java
List<Message> getMessagesByPage(int page, int pageSize)
```

---

### 5. 🎨 JavaScript 增强功能

**功能描述：**
- Ajax 自动刷新（3秒间隔）
- 实时字符计数
- Enter 发送，Shift+Enter 换行
- 表单实时验证
- 发送后自动清空输入框

**JavaScript 文件：**
- `/js/chat.js` - 聊天室增强脚本

**主要功能：**

**1. Ajax 自动刷新**
```javascript
toggleAutoRefresh() // 开启/关闭自动刷新
startAutoRefresh()  // 启动定时刷新
stopAutoRefresh()   // 停止刷新
refreshMessages()   // 刷新消息列表
```

**2. 实时字符计数**
- 显示当前字符数 / 最大字符数
- 接近上限时红色警告
- 超过上限时阻止提交

**3. 表单验证**
- 用户名格式实时检查
- 密码一致性实时验证
- 邮箱格式验证

**4. 键盘快捷键**
- Enter：发送消息
- Shift + Enter：换行

---

## 📊 架构改进

### 原架构（二层）
```
Controller (Servlet) → DAO → Database
```

### 新架构（三层）
```
Controller (Servlet) → Service → DAO → Database
```

**优势：**
- ✅ 业务逻辑集中在 Service 层
- ✅ Servlet 只负责请求响应
- ✅ DAO 只负责数据访问
- ✅ 便于单元测试
- ✅ 代码复用性更高

---

## 🔧 技术栈更新

### 新增依赖

**日志框架：**
- SLF4J API 2.0.9
- Logback Classic 1.4.11

**密码加密：**
- jBCrypt 0.4

**总依赖列表：**
```xml
<dependencies>
    <!-- Servlet API -->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>4.0.1</version>
    </dependency>
    
    <!-- JSTL -->
    <dependency>
        <groupId>javax.servlet.jsp.jstl</groupId>
        <artifactId>jstl-api</artifactId>
        <version>1.2</version>
    </dependency>
    
    <!-- Apache Commons Text (XSS) -->
    <dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-text</artifactId>
        <version>1.10.0</version>
    </dependency>
    
    <!-- MySQL Driver -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.33</version>
    </dependency>
    
    <!-- HikariCP -->
    <dependency>
        <groupId>com.zaxxer</groupId>
        <artifactId>HikariCP</artifactId>
        <version>5.0.1</version>
    </dependency>
    
    <!-- SLF4J + Logback -->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>2.0.9</version>
    </dependency>
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.4.11</version>
    </dependency>
    
    <!-- BCrypt -->
    <dependency>
        <groupId>org.mindrot</groupId>
        <artifactId>jbcrypt</artifactId>
        <version>0.4</version>
    </dependency>
</dependencies>
```

---

## 📝 使用指南

### 用户注册流程

1. 访问 `/register`
2. 填写用户名、邮箱、密码
3. 实时验证表单
4. 提交注册
5. 跳转到登录页

### 用户登录流程

1. 访问 `/login`
2. 输入用户名和密码
3. 可选"记住我"（7天）
4. 登录成功跳转到聊天室

### 聊天室使用

**未登录用户：**
- 可以查看消息
- 可以发送消息（显示为"访客XXX"）
- 提示登录以使用完整功能

**已登录用户：**
- 显示真实用户名
- 所有功能可用
- 显示退出按钮

**Ajax 自动刷新：**
- 点击"开启自动刷新"按钮
- 每3秒自动刷新消息
- 再次点击停止刷新

**消息分页：**
- 超过20条消息自动分页
- 点击页码快速跳转
- 显示总消息数和当前页

---

## 🔍 日志查看

### 查看应用日志
```bash
tail -f logs/jsp-app.log
```

### 查看错误日志
```bash
tail -f logs/jsp-error.log
```

### 日志示例
```
2025-12-23 09:45:01.123 [http-nio-8080-exec-1] INFO  c.z.s.UserService - 用户注册 - 用户名: test123, 邮箱: test@example.com
2025-12-23 09:45:02.456 [http-nio-8080-exec-2] INFO  c.z.s.UserService - 用户登录成功: test123
2025-12-23 09:45:05.789 [http-nio-8080-exec-3] INFO  c.z.s.MessageService - 保存消息 - 用户: test123, 内容长度: 15
```

---

## ⚙️ 配置说明

### Logback 配置

编辑 `src/main/resources/logback.xml`：

```xml
<!-- 修改日志级别 -->
<logger name="com.ztq" level="DEBUG" />

<!-- 修改日志保留天数 -->
<maxHistory>30</maxHistory>
```

### Session 配置

编辑 `src/main/resources/web.xml`：

```xml
<session-config>
    <session-timeout>30</session-timeout> <!-- 30分钟 -->
</session-config>
```

---

## 🐛 常见问题

### 1. 用户名或邮箱已存在

**错误信息：** "用户名或邮箱已存在"

**解决方案：**
- 更换用户名
- 使用不同的邮箱地址

### 2. 密码太短

**错误信息：** "密码长度不能少于6位"

**解决方案：**
- 使用至少6位字符的密码

### 3. Ajax 刷新不工作

**可能原因：**
- 浏览器禁用 JavaScript
- 网络连接问题

**解决方案：**
- 启用 JavaScript
- 检查网络连接
- 手动刷新页面

### 4. 日志文件权限错误

**错误信息：** "无法创建日志文件"

**解决方案：**
```bash
mkdir -p logs
chmod 755 logs
```

---

## 📈 性能优化建议

### 1. 消息分页
- 默认每页20条，可调整为10-50
- 避免一次加载过多消息

### 2. Ajax 刷新间隔
- 默认3秒，可根据需要调整
- 建议不少于2秒

### 3. 日志级别
- 生产环境建议使用 INFO 级别
- 开发环境可使用 DEBUG 级别

### 4. Session 超时
- 默认30分钟
- 根据实际需求调整

---

## 🔐 安全说明

### 密码安全
- 使用 BCrypt 加密存储
- 盐值自动生成
- 不可逆加密

### XSS 防护
- 消息内容 HTML 转义
- JSTL `<c:out>` 输出

### SQL 注入防护
- PreparedStatement 参数化查询
- 输入验证

### Session 安全
- HttpOnly Cookie
- Session 超时
- 安全的 Session ID

---

## 📚 相关文档

- [README.md](README.md) - 项目总览
- [DATABASE_SETUP.md](DATABASE_SETUP.md) - 数据库配置
- [OPTIMIZATION_SUMMARY.md](OPTIMIZATION_SUMMARY.md) - 优化历史

---

**更新日期：** 2025-12-23  
**版本：** 2.0.0
