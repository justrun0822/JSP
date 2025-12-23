package com.ztq.dao;

import com.ztq.entity.Message;
import com.ztq.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {
    
    public boolean addMessage(Message message) {
        String sql = "INSERT INTO messages (username, content) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, message.getUsername());
            pstmt.setString(2, message.getContent());
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(pstmt, conn);
        }
    }
    
    public List<Message> getRecentMessages(int limit) {
        String sql = "SELECT id, username, content, create_time FROM messages ORDER BY create_time DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Message> messages = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getLong("id"));
                msg.setUsername(rs.getString("username"));
                msg.setContent(rs.getString("content"));
                msg.setCreateTime(rs.getTimestamp("create_time"));
                messages.add(msg);
            }
            
            java.util.Collections.reverse(messages);
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        
        return messages;
    }
    
    public int getMessageCount() {
        String sql = "SELECT COUNT(*) FROM messages";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        
        return 0;
    }
    
    public boolean deleteOldMessages(int keepCount) {
        String sql = "DELETE FROM messages WHERE id NOT IN " +
                    "(SELECT id FROM (SELECT id FROM messages ORDER BY create_time DESC LIMIT ?) AS tmp)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, keepCount);
            pstmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(pstmt, conn);
        }
    }
}
