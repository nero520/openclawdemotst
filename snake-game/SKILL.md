# 贪吃蛇游戏开发 Skill

## 技能概述
使用 HTML5 + CSS3 + 原生 JavaScript 开发贪吃蛇游戏，不使用 ES6+ 语法，确保兼容性。

## 技术要求

### 1. 页面结构
- 使用 HTML5 语义化标签搭建
- 兼容主流浏览器（Chrome/Firefox/Edge）
- 单文件可运行（内嵌 CSS 和 JavaScript）

### 2. 样式设计
- 使用 CSS3 美化游戏界面
- 游戏区域边框清晰
- 分数面板样式美观
- 蛇身和食物颜色区分明显
- 响应式设计，适配不同屏幕

### 3. 逻辑实现
- 使用原生 JavaScript（ES5 语法）
- 避免使用 ES6+ 语法（如箭头函数、let/const、模板字符串等）
- 代码模块化，功能拆分清晰
- 核心函数：移动函数、碰撞检测函数、食物生成函数

## 功能要求

### 1. 游戏操控
- 仅响应方向键（↑↓←→）
- 蛇移动速度可配置（默认 150ms）
- 禁止反向移动（不能直接向下控制向上）

### 2. 游戏规则
- 食物随机生成在游戏区域内
- 食物不与蛇身重叠
- 蛇每吃一个食物：
  - 身体长度 +1
  - 分数 +10
  - 食物重新生成
- 蛇头触碰边界或自身身体：
  - 游戏立即结束
  - 显示最终分数
  - 提供"重新开始"按钮

### 3. 交互设计
- 初始状态显示"开始游戏"按钮
- 游戏运行时按钮禁用
- 游戏结束后显示"最终分数"+"重新开始"按钮
- 分数实时更新显示

## 项目结构

```
snake-game/
├── snake-game.html      # 主游戏文件（内嵌CSS/JS）
├── snake-game-test-report.md  # 自测报告
├── README.md            # 项目说明
├── DEPLOYMENT.md        # 部署文档
├── Dockerfile           # Docker构建文件
├── nginx.conf           # Nginx配置
└── .gitignore           # Git忽略文件
```

## 开发流程

### 第一步：初始化项目
```bash
# 创建项目目录
mkdir snake-game
cd snake-game

# 初始化 Git 仓库
git init
git remote add origin git@github.com:username/snake-game.git

# 创建基础文件结构
touch snake-game.html
touch README.md
touch DEPLOYMENT.md
touch Dockerfile
touch nginx.conf
touch .gitignore
```

### 第二步：实现核心功能
1. 创建 HTML 结构
2. 添加 CSS 样式
3. 实现 JavaScript 逻辑
4. 编写测试用例

### 第三步：自测验证
- 测试所有功能点
- 记录测试结果
- 修复发现的 bug
- 优化代码质量

### 第四步：部署上线
```bash
# 构建 Docker 镜像
docker build -t snake-game:latest .

# 运行容器
docker run -d --name snake-game -p 8080:80 snake-game:latest
```

## 代码实现要点

### 1. 蛇的初始化（关键）
```javascript
function initSnake() {
    snake = [];
    var startX = Math.floor(tileCount / 2);
    var startY = Math.floor(tileCount / 2);
    // 必须向初始方向相反的方向延伸
    // 第一次移动后蛇头不会碰到蛇身
    for (var i = 0; i < 5; i++) {
        snake.push({x: startX - i, y: startY});
    }
}
```

### 2. 方向键控制
```javascript
document.addEventListener('keydown', function(event) {
    // 阻止方向键滚动页面
    if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].indexOf(event.keyCode) > -1) {
        event.preventDefault();
    }

    // 只有游戏运行时才响应
    if (!isGameRunning || isGameOver) {
        return;
    }

    // 不能反向移动
    switch (event.keyCode) {
        case 37: // 左
            if (direction !== 'right') nextDirection = 'left';
            break;
        case 38: // 上
            if (direction !== 'down') nextDirection = 'up';
            break;
        case 39: // 右
            if (direction !== 'left') nextDirection = 'right';
            break;
        case 40: // 下
            if (direction !== 'up') nextDirection = 'down';
            break;
    }
});
```

### 3. 游戏循环与重绘
```javascript
function startGame() {
    // 重置状态
    isGameRunning = true;
    isGameOver = false;

    // 初始化蛇和食物
    initSnake();
    generateFood();

    // 启动游戏循环
    gameInterval = setInterval(moveSnake, GAME_CONFIG.gameSpeed);

    // 开始绘制
    draw();
}

function moveSnake() {
    // 更新蛇的位置
    // 检测碰撞
    // 更新分数

    // 关键：每次移动后必须重绘
    draw();
}
```

### 4. 绘制游戏画面
```javascript
function draw() {
    // 清空画布
    ctx.fillStyle = '#2c3e50';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // 绘制蛇
    for (var i = 0; i < snake.length; i++) {
        ctx.fillStyle = (i === 0) ? '#27ae60' : '#2ecc71'; // 蛇头颜色深一点
        ctx.fillRect(snake[i].x * gridSize, snake[i].y * gridSize, gridSize - 1, gridSize - 1);
    }

    // 绘制食物
    ctx.fillStyle = '#e74c3c';
    ctx.beginPath();
    var foodX = food.x * gridSize + gridSize / 2;
    var foodY = food.y * gridSize + gridSize / 2;
    ctx.arc(foodX, foodY, gridSize / 2 - 2, 0, Math.PI * 2);
    ctx.fill();
}
```

## 常见 Bug 及解决方案

### Bug 1: 方向键无法控制蛇
**问题**：点击开始按钮后，方向键没有反应。
**原因**：`event.preventDefault()` 在游戏状态检查之后，导致方向键触发页面滚动。
**解决**：将 `event.preventDefault()` 移到游戏状态检查之前。

### Bug 2: 游戏立即结束
**问题**：点击开始游戏后，还没按方向键就游戏结束。
**原因**：蛇初始化时初始方向和延伸方向不一致。
**解决**：蛇必须向初始方向相反的方向延伸（向左延伸，初始方向为right）。

### Bug 3: 蛇不移动
**问题**：点击开始游戏后，蛇没有移动。
**原因**：`moveSnake()` 函数只更新数组，没有调用 `draw()` 重绘画布。
**解决**：在 `moveSnake()` 函数末尾添加 `draw()` 调用。

### Bug 4: 点击开始后立即结束
**问题**：第一次移动就碰撞。
**原因**：蛇初始化时从中心向右延伸5格，第一次向右移动时蛇头会碰到蛇身。
**解决**：蛇向左延伸5格，第一次向右移动后蛇头不在蛇身上。

## 测试清单

### 功能测试
- [ ] 页面加载无控制台报错
- [ ] 点击开始按钮后游戏开始
- [ ] 方向键操控准确，无穿墙或瞬移
- [ ] 食物生成位置合理，不重叠
- [ ] 进食后身体变长、分数增加正确
- [ ] 碰撞后游戏结束，显示正确分数
- [ ] 重新开始按钮可重置游戏
- [ ] 最高分记录正确保存

### 边界测试
- [ ] 撞墙立即结束
- [ ] 撞自身立即结束
- [ ] 快速切换方向不触发碰撞
- [ ] 速度适中，不卡顿

## 部署文档

### Docker 部署
```dockerfile
FROM nginx:alpine

# 删除默认nginx配置
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义nginx配置
COPY nginx.conf /etc/nginx/conf.d/

# 复制游戏文件
COPY snake-game.html /usr/share/nginx/html/index.html
COPY snake-game-test-report.md /usr/share/nginx/html/test-report.html

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]
```

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

## Git 提交规范

```
类型: 简短描述

详细说明：
- 问题描述
- 原因分析
- 解决方案
- 测试结果

Commit: <commit-hash>
```

示例：
```
fix: 修复贪吃蛇游戏方向键无法控制的问题

问题原因：
- 键盘事件监听器中，游戏状态检查顺序错误
- 导致 event.preventDefault() 未被调用

解决方案：
- 将 event.preventDefault() 移到游戏状态检查之前

测试结果：
- 方向键控制正常
- 游戏运行流畅

Commit: 20c604a
```

## 版本历史

### v1.0.0
- 初始版本发布
- 实现基本功能
- 自测全部通过
- 部署到 Docker

## 参考资料

- [HTML5 Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API)
- [CSS3 教程](https://www.w3schools.com/css/)
- [原生 JavaScript 教程](https://www.w3schools.com/js/)
- [Docker 官方文档](https://docs.docker.com/)
