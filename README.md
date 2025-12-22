# JSP 学习项目

一个基于 JSP/Servlet 的 Web 应用学习项目，展示了 JavaEE Web 开发的核心技术和最佳实践。

## 📋 项目简介

这是一个用于学习 JSP/Servlet 技术的示例项目，包含了多个常见的 Web 应用场景：
- 简易聊天室
- 访客计数器
- 时间显示
- 表单处理
- 用户注册

项目经过全面优化，采用 MVC 架构、JSTL 标签库、安全防护等现代 Web 开发最佳实践。

## ✨ 主要功能

### 1. 💬 简易聊天室
- 实时发送和显示消息
- 自动生成访客用户名
- 消息 XSS 防护
- 输入验证（长度限制、非空检查）
- 最多保留 100 条历史消息

### 2. 👥 访客计数器
- 统计网站访问人数
- 线程安全的计数实现
- 持久化存储（application 作用域）

### 3. ⏰ 时间显示
- 显示当前系统时间
- JSTL 日期格式化
- 清晰的时间展示界面

### 4. 📝 表单处理
- Request 对象属性展示
- HTTP 请求信息获取
- 表单数据处理

### 5. 📋 用户注册
- 完整的注册表单
- 前端验证（JavaScript）
- 响应式设计

## 🛠️ 技术栈

### 后端技术
- **Java**: JDK 8+
- **Servlet API**: 4.0.1
- **JSP**: 2.3
- **JSTL**: 1.2
- **Apache Commons Text**: 1.10.0（XSS 防护）

### 构建工具
- **Maven**: 3.x

### 开发工具
- **IDE**: IntelliJ IDEA / Eclipse / VS Code
- **服务器**: Tomcat 8.5+ / Tomcat 9+

## 📦 项目结构

```
JSP/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/ztq/
│       │       ├── servlet/
│       │       │   └── MessageServlet.java      # 聊天室业务逻辑
│       │       └── filter/
│       │           └── EncodingFilter.java      # 字符编码过滤器
│       ├── resources/                           # 资源文件（空）
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml                      # Web 应用配置
│           ├── error/
│           │   ├── 404.jsp                      # 404 错误页面
│           │   └── 500.jsp                      # 500 错误页面
│           ├── index.jsp                        # 首页（导航页）
│           ├── chat.jsp                         # 聊天室
│           ├── CountUsers.jsp                   # 访客计数器
│           ├── ShowCurrentTime.jsp              # 时间显示
│           ├── getTime.jsp                      # 时间获取模块
│           ├── form.jsp                         # 表单页面
│           ├── request.jsp                      # Request 对象演示
│           └── register.html                    # 注册表单
├── pom.xml                                      # Maven 配置
├── .gitignore                                   # Git 忽略配置
├── OPTIMIZATION_SUMMARY.md                      # 优化说明文档
└── README.md                                    # 项目说明（本文件）
```

## 🚀 快速开始

### 环境要求

- **JDK**: 8 或更高版本
- **Maven**: 3.x
- **Tomcat**: 8.5+ 或 9.x
- **IDE**: IntelliJ IDEA / Eclipse（推荐）

### 安装步骤

#### 1. 克隆项目
```bash
git clone https://github.com/justrun0822/JSP.git
cd JSP
```

#### 2. 使用 Maven 构建
```bash
mvn clean package
```

#### 3. 部署到 Tomcat

**方法一：IDE 部署（推荐）**

**IntelliJ IDEA:**
1. 打开项目
2. 配置 Tomcat 服务器：`Run` → `Edit Configurations` → `+` → `Tomcat Server` → `Local`
3. 配置部署：`Deployment` 标签 → `+` → `Artifact` → 选择 `JSP:war exploded`
4. 点击 `Run` 启动

**Eclipse:**
1. 右键项目 → `Run As` → `Run on Server`
2. 选择 Tomcat 服务器
3. 完成配置并启动

**方法二：手动部署**
```bash
# 将生成的 WAR 文件复制到 Tomcat webapps 目录
cp target/JSP.war $TOMCAT_HOME/webapps/

# 启动 Tomcat
$TOMCAT_HOME/bin/startup.sh   # Linux/Mac
$TOMCAT_HOME/bin/startup.bat  # Windows
```

#### 4. 访问应用
打开浏览器访问：`http://localhost:8080/JSP/`

## 📖 使用说明

### 首页导航
访问首页后，可以看到五个功能模块的导航卡片，点击即可进入相应功能。

### 聊天室使用
1. 访问 `http://localhost:8080/JSP/chat.jsp`
2. 在输入框中输入消息（最多 500 字）
3. 点击"发送"按钮
4. 消息会立即显示在聊天记录中
5. 系统会自动为你分配一个访客用户名

### 访客计数器
- 每次访问 `CountUsers.jsp` 页面，计数器会自动加 1
- 计数器是线程安全的，支持多用户并发访问

## 🎯 技术亮点

### 1. MVC 架构模式
- **Model**: JavaBean 和业务逻辑
- **View**: JSP 页面（使用 JSTL）
- **Controller**: Servlet 处理请求

### 2. JSTL 标签库
- 使用 `<c:forEach>`, `<c:if>`, `<c:out>` 等标签
- 完全替代 Java scriptlet `<% %>`
- 代码更清晰、更易维护

### 3. 安全防护
- **XSS 防护**: 使用 Apache Commons Text 转义 HTML
- **输入验证**: 服务端验证消息长度和内容
- **线程安全**: synchronized 同步块保护共享资源

### 4. 统一字符编码
- EncodingFilter 过滤器统一处理 UTF-8 编码
- 避免中文乱码问题

### 5. 错误处理
- 自定义 404/500 错误页面
- 友好的错误提示
- 统一的错误处理机制

### 6. Session 管理
- 自动生成访客用户名
- Session 超时设置（30 分钟）
- 用户状态持久化

## 📚 学习要点

通过这个项目，你可以学习到：

1. ✅ **JSP 基础语法**：指令、动作、表达式语言（EL）
2. ✅ **Servlet 开发**：请求处理、响应生成、生命周期
3. ✅ **JSTL 标签库**：核心标签、格式化标签
4. ✅ **过滤器（Filter）**：请求拦截、字符编码处理
5. ✅ **会话管理**：Session 使用、作用域管理
6. ✅ **MVC 架构**：分层设计、职责分离
7. ✅ **安全防护**：XSS 防护、输入验证
8. ✅ **线程安全**：并发控制、同步机制
9. ✅ **Maven 构建**：依赖管理、项目构建
10. ✅ **Web 配置**：web.xml 配置、欢迎页、错误页

## 🔧 配置说明

### Maven 依赖
```xml
<dependencies>
    <!-- Servlet API -->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>4.0.1</version>
        <scope>provided</scope>
    </dependency>
    
    <!-- JSTL -->
    <dependency>
        <groupId>javax.servlet.jsp.jstl</groupId>
        <artifactId>jstl-api</artifactId>
        <version>1.2</version>
    </dependency>
    
    <!-- Apache Commons Text (XSS 防护) -->
    <dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-text</artifactId>
        <version>1.10.0</version>
    </dependency>
</dependencies>
```

### web.xml 配置
- 字符编码过滤器：统一 UTF-8 编码
- Session 超时：30 分钟
- 欢迎页面：index.jsp, chat.jsp
- 错误页面：404.jsp, 500.jsp

## 🐛 已知限制

1. **数据持久化**：聊天消息和访客计数存储在内存中，服务器重启后会丢失
2. **用户认证**：没有真正的登录系统，使用临时的访客用户名
3. **实时通信**：聊天室需要手动刷新才能看到新消息（未使用 WebSocket）
4. **消息搜索**：不支持历史消息搜索
5. **图片上传**：不支持发送图片或文件

## 🔮 未来优化方向

### 短期计划
- [ ] 数据库集成（MySQL/H2）
- [ ] 用户登录/注册系统
- [ ] 提取 CSS 到独立文件
- [ ] 消息分页显示
- [ ] 添加单元测试

### 长期计划
- [ ] WebSocket 实时通信
- [ ] 前后端分离（RESTful API + Vue.js）
- [ ] 升级到 Spring Boot
- [ ] Redis 缓存集成
- [ ] 私信功能
- [ ] 图片上传和预览

## 📝 开发日志

### 2025-12-22 - 项目全面优化
- 修复 CountUsers.jsp 代码错误和线程安全问题
- 创建 MessageServlet 实现 MVC 架构
- 使用 JSTL 重构所有 JSP 页面
- 添加 XSS 防护和输入验证
- 创建字符编码过滤器
- 添加 404/500 错误页面
- 优化 UI 设计
- 完善 .gitignore 配置
- 编写优化文档

### 2024-12-09 - 项目创建
- 初始化项目结构
- 实现基础功能模块

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

### 提交规范
```
feat: 新功能
fix: 修复 bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具相关
```

## 📄 许可证

本项目仅用于学习交流，未指定开源许可证。

## 👨‍💻 作者

- **作者**: com.ztq
- **GitHub**: [@justrun0822](https://github.com/justrun0822)
- **项目地址**: [https://github.com/justrun0822/JSP](https://github.com/justrun0822/JSP)

## 🙏 致谢

感谢所有为 Java Web 技术做出贡献的开发者！

---

**⭐ 如果这个项目对你有帮助，欢迎 Star！**
