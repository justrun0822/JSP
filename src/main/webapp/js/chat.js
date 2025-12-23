// 聊天室 JavaScript 增强

// Ajax 自动刷新功能
let autoRefreshEnabled = false;
let refreshInterval = null;

function toggleAutoRefresh() {
    autoRefreshEnabled = !autoRefreshEnabled;
    const btn = document.getElementById('toggleRefresh');
    
    if (autoRefreshEnabled) {
        btn.textContent = '⏸ 停止自动刷新';
        btn.style.backgroundColor = '#dc3545';
        startAutoRefresh();
    } else {
        btn.textContent = '▶ 开启自动刷新';
        btn.style.backgroundColor = '#28a745';
        stopAutoRefresh();
    }
}

function startAutoRefresh() {
    refreshInterval = setInterval(function() {
        refreshMessages();
    }, 3000); // 每3秒刷新一次
}

function stopAutoRefresh() {
    if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = null;
    }
}

function refreshMessages() {
    const chatBox = document.querySelector('.chat-box');
    const scrollAtBottom = chatBox.scrollHeight - chatBox.scrollTop === chatBox.clientHeight;
    
    fetch(window.location.href)
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const newChatBox = doc.querySelector('.chat-box');
            
            if (newChatBox) {
                chatBox.innerHTML = newChatBox.innerHTML;
                
                // 如果之前在底部，刷新后也滚动到底部
                if (scrollAtBottom) {
                    chatBox.scrollTop = chatBox.scrollHeight;
                }
            }
        })
        .catch(error => console.error('刷新失败:', error));
}

// 表单验证和提交
document.addEventListener('DOMContentLoaded', function() {
    const messageForm = document.getElementById('messageForm');
    const messageInput = document.getElementById('messageInput');
    
    if (messageForm && messageInput) {
        // 实时字符计数
        messageInput.addEventListener('input', function() {
            const length = this.value.length;
            const maxLength = 500;
            const counter = document.getElementById('charCounter');
            
            if (counter) {
                counter.textContent = length + ' / ' + maxLength;
                
                if (length > maxLength - 50) {
                    counter.style.color = '#dc3545';
                } else {
                    counter.style.color = '#666';
                }
            }
            
            // 实时验证
            if (length === 0) {
                this.setCustomValidity('消息不能为空');
            } else if (length > maxLength) {
                this.setCustomValidity('消息太长，最多' + maxLength + '字');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // 表单提交后清空输入框
        messageForm.addEventListener('submit', function() {
            setTimeout(function() {
                messageInput.value = '';
                const counter = document.getElementById('charCounter');
                if (counter) {
                    counter.textContent = '0 / 500';
                }
            }, 100);
        });
        
        // Enter 发送，Shift+Enter 换行
        messageInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                messageForm.submit();
            }
        });
    }
    
    // 滚动到底部
    const chatBox = document.querySelector('.chat-box');
    if (chatBox) {
        chatBox.scrollTop = chatBox.scrollHeight;
    }
});

// 页面关闭时停止自动刷新
window.addEventListener('beforeunload', function() {
    stopAutoRefresh();
});
