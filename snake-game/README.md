# 贪吃蛇游戏

一个基于 HTML5 + CSS3 + 原生 JavaScript 开发的经典贪吃蛇游戏，无需 ES6+ 语法，确保兼容性。

## 项目简介

贪吃蛇游戏是一个经典的益智游戏，玩家通过方向键控制蛇的移动，吃掉随机生成的食物来增加长度和分数，同时避免撞到边界或自己的身体。

## 技术特点

- **纯前端实现**：HTML + CSS + 原生 JavaScript
- **ES5 语法**：不使用 ES6+ 特性，确保最大兼容性
- **模块化设计**：代码结构清晰，功能分离
- **响应式设计**：适配不同屏幕尺寸
- **Docker 部署**：一键部署，便于分发

## 快速开始

### 本地运行
```bash
# 直接打开 HTML 文件
open snake-game.html

# 或使用 Python 启动本地服务器
python3 -m http.server 8000
# 然后访问 http://localhost:8000/snake-game.html
```

### Docker 部署
```bash
# 构建镜像
docker build -t snake-game:latest .

# 运行容器
docker run -d --name snake-game -p 8080:80 snake-game:latest

# 访问游戏
# http://localhost:8080
```

## 游戏玩法

### 操作说明
- **↑ 上箭头**：向上移动
- **↓ 下箭头**：向下移动
- **← 左箭头**：向左移动
- **→ 右箭头**：向右移动

### 游戏规则
1. 点击"开始游戏"按钮开始
2. 使用方向键控制蛇的移动方向
3. 吃到红色圆形食物可以得分（+10分）
4. 每吃一个食物，蛇身长度+1
5. 撞到边界或自己的身体，游戏结束
6. 游戏结束后可以点击"重新开始"

### 功能特性
- 🎮 方向键控制
- 📊 实时分数显示
- 🏆 最高分记录（本地存储）
- 🎨 美观的 UI 设计
- ⚡ 流畅的游戏体验

## 项目结构

```
snake-game/
├── snake-game.html      # 主游戏文件（内嵌CSS/JS）
├── snake-game-test-report.md  # 测试报告
├── README.md            # 项目说明
├── DEPLOYMENT.md        # 部署文档
├── Dockerfile           # Docker构建文件
├── nginx.conf           # Nginx配置
└── .gitignore           # Git忽略文件
```

## 技术实现

### HTML
- 使用语义化标签构建页面结构
- Canvas 元素用于绘制游戏画面
- 响应式设计，适配不同屏幕

### CSS
- CSS3 渐变背景
- Flexbox 布局
- 动画效果
- 响应式样式

### JavaScript
- 游戏循环：使用 setInterval 控制游戏速度
- 碰撞检测：边界检测和自身碰撞检测
- 食物生成：随机生成且不重叠
- 状态管理：游戏状态、分数、方向控制
- Canvas 绘制：蛇和食物的绘制

### 核心算法

#### 蛇的初始化
```javascript
// 必须向初始方向相反的方向延伸
for (var i = 0; i < 5; i++) {
    snake.push({x: startX - i, y: startY});
}
```

#### 碰撞检测
```javascript
// 边界碰撞
if (head.x < 0 || head.x >= tileCount || head.y < 0 || head.y >= tileCount) {
    return true;
}

// 自身碰撞
for (var i = 1; i < snake.length; i++) {
    if (head.x === snake[i].x && head.y === snake[i].y) {
        return true;
    }
}
```

## 开发流程

### 1. 功能开发
- 定义需求和技术要求
- 实现核心功能
- 编写测试用例

### 2. 自测验证
- 测试所有功能点
- 修复发现的 bug
- 优化代码质量

### 3. 部署上线
- 构建 Docker 镜像
- 部署到生产环境
- 验证功能正常运行

## 测试

### 测试清单
- ✅ 页面加载无报错
- ✅ 方向键操控准确
- ✅ 食物生成不重叠
- ✅ 进食后分数增加正确
- ✅ 碰撞检测有效
- ✅ 游戏循环流畅

详细的测试报告请查看 [snake-game-test-report.md](./snake-game-test-report.md)

## 部署

### Docker 部署
参考 [DEPLOYMENT.md](./DEPLOYMENT.md) 了解详细的部署步骤。

### Nginx 配置
```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
}
```

## 常见问题

### Q: 游戏无法开始？
A: 点击"开始游戏"按钮，确保按钮没有禁用状态。

### Q: 方向键没有反应？
A: 确保游戏已经开始，不要在游戏未运行时按方向键。

### Q: 如何修改游戏速度？
A: 修改 `GAME_CONFIG.gameSpeed` 的值（单位：毫秒）。

### Q: 如何清除最高分记录？
A: 清除浏览器的 localStorage 或在浏览器控制台执行：
```javascript
localStorage.removeItem('snakeHighScore');
```

## 性能优化

- 使用 Canvas 进行图形绘制，性能优异
- 使用 `requestAnimationFrame` 替代 `setInterval` 可以更流畅（可选优化）
- 代码模块化，避免不必要的计算

## 版本历史

### v1.0.0 (2026-02-12)
- ✨ 初始版本发布
- 🎮 实现基本游戏功能
- 📊 添加分数和最高分记录
- 🐳 支持Docker部署
- 🧪 完整的测试覆盖

## 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](./LICENSE) 文件

## 技术支持

如有问题或建议，请通过以下方式联系：
- 创建 Issue
- 发送邮件至 [your-email@example.com]

## 致谢

- 经典贪吃蛇游戏的设计灵感
- HTML5 Canvas API
- CSS3 新特性
- Docker 容器化技术

---

**游戏愉快！🐍**
