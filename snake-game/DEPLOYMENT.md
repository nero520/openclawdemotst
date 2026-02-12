# 贪吃蛇游戏部署文档

## 部署概述
本文档说明如何将贪吃蛇游戏部署到 Docker 容器中。

## 部署环境要求

### 软件要求
- Docker 20.10+
- Docker Compose 2.0+（可选）
- 服务器配置：
  - CPU: 1核或以上
  - 内存: 512MB或以上
  - 磁盘: 1GB或以上

### 操作系统
- Linux (Ubuntu 20.04+, CentOS 7+, Debian 10+)
- Windows 10/11 (Docker Desktop)
- macOS 10.15+

## 部署步骤

### 1. 拉取代码
```bash
# 克隆仓库
git clone git@github.com:username/snake-game.git
cd snake-game

# 确保在tst分支
git checkout tst
```

### 2. 构建镜像
```bash
# 构建Docker镜像
docker build -t snake-game:latest .

# 验证镜像已创建
docker images | grep snake-game
```

### 3. 运行容器
```bash
# 停止并删除旧容器（如果存在）
docker stop snake-game 2>/dev/null || true
docker rm snake-game 2>/dev/null || true

# 运行新容器
docker run -d \
    --name snake-game \
    --restart unless-stopped \
    -p 8080:80 \
    snake-game:latest

# 查看容器状态
docker ps | grep snake-game

# 查看日志
docker logs snake-game
```

### 4. 验证部署
```bash
# 测试访问
curl http://localhost:8080

# 或在浏览器中访问
# http://your-server-ip:8080
```

## 配置说明

### 端口配置
默认端口：`8080`
修改端口：`docker run -d --name snake-game -p 8081:80 snake-game:latest`

### 环境变量
当前版本不支持环境变量配置。

### Docker Compose 配置（可选）
创建 `docker-compose.yml`：
```yaml
version: '3.8'
services:
  snake-game:
    image: snake-game:latest
    container_name: snake-game
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - GAME_SPEED=150
```

运行：
```bash
# 启动
docker-compose up -d

# 停止
docker-compose down

# 查看日志
docker-compose logs -f
```

## 常用命令

### 容器管理
```bash
# 查看容器状态
docker ps | grep snake-game

# 查看容器日志
docker logs snake-game

# 查看实时日志
docker logs -f snake-game

# 重启容器
docker restart snake-game

# 停止容器
docker stop snake-game

# 启动容器
docker start snake-game

# 删除容器
docker rm snake-game
```

### 镜像管理
```bash
# 查看镜像
docker images | grep snake-game

# 删除镜像
docker rmi snake-game:latest

# 重新构建镜像
docker build -t snake-game:latest .
```

### 更新部署
```bash
# 1. 拉取最新代码
git pull origin tst

# 2. 重新构建镜像
docker build -t snake-game:latest .

# 3. 重启容器
docker stop snake-game
docker rm snake-game
docker run -d --name snake-game -p 8080:80 snake-game:latest
```

## 健康检查

### 手动检查
```bash
# 检查容器状态
docker ps | grep snake-game

# 检查容器健康状态
docker inspect snake-game | grep -A 10 Health

# 测试HTTP访问
curl http://localhost:8080
```

### 自动健康检查（可选）
创建 `healthcheck.sh`：
```bash
#!/bin/bash
curl -f http://localhost:8080 || exit 1
```

在 Dockerfile 中添加：
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1
```

## 监控和日志

### 查看日志
```bash
# 实时查看日志
docker logs -f snake-game

# 查看最近100行日志
docker logs --tail 100 snake-game

# 查看带时间戳的日志
docker logs -t snake-game

# 保存日志到文件
docker logs snake-game > snake-game.log
```

### 日志分析
```bash
# 查看错误日志
docker logs snake-game 2>&1 | grep -i error

# 查看最近1小时的日志
docker logs --since 1h snake-game
```

## 故障排查

### 容器无法启动
```bash
# 查看详细错误信息
docker logs snake-game

# 检查端口是否被占用
netstat -tlnp | grep 8080
# 或
lsof -i :8080

# 尝试使用其他端口
docker run -d --name snake-game -p 8081:80 snake-game:latest
```

### 容器频繁重启
```bash
# 查看重启次数
docker inspect snake-game | grep -A 5 RestartCount

# 查看详细日志
docker logs snake-game

# 检查Docker守护进程
systemctl status docker
```

### 游戏无法访问
```bash
# 检查容器是否运行
docker ps | grep snake-game

# 检查端口映射
docker port snake-game

# 检查防火墙
sudo ufw status
sudo ufw allow 8080

# 检查Nginx（如果使用反向代理）
sudo nginx -t
sudo systemctl status nginx
```

### 镜像构建失败
```bash
# 清理Docker缓存
docker system prune -a

# 重新构建镜像
docker build --no-cache -t snake-game:latest .
```

## 安全建议

### 1. 使用HTTPS
配置反向代理（Nginx）并启用SSL：
```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 2. 限制访问
使用防火墙限制访问：
```bash
# 只允许特定IP访问
sudo ufw allow from 192.168.1.0/24 to any port 8080
```

### 3. 定期更新
定期更新Docker和镜像：
```bash
# 更新Docker
sudo apt-get update && sudo apt-get upgrade docker-ce

# 更新应用
git pull origin tst
docker build -t snake-game:latest .
docker stop snake-game && docker rm snake-game
docker run -d --name snake-game -p 8080:80 snake-game:latest
```

## 性能优化

### 1. 调整游戏速度
修改 `GAME_CONFIG.gameSpeed`：
```javascript
var GAME_CONFIG = {
    gridSize: 20,
    gameSpeed: 100,  // 更快的速度
    boardWidth: 400,
    boardHeight: 400,
    tileCount: 20
};
```

### 2. 增加缓存
在 Dockerfile 中添加缓存层：
```dockerfile
# 多阶段构建优化
FROM nginx:alpine AS builder
WORKDIR /app
COPY snake-game.html .
RUN cat snake-game.html > /tmp/snake-game.html

FROM nginx:alpine
COPY --from=builder /tmp/snake-game.html /usr/share/nginx/html/index.html
```

## 备份和恢复

### 备份配置
```bash
# 备份容器配置
docker inspect snake-game > snake-game-backup.json

# 备份镜像
docker save snake-game:latest | gzip > snake-game-backup.tar.gz
```

### 恢复配置
```bash
# 加载镜像
docker load < snake-game-backup.tar.gz

# 运行容器
docker run -d --name snake-game -p 8080:80 snake-game:latest
```

## 卸载

### 完全卸载
```bash
# 停止并删除容器
docker stop snake-game
docker rm snake-game

# 删除镜像
docker rmi snake-game:latest

# 删除数据（如果有持久化数据）
# rm -rf /var/lib/docker/volumes/snake-game

# 删除配置文件（如果有）
# rm -rf /etc/snake-game
```

## 技术支持

如遇到问题，请：
1. 查看本文档的"故障排查"章节
2. 查看Docker日志：`docker logs snake-game`
3. 联系技术支持团队

## 版本历史

### v1.0.0 (2026-02-12)
- 初始版本发布
- 支持基本的贪吃蛇游戏功能
- Docker部署支持
