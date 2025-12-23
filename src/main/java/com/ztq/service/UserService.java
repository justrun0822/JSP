package com.ztq.service;

import com.ztq.dao.UserDAO;
import com.ztq.entity.User;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserService {
    
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);
    
    private UserDAO userDAO = new UserDAO();
    
    public boolean register(String username, String password, String email) {
        logger.info("用户注册 - 用户名: {}, 邮箱: {}", username, email);
        
        if (userDAO.existsByUsername(username)) {
            logger.warn("用户名已存在: {}", username);
            return false;
        }
        
        if (userDAO.existsByEmail(email)) {
            logger.warn("邮箱已存在: {}", email);
            return false;
        }
        
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        
        User user = new User();
        user.setUsername(username);
        user.setPassword(hashedPassword);
        user.setEmail(email);
        
        boolean success = userDAO.addUser(user);
        
        if (success) {
            logger.info("用户注册成功: {}", username);
        } else {
            logger.error("用户注册失败: {}", username);
        }
        
        return success;
    }
    
    public User login(String username, String password) {
        logger.info("用户登录尝试 - 用户名: {}", username);
        
        User user = userDAO.getUserByUsername(username);
        
        if (user == null) {
            logger.warn("用户不存在: {}", username);
            return null;
        }
        
        if (BCrypt.checkpw(password, user.getPassword())) {
            logger.info("用户登录成功: {}", username);
            userDAO.updateLastLogin(user.getId());
            return user;
        } else {
            logger.warn("密码错误 - 用户: {}", username);
            return null;
        }
    }
    
    public User getUserById(Long id) {
        return userDAO.getUserById(id);
    }
    
    public User getUserByUsername(String username) {
        return userDAO.getUserByUsername(username);
    }
}
