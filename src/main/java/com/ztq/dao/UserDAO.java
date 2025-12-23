package com.ztq.dao;

import com.ztq.entity.User;
import com.ztq.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class UserDAO {
    
    private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);
    
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            
            int rows = pstmt.executeUpdate();
            logger.debug("插入用户记录，影响行数: {}", rows);
            return rows > 0;
            
        } catch (SQLException e) {
            logger.error("添加用户失败", e);
            return false;
        } finally {
            DBUtil.close(pstmt, conn);
        }
    }
    
    public User getUserById(Long id) {
        String sql = "SELECT id, username, password, email, create_time, last_login_time FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
            
        } catch (SQLException e) {
            logger.error("根据ID查询用户失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        
        return null;
    }
    
    public User getUserByUsername(String username) {
        String sql = "SELECT id, username, password, email, create_time, last_login_time FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
            
        } catch (SQLException e) {
            logger.error("根据用户名查询用户失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        
        return null;
    }
    
    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            logger.error("检查用户名是否存在失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        
        return false;
    }
    
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            logger.error("检查邮箱是否存在失败", e);
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        
        return false;
    }
    
    public boolean updateLastLogin(Long userId) {
        String sql = "UPDATE users SET last_login_time = CURRENT_TIMESTAMP WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, userId);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            logger.error("更新最后登录时间失败", e);
            return false;
        } finally {
            DBUtil.close(pstmt, conn);
        }
    }
    
    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setCreateTime(rs.getTimestamp("create_time"));
        user.setLastLoginTime(rs.getTimestamp("last_login_time"));
        return user;
    }
}
