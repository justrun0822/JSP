// WebSocket 实时聊天客户端

let ws = null;
let reconnectAttempts = 0;
const MAX_RECONNECT_ATTEMPTS = 5;
let typingTimer = null;
const TYPING_TIMER_LENGTH = 1000; // 1秒后停止输入状态

// 初始化 WebSocket 连接
function initWebSocket() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const host = window.location.host;
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    const wsUrl = `${protocol}//${host}${contextPath}/websocket/chat`;
    
    console.log('正在连接 WebSocket:', wsUrl);
    
    try {
        ws = new WebSocket(wsUrl);
        
        ws.onopen = onWebSocketOpen;
        ws.onmessage = onWebSocketMessage;
        ws.onclose = onWebSocketClose;
        ws.onerror = onWebSocketError;
        
    } catch (error) {
        console.error('WebSocket 连接失败:', error);
        showConnectionStatus('连接失败', 'error');
    }
}

// WebSocket 连接打开
function onWebSocketOpen(event) {
    console.log('WebSocket 连接成功');
    showConnectionStatus('已连接', 'success');
    reconnectAttempts = 0;
    
    // 禁用传统表单提交
    const messageForm = document.getElementById('messageForm');
    if (messageForm) {
        messageForm.onsubmit = function(e) {
            e.preventDefault();
            sendMessage();
            return false;
        };
    }
}

// 接收 WebSocket 消息
function onWebSocketMessage(event) {
    try {
        const message = JSON.parse(event.data);
        console.log('收到消息:', message);
        
        switch (message.type) {
            case 'message':
                displayMessage(message);
                break;
            case 'join':
                displaySystemMessage(message.content, 'join');
                break;
            case 'leave':
                displaySystemMessage(message.content, 'leave');
                break;
            case 'online':
                updateOnlineCount(message.onlineCount);
                break;
            case 'typing':
                showTypingIndicator(message.username);
                break;
            case 'stop_typing':
                hideTypingIndicator(message.username);
                break;
            default:
                console.warn('未知消息类型:', message.type);
        }
        
    } catch (error) {
        console.error('处理消息失败:', error);
    }
}

// WebSocket 连接关闭
function onWebSocketClose(event) {
    console.log('WebSocket 连接关闭:', event.code, event.reason);
    showConnectionStatus('连接已断开', 'error');
    
    // 尝试重连
    if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
        reconnectAttempts++;
        const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), 30000);
        console.log(`${delay}ms 后尝试重连 (${reconnectAttempts}/${MAX_RECONNECT_ATTEMPTS})`);
        
        setTimeout(() => {
            showConnectionStatus(`重连中... (${reconnectAttempts}/${MAX_RECONNECT_ATTEMPTS})`, 'warning');
            initWebSocket();
        }, delay);
    } else {
        showConnectionStatus('无法连接到服务器，请刷新页面重试', 'error');
    }
}

// WebSocket 错误
function onWebSocketError(event) {
    console.error('WebSocket 错误:', event);
    showConnectionStatus('连接错误', 'error');
}

// 发送消息
function sendMessage() {
    const input = document.getElementById('messageInput');
    const content = input.value.trim();
    
    if (!content) {
        return;
    }
    
    if (content.length > 500) {
        alert('消息太长，最多500字');
        return;
    }
    
    if (!ws || ws.readyState !== WebSocket.OPEN) {
        alert('连接已断开，请稍后重试');
        return;
    }
    
    const message = {
        type: 'message',
        content: content
    };
    
    try {
        ws.send(JSON.stringify(message));
        input.value = '';
        
        // 停止输入状态
        sendStopTyping();
        
        // 更新字符计数
        updateCharCounter(0);
        
    } catch (error) {
        console.error('发送消息失败:', error);
        alert('发送失败，请重试');
    }
}

// 显示消息
function displayMessage(message) {
    const chatBox = document.querySelector('.chat-box');
    if (!chatBox) return;
    
    const messageDiv = document.createElement('div');
    messageDiv.className = 'message ws-message';
    
    const time = message.timestamp || getCurrentTime();
    const username = escapeHtml(message.username);
    const content = escapeHtml(message.content);
    
    messageDiv.innerHTML = `
        <span class="message-time">[${time}]</span>
        <span class="message-user">${username}:</span>
        <span class="message-content">${content}</span>
    `;
    
    chatBox.appendChild(messageDiv);
    
    // 滚动到底部
    chatBox.scrollTop = chatBox.scrollHeight;
    
    // 播放提示音（可选）
    // playNotificationSound();
}

// 显示系统消息
function displaySystemMessage(content, type) {
    const chatBox = document.querySelector('.chat-box');
    if (!chatBox) return;
    
    const messageDiv = document.createElement('div');
    messageDiv.className = `system-message system-${type}`;
    messageDiv.textContent = content;
    
    chatBox.appendChild(messageDiv);
    chatBox.scrollTop = chatBox.scrollHeight;
}

// 更新在线人数
function updateOnlineCount(count) {
    const onlineCountEl = document.getElementById('onlineCount');
    if (onlineCountEl) {
        onlineCountEl.textContent = count;
    }
}

// 显示输入中提示
function showTypingIndicator(username) {
    const typingDiv = document.getElementById('typingIndicator');
    if (!typingDiv) return;
    
    const userSpan = document.createElement('span');
    userSpan.className = 'typing-user';
    userSpan.id = `typing-${username}`;
    userSpan.textContent = username;
    
    typingDiv.appendChild(userSpan);
    typingDiv.style.display = 'block';
    
    updateTypingText();
}

// 隐藏输入中提示
function hideTypingIndicator(username) {
    const userSpan = document.getElementById(`typing-${username}`);
    if (userSpan) {
        userSpan.remove();
    }
    
    updateTypingText();
}

// 更新输入中文本
function updateTypingText() {
    const typingDiv = document.getElementById('typingIndicator');
    if (!typingDiv) return;
    
    const users = typingDiv.querySelectorAll('.typing-user');
    const textSpan = document.getElementById('typingText');
    
    if (users.length === 0) {
        typingDiv.style.display = 'none';
    } else {
        typingDiv.style.display = 'block';
        if (textSpan) {
            textSpan.textContent = users.length === 1 ? ' 正在输入...' : ' 等人正在输入...';
        }
    }
}

// 发送输入中状态
function sendTyping() {
    if (!ws || ws.readyState !== WebSocket.OPEN) return;
    
    const message = {
        type: 'typing'
    };
    
    try {
        ws.send(JSON.stringify(message));
    } catch (error) {
        console.error('发送输入状态失败:', error);
    }
}

// 发送停止输入状态
function sendStopTyping() {
    if (!ws || ws.readyState !== WebSocket.OPEN) return;
    
    const message = {
        type: 'stop_typing'
    };
    
    try {
        ws.send(JSON.stringify(message));
    } catch (error) {
        console.error('发送停止输入状态失败:', error);
    }
}

// 输入框输入事件
function onMessageInput() {
    const input = document.getElementById('messageInput');
    if (!input) return;
    
    // 更新字符计数
    updateCharCounter(input.value.length);
    
    // 发送输入中状态
    sendTyping();
    
    // 重置定时器
    clearTimeout(typingTimer);
    typingTimer = setTimeout(() => {
        sendStopTyping();
    }, TYPING_TIMER_LENGTH);
}

// 更新字符计数
function updateCharCounter(length) {
    const counter = document.getElementById('charCounter');
    if (counter) {
        counter.textContent = `${length} / 500`;
        counter.style.color = length > 450 ? '#dc3545' : '#666';
    }
}

// 显示连接状态
function showConnectionStatus(message, type) {
    const statusEl = document.getElementById('connectionStatus');
    if (!statusEl) return;
    
    statusEl.textContent = message;
    statusEl.className = `connection-status status-${type}`;
    statusEl.style.display = 'block';
    
    // 成功消息3秒后自动隐藏
    if (type === 'success') {
        setTimeout(() => {
            statusEl.style.display = 'none';
        }, 3000);
    }
}

// HTML 转义
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// 获取当前时间
function getCurrentTime() {
    const now = new Date();
    return `${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}`;
}

function pad(num) {
    return num < 10 ? '0' + num : num;
}

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    // 初始化 WebSocket
    initWebSocket();
    
    // 绑定输入框事件
    const messageInput = document.getElementById('messageInput');
    if (messageInput) {
        messageInput.addEventListener('input', onMessageInput);
        
        // Enter 发送，Shift+Enter 换行
        messageInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    }
    
    // 绑定发送按钮
    const sendBtn = document.getElementById('sendBtn');
    if (sendBtn) {
        sendBtn.addEventListener('click', sendMessage);
    }
});

// 页面关闭时断开连接
window.addEventListener('beforeunload', function() {
    if (ws) {
        ws.close();
    }
});
