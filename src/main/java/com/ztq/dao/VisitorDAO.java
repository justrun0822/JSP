package com.ztq.dao;

import com.ztq.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VisitorDAO {
    
    public long incrementAndGetCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            String updateSql = "UPDATE visitor_stats SET total_count = total_count + 1 WHERE id = 1";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.executeUpdate();
            pstmt.close();
            
            String selectSql = "SELECT total_count FROM visitor_stats WHERE id = 1";
            pstmt = conn.prepareStatement(selectSql);
            rs = pstmt.executeQuery();
            
            long count = 0;
            if (rs.next()) {
                count = rs.getLong("total_count");
            }
            
            conn.commit();
            return count;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return -1;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            DBUtil.close(rs, pstmt, conn);
        }
    }
    
    public long getTotalCount() {
        String sql = "SELECT total_count FROM visitor_stats WHERE id = 1";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getLong("total_count");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        
        return 0;
    }
}
