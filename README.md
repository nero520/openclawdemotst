# 贪吃蛇游戏

## 项目说明

这是一个基于HTML5、CSS3和原生JavaScript开发的静态贪吃蛇游戏。

## 文件结构

```
.
├── snake-game.html          # 游戏主文件（内嵌CSS和JS）
├── snake-game-test-report.md  # 自测报告
├── Dockerfile                # Docker 部署配置
├── nginx.conf                # Nginx 配置
└── README.md                 # 项目说明
```

## 功能特性

### 技术要求
- ✅ HTML5 语义化标签
- ✅ CSS3 美化（渐变背景、按钮效果、配色区分）
- ✅ 原生 JavaScript（ES5 语法，兼容性好）
- ✅ 代码模块化（函数拆分清晰）

### 功能要求
- ✅ 方向键控制（↑↓←→）
- ✅ 食物随机生成（不与蛇身重叠）
- ✅ 吃食物后身体变长、分数+10
- ✅ 碰撞检测（边界和自身）
- ✅ 开始游戏/重新开始按钮
- ✅ 分数实时更新
- ✅ 最高分记录

### 交互设计
- ✅ 开始游戏按钮
- ✅ 游戏结束模态框
- ✅ 重新开始按钮
- ✅ 按钮悬停效果
- ✅ 按钮禁用状态
- ✅ 方向键阻止页面滚动

## 快速开始

### 方式 1：直接打开HTML文件

```bash
# 在浏览器中打开
open snake-game.html
# 或
xdg-open snake-game.html  # Linux
start snake-game.html     # Windows
open snake-game.html      # macOS
```

### 方式 2：Docker + Nginx 部署

```bash
# 构建Docker镜像
docker build -t snake-game .

# 运行容器
docker run -d -p 8080:80 --name snake-game snake-game

# 访问游戏
# 浏览器打开: http://localhost:8080
```

### 方式 3：本地 HTTP 服务器

```bash
# Python 3
python3 -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000

# Node.js (需要先安装 http-server)
npx http-server -p 8000

# 然后访问: http://localhost:8000
```

## 自测报告

查看自测报告：
```bash
open test-report.html
```

或访问：http://localhost:8080/test-report.html

## 游戏规则

1. 使用方向键（↑↓←→）控制蛇的移动方向
2. 吃到红色食物后：
   - 蛇身体长度+1
   - 分数+10
3. 游戏结束条件：
   - 蛇头触碰边界
   - 蛇头触碰自身身体
4. 点击"重新开始"按钮可以重置游戏

## 浏览器兼容性

- ✅ Chrome（推荐）
- ✅ Firefox
- ✅ Safari
- ✅ Edge

## 技术栈

- HTML5（语义化标签）
- CSS3（渐变、动画、Flexbox）
- 原生 JavaScript（ES5）
- HTML5 Canvas

## 自测结果

所有测试项100%通过：
- ✅ 页面加载无控制台报错
- ✅ 方向键操控准确，无"穿墙""瞬移"
- ✅ 食物生成位置合理，无重叠
- ✅ 蛇进食后身体变长、分数增加准确
- ✅ 碰撞后游戏结束，重启按钮正常

详见：[自测报告](test-report.html)

## 作者

OpenClaw AI Agent
