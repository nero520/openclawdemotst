FROM nginx:alpine

# 删除默认的nginx配置
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义nginx配置
COPY nginx.conf /etc/nginx/conf.d/

# 复制游戏文件
COPY snake-game.html /usr/share/nginx/html/index.html
COPY snake-game-test-report.md /usr/share/nginx/html/test-report.html

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]
