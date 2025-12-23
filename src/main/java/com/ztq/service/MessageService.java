package com.ztq.service;

import com.ztq.dao.MessageDAO;
import com.ztq.entity.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class MessageService {
    
    private static final Logger logger = LoggerFactory.getLogger(MessageService.class);
    private static final int MAX_MESSAGES_KEEP = 100;
    
    private MessageDAO messageDAO = new MessageDAO();
    
    public boolean saveMessage(String username, String content) {
        logger.info("保存消息 - 用户: {}, 内容长度: {}", username, content.length());
        
        Message message = new Message(username, content);
        boolean success = messageDAO.addMessage(message);
        
        if (success) {
            logger.debug("消息保存成功");
            cleanOldMessages();
        } else {
            logger.error("消息保存失败 - 用户: {}", username);
        }
        
        return success;
    }
    
    public List<Message> getRecentMessages(int limit) {
        logger.debug("获取最近 {} 条消息", limit);
        List<Message> messages = messageDAO.getRecentMessages(limit);
        logger.debug("返回 {} 条消息", messages.size());
        return messages;
    }
    
    public List<Message> getMessagesByPage(int page, int pageSize) {
        logger.debug("分页获取消息 - 页码: {}, 每页: {}", page, pageSize);
        List<Message> messages = messageDAO.getMessagesByPage(page, pageSize);
        logger.debug("返回 {} 条消息", messages.size());
        return messages;
    }
    
    public int getTotalCount() {
        int count = messageDAO.getMessageCount();
        logger.debug("消息总数: {}", count);
        return count;
    }
    
    private void cleanOldMessages() {
        int count = messageDAO.getMessageCount();
        if (count > MAX_MESSAGES_KEEP) {
            logger.info("消息数量 {} 超过限制 {}，开始清理", count, MAX_MESSAGES_KEEP);
            boolean cleaned = messageDAO.deleteOldMessages(MAX_MESSAGES_KEEP);
            if (cleaned) {
                logger.info("旧消息清理成功");
            } else {
                logger.warn("旧消息清理失败");
            }
        }
    }
}
