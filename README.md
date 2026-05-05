# Desk Panel

一个面向桌面场景的 Flutter 信息面板，主界面采用横向旋转布局，把天气、时间、待办/事件和消息流集中展示在同一屏幕上。项目由 Flutter 前端和 Python 后端组成，前端通过 Socket.IO 和 HTTP 接口实时拉取数据，后端负责天气聚合、事件推送、消息存储和图片上传。

## 项目概览

这个面板的目标是把高频信息以大字号、卡片化的方式放在桌面屏幕上，适合长期挂在显示器、平板或竖屏设备上使用。

前端主要展示四块内容：

- 天气卡片：当前天气、温度、空气质量和降水提示。
- 时间卡片：当前日期和秒级更新时间。
- 事件卡片：下一条日程/事件的时间、日期、地点和标题。
- 消息流：支持文本消息、图片消息和通知消息，内容由后端实时更新。

## 技术栈

- Flutter + Material 3
- Provider 状态管理
- Socket.IO 实时通信
- FastAPI 后端
- SQLite 消息存储
- QWeather 数据源

## 目录结构

- `lib/`：Flutter 前端页面、Provider、服务和组件。
- `python/`：FastAPI 后端、消息数据库和静态资源。
- `assets/weather-icons/`：天气图标资源。

## 功能说明

### 前端

- 启动后以旋转后的全屏面板显示。
- 使用 Provider 驱动天气、时间、事件和消息的局部刷新。
- 天气和事件通过 Socket.IO 请求后端数据。
- 消息列表通过 HTTP 获取，并在 `messages_updated` 事件后自动刷新。
- 支持文本消息和图片消息，图片会直接从后端静态地址加载。

### 后端

- 提供 `GET /api/messages` 和 `POST /api/messages`。
- 提供 `POST /api/messages/upload-image` 用于上传图片消息。
- 提供 `POST /api/messages/webhook/notify` 供其他应用推送通知消息。
- 使用 SQLite 持久化消息数据。
- 通过 Socket.IO 推送 `messages_updated`，让前端立即刷新消息区。
- 聚合天气、降水和空气质量信息，并通过 Socket.IO 响应 `request_weather`。

## 本地运行

### 1. 启动后端

后端默认监听 `http://127.0.0.1:5000`。

```bash
cd python
uv sync
uv run python app/main.py
```

如果你使用 Docker，也可以直接构建镜像并运行容器。

```bash
cd python
docker compose up -d
```

### 2. 启动 Flutter 前端

```bash
flutter pub get
flutter run -d linux
```

如果需要在其他平台运行，可以把 `-d linux` 替换为对应设备。

## 后端环境变量

后端天气数据依赖 QWeather 配置，常用变量如下：

- `LOCATION`：经纬度，默认 `116.31,40.09`
- `KID`：QWeather key id
- `PROJECT_ID`：QWeather project id
- `PUBLIC_BASE_URL`：对外访问地址，用于生成可访问的图片链接
- `LOCAL_BASE_URL`：本机访问地址，默认 `http://127.0.0.1:5000`

图片上传后会保存在后端的缓存目录，并通过 `/uploads` 对外提供访问。

## 接口一览

- `GET /api/messages`：获取消息列表
- `POST /api/messages`：创建文本、图片或通知消息记录
- `POST /api/messages/upload-image`：上传图片并生成图片消息
- `POST /api/messages/webhook/notify`：其他应用通过 webhook 创建通知消息
- `POST /api/messages/clear`：清空消息和已上传文件

## 说明

- 首次运行时，请确保后端依赖和 QWeather 私钥文件已正确配置。
- 消息区目前支持文本和图片两种类型，后续可以继续扩展更多卡片组件。
- 如果你计划把它部署到独立屏幕设备，建议把后端和前端放在同一局域网内，并配置可访问的 `PUBLIC_BASE_URL`。
