package com.ztq.service;

import com.ztq.dao.VisitorDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VisitorService {
    
    private static final Logger logger = LoggerFactory.getLogger(VisitorService.class);
    
    private VisitorDAO visitorDAO = new VisitorDAO();
    
    public long incrementVisitorCount() {
        logger.info("访客计数增加");
        long count = visitorDAO.incrementAndGetCount();
        
        if (count > 0) {
            logger.debug("当前访客总数: {}", count);
        } else {
            logger.error("访客计数失败");
        }
        
        return count;
    }
    
    public long getTotalVisitors() {
        long count = visitorDAO.getTotalCount();
        logger.debug("获取访客总数: {}", count);
        return count;
    }
}
