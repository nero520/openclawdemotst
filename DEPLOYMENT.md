# 贪吃蛇游戏 - 部署说明

## 部署方式

### Docker + Nginx 部署（已部署）

**部署状态**：✅ 已部署成功

**访问地址**：
- 游戏主页面：http://localhost:8080
- 自测报告：http://localhost:8080/test-report.html

**容器信息**：
- 容器名称：snake-game
- 容器 ID：0ace7b044a62
- 镜像：snake-game:latest
- 端口映射：0.0.0.0:8080->80/tcp
- 状态：运行中 ✅

**Docker 命令**：

```bash
# 启动容器
docker run -d -p 8080:80 --name snake-game snake-game

# 查看容器状态
docker ps --filter name=snake-game

# 查看容器日志
docker logs snake-game

# 停止容器
docker stop snake-game

# 启动容器
docker start snake-game

# 删除容器
docker rm -f snake-game

# 重新构建镜像
docker build -t snake-game .

# 查看容器资源使用
docker stats snake-game
```

### 部署文件

**文件清单**：
- `snake-game.html` - 游戏主文件（13KB）
- `snake-game-test-report.md` - 自测报告（4.9KB）
- `Dockerfile` - Docker 部署配置
- `nginx.conf` - Nginx 配置文件

### Nginx 配置

**配置文件内容**：

```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ =404;
    }

    location /test-report.html {
        root /usr/share/nginx/html;
    }

    # 启用 gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;

    # 设置缓存头
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

## 访问方式

### 本地访问

**游戏页面**：
```
http://localhost:8080
```

**自测报告**：
```
http://localhost:8080/test-report.html
```

### 远程访问

如果服务器有公网 IP，可以通过以下方式访问：

1. 查看服务器公网 IP：
```bash
curl ifconfig.me
```

2. 通过公网 IP 访问：
```
http://<服务器公网IP>:8080
```

3. 注意：需要开放 8080 端口的防火墙规则

## 防火墙配置

### Ubuntu/iptables

```bash
# 开放 8080 端口
sudo ufw allow 8080/tcp

# 查看防火墙状态
sudo ufw status

# 重新加载防火墙
sudo ufw reload
```

### 云服务器（云厂商）

如果使用云服务器（如阿里云、腾讯云、AWS），需要在云厂商控制台的安全组中开放 8080 端口。

### Docker 自定义防火墙

如果使用 Docker，需要确保 Docker 网络配置允许端口映射。

## 性能优化

### 1. 启用 gzip 压缩

Nginx 已启用 gzip 压缩，减少传输数据量。

### 2. 设置缓存

静态资源（图片、CSS、JS）设置了 30 天缓存。

### 3. 使用 Alpine 镜像

使用 nginx:alpine 镜像，减小镜像体积。

## 监控和日志

### 查看访问日志

```bash
docker exec snake-game cat /var/log/nginx/access.log
```

### 查看错误日志

```bash
docker exec snake-game cat /var/log/nginx/error.log
```

### 查看容器资源使用

```bash
docker stats snake-game
```

## 故障排查

### 问题 1：无法访问游戏页面

**检查步骤**：

1. 检查容器是否运行：
```bash
docker ps --filter name=snake-game
```

2. 检查端口是否监听：
```bash
netstat -tlnp | grep 8080
```

3. 检查防火墙规则：
```bash
sudo ufw status
```

4. 检查容器日志：
```bash
docker logs snake-game
```

### 问题 2：Nginx 启动失败

**检查步骤**：

1. 检查 nginx.conf 文件是否存在：
```bash
docker exec snake-game ls -la /etc/nginx/conf.d/
```

2. 检查 nginx 配置文件语法：
```bash
docker exec snake-game nginx -t
```

3. 重新启动容器：
```bash
docker restart snake-game
```

### 问题 3：静态资源无法加载

**检查步骤**：

1. 检查文件是否复制到容器：
```bash
docker exec snake-game ls -la /usr/share/nginx/html/
```

2. 检查文件权限：
```bash
docker exec snake-game chmod 644 /usr/share/nginx/html/*
```

## 备份和恢复

### 备份配置

```bash
# 备份 nginx 配置
docker cp snake-game:/etc/nginx/nginx.conf ./nginx-config-backup.conf

# 备份容器
docker commit snake-game snake-game-backup
```

### 恢复配置

```bash
# 恢复容器
docker import snake-game-backup.tar snake-game:latest

# 重新启动容器
docker run -d -p 8080:80 --name snake-game snake-game
```

## 扩展功能

### 添加更多游戏

可以在 `/usr/share/nginx/html/` 目录下添加更多 HTML 文件，然后在 nginx.conf 中添加对应的 location。

### 自定义域名

如果需要使用自定义域名，可以修改 nginx.conf：

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ =404;
    }
}
```

然后需要配置 DNS 解析指向服务器 IP。

## 更新部署

### 更新游戏文件

1. 修改 `snake-game.html`
2. 重新构建镜像：
```bash
docker build -t snake-game .
```
3. 停止旧容器：
```bash
docker stop snake-game
```
4. 删除旧容器：
```bash
docker rm snake-game
```
5. 启动新容器：
```bash
docker run -d -p 8080:80 --name snake-game snake-game
```

### 自动更新

可以编写脚本实现自动更新：

```bash
#!/bin/bash
# auto-update-snake-game.sh

cd /data/openclawdemotst/openclawdemotst

# 拉取最新代码
git pull

# 重新构建镜像
docker build -t snake-game .

# 停止旧容器
docker stop snake-game

# 删除旧容器
docker rm snake-game

# 启动新容器
docker run -d -p 8080:80 --name snake-game snake-game

echo "更新完成！"
```

## 维护计划

### 定期检查

- 每周检查容器运行状态
- 每月查看访问日志，分析用户行为
- 每月检查安全更新

### 备份策略

- 每周备份配置文件
- 每月备份容器镜像
- 重要数据及时备份

---

部署时间：2026-02-11
部署人：OpenClaw AI Agent
部署状态：✅ 成功
