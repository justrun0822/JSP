# 数据库配置指南

本项目已集成 MySQL 数据库，用于持久化存储聊天消息和访客统计数据。

## 📋 环境要求

- **MySQL**: 5.7+ 或 8.0+（推荐）
- **Java**: JDK 8+
- **Maven**: 3.x

---

## 🚀 快速开始

### 1. 安装 MySQL

如果尚未安装 MySQL，请先安装：

**Windows:**
- 下载 MySQL Installer：https://dev.mysql.com/downloads/installer/
- 安装并设置 root 密码

**macOS:**
```bash
brew install mysql
brew services start mysql
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install mysql-server
sudo systemctl start mysql
```

---

### 2. 创建数据库和表

#### 方法一：使用提供的 SQL 脚本（推荐）

1. **登录 MySQL**
   ```bash
   mysql -u root -p
   ```

2. **执行初始化脚本**
   ```sql
   source src/main/resources/sql/init.sql
   ```
   
   或者在命令行直接执行：
   ```bash
   mysql -u root -p < src/main/resources/sql/init.sql
   ```

#### 方法二：手动创建

```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS jsp_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE jsp_db;

-- 聊天消息表
CREATE TABLE IF NOT EXISTS messages (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '消息ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    content TEXT NOT NULL COMMENT '消息内容',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_create_time (create_time DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聊天消息表';

-- 访客统计表
CREATE TABLE IF NOT EXISTS visitor_stats (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '统计ID',
    total_count BIGINT NOT NULL DEFAULT 0 COMMENT '总访客数',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='访客统计表';

-- 初始化访客统计数据
INSERT INTO visitor_stats (total_count) VALUES (0);
```

---

### 3. 配置数据库连接

编辑 `src/main/resources/db.properties` 文件，修改数据库连接信息：

```properties
# 数据库连接信息
db.url=jdbc:mysql://localhost:3306/jsp_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
db.username=root
db.password=你的密码
```

**重要参数说明：**
- `db.url`: 数据库连接地址，默认连接本地 MySQL 的 `jsp_db` 数据库
- `db.username`: 数据库用户名，默认为 `root`
- `db.password`: 数据库密码，**请修改为你的实际密码**

---

### 4. 验证配置

1. **启动项目**
   ```bash
   mvn clean package
   # 部署到 Tomcat
   ```

2. **检查日志**
   
   如果配置正确，启动时会看到：
   ```
   数据库连接池初始化成功
   ```

3. **测试功能**
   - 访问聊天室：`http://localhost:8080/JSP/chat.jsp`
   - 发送消息，刷新页面，消息应该持久化保存
   - 访问计数器：`http://localhost:8080/JSP/visitor`
   - 多次访问，计数应该递增

---

## 📊 数据库表结构

### messages 表（聊天消息）

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | BIGINT | 主键，自增 |
| username | VARCHAR(50) | 用户名 |
| content | TEXT | 消息内容（已 HTML 转义） |
| create_time | TIMESTAMP | 创建时间 |

**索引：**
- PRIMARY KEY (id)
- INDEX idx_create_time (create_time DESC)

### visitor_stats 表（访客统计）

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | INT | 主键，固定为 1 |
| total_count | BIGINT | 总访客数 |
| update_time | TIMESTAMP | 最后更新时间 |

---

## 🔧 连接池配置

项目使用 **HikariCP** 高性能连接池，默认配置：

```properties
# 最大连接数
db.pool.maximumPoolSize=10

# 最小空闲连接数
db.pool.minimumIdle=5

# 连接超时时间（毫秒）
db.pool.connectionTimeout=30000

# 空闲超时时间（毫秒）
db.pool.idleTimeout=600000

# 连接最大生命周期（毫秒）
db.pool.maxLifetime=1800000
```

可根据实际需求在 `db.properties` 中调整。

---

## 🛠️ 常见问题

### 1. 连接失败：Access denied for user 'root'@'localhost'

**原因**：数据库密码错误或用户权限不足

**解决方案**：
```sql
-- 重置 root 密码
ALTER USER 'root'@'localhost' IDENTIFIED BY '新密码';
FLUSH PRIVILEGES;

-- 授予权限
GRANT ALL PRIVILEGES ON jsp_db.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
```

### 2. 连接失败：Unknown database 'jsp_db'

**原因**：数据库未创建

**解决方案**：执行初始化脚本创建数据库

### 3. 时区错误：The server time zone value 'xxx' is unrecognized

**原因**：MySQL 8.0+ 需要明确指定时区

**解决方案**：已在连接字符串中添加 `serverTimezone=Asia/Shanghai`

### 4. SSL 警告

**原因**：MySQL 默认要求 SSL 连接

**解决方案**：已在连接字符串中添加 `useSSL=false`（开发环境）

生产环境建议启用 SSL：
```properties
db.url=jdbc:mysql://localhost:3306/jsp_db?useSSL=true&requireSSL=true
```

---

## 📈 性能优化建议

### 1. 数据库索引

已为高频查询字段创建索引：
- `messages.create_time` - 用于按时间排序查询

### 2. 连接池调优

根据并发量调整连接池大小：
- **低并发**（<10用户）：maximumPoolSize=5
- **中并发**（10-50用户）：maximumPoolSize=10（默认）
- **高并发**（50+用户）：maximumPoolSize=20

### 3. 定期清理旧数据

聊天消息默认保留最近 100 条，自动清理旧消息。

如需手动清理：
```sql
-- 删除 30 天前的消息
DELETE FROM messages WHERE create_time < DATE_SUB(NOW(), INTERVAL 30 DAY);
```

---

## 🔒 安全建议

### 1. 生产环境配置

- ✅ 使用强密码
- ✅ 创建专用数据库用户，不使用 root
- ✅ 限制数据库用户权限
- ✅ 启用 SSL 连接
- ✅ 定期备份数据

### 2. 创建专用用户

```sql
-- 创建专用用户
CREATE USER 'jsp_user'@'localhost' IDENTIFIED BY '强密码';

-- 授予必要权限
GRANT SELECT, INSERT, UPDATE, DELETE ON jsp_db.* TO 'jsp_user'@'localhost';

FLUSH PRIVILEGES;
```

然后修改 `db.properties`：
```properties
db.username=jsp_user
db.password=强密码
```

---

## 📦 数据备份与恢复

### 备份

```bash
# 备份整个数据库
mysqldump -u root -p jsp_db > jsp_db_backup.sql

# 仅备份数据（不含结构）
mysqldump -u root -p --no-create-info jsp_db > jsp_db_data.sql
```

### 恢复

```bash
# 恢复数据库
mysql -u root -p jsp_db < jsp_db_backup.sql
```

---

## 🧪 测试数据

如需添加测试数据：

```sql
USE jsp_db;

-- 添加测试消息
INSERT INTO messages (username, content) VALUES 
('测试用户1', '这是第一条测试消息'),
('测试用户2', '大家好！'),
('访客abc123', '测试消息内容');

-- 设置访客数
UPDATE visitor_stats SET total_count = 100 WHERE id = 1;
```

---

## 📚 相关文档

- [MySQL 官方文档](https://dev.mysql.com/doc/)
- [HikariCP 配置文档](https://github.com/brettwooldridge/HikariCP)
- [JDBC 教程](https://docs.oracle.com/javase/tutorial/jdbc/)

---

## ✅ 检查清单

部署前请确认：

- [ ] MySQL 已安装并运行
- [ ] 数据库 `jsp_db` 已创建
- [ ] 表 `messages` 和 `visitor_stats` 已创建
- [ ] `db.properties` 配置正确
- [ ] 数据库连接测试成功
- [ ] 聊天室可以正常发送和显示消息
- [ ] 访客计数器正常工作

---

**如遇到问题，请查看日志文件或联系项目维护者。**
