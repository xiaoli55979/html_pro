# Html Pro 示例应用

这是一个展示 `html_pro` 包功能的示例应用。

## 功能特性

### 🎯 核心功能
- **HTML渲染**: 支持基本的HTML标签渲染
- **图片缓存**: 自动缓存网络图片，提升加载性能
- **链接交互**: 支持链接点击和长按事件
- **域名替换**: 支持图片URL域名替换和自定义处理
- **自定义样式**: 灵活的样式定制系统

### 📱 示例内容
- 标题和段落渲染
- 列表和引用块
- 网络图片显示（带缓存）
- 可交互的链接
- 自定义样式应用
- 代码文本显示
- 域名替换演示

## 使用方法

### 基本用法

```dart
import 'package:html_pro/html_pro.dart';

HtmlPro(
  data: '<p>Hello <strong>World</strong>!</p>',
  onLinkTap: (url, attributes, element) {
    print('点击了链接: $url');
  },
  onLinkLongPress: (url, attributes, element, offset) {
    print('长按了链接: $url');
  },
)
```

### 域名替换功能

#### 基本用法
```dart
HtmlPro(
  data: htmlContent,
  // 设置图片基础URL，所有图片域名都会被替换
  imageBaseUrl: 'https://cdn.example.com',
)
```

#### URL转换规则
- **绝对路径**: `https://old-domain.com/image.jpg` → `https://cdn.example.com/image.jpg`
- **相对路径**: `/assets/logo.png` → `https://cdn.example.com/assets/logo.png`
- **相对路径**: `images/icon.png` → `https://cdn.example.com/images/icon.png`

### 高级用法

```dart
HtmlPro(
  data: htmlContent,
  // 链接点击事件
  onLinkTap: (url, attributes, element) {
    // 处理链接点击
  },
  // 链接长按事件  
  onLinkLongPress: (url, attributes, element, offset) {
    // 处理链接长按，offset为触摸位置
  },
  // 图片BaseUrl替换
  imageBaseUrl: 'https://cdn.example.com',
)
```

## 域名替换功能详解

### 使用场景
- **CDN迁移**: 将旧的CDN域名替换为新的CDN域名
- **环境切换**: 开发/测试/生产环境使用不同的图片服务器
- **协议升级**: HTTP升级为HTTPS
- **参数添加**: 为图片URL添加版本号、缓存参数等

### 配置优先级
1. `imageUrlTransformer` 自定义处理函数（优先级最高）
2. `imageDomainMapping` 域名映射配置
3. 原始URL（无处理）

### 域名映射规则
- 支持完全匹配：`example.com` → `cdn.example.com`
- 支持子域名匹配：`api.example.com` 会匹配 `example.com` 的规则
- 映射按配置顺序进行，找到第一个匹配的规则后停止

## 运行示例

1. 确保已安装 Flutter SDK
2. 在项目根目录运行：
   ```bash
   cd example
   flutter pub get
   flutter run
   ```

## 支持的HTML标签

- 标题: `<h1>`, `<h2>`, `<h3>`, `<h4>`, `<h5>`, `<h6>`
- 段落: `<p>`
- 文本格式: `<strong>`, `<b>`, `<em>`, `<i>`, `<u>`
- 列表: `<ul>`, `<ol>`, `<li>`
- 链接: `<a>`
- 图片: `<img>` (支持网络图片缓存和域名替换)
- 引用: `<blockquote>`
- 代码: `<code>`, `<pre>`
- 容器: `<div>`, `<span>`

## 特色功能

### 🖼️ 图片缓存
- 自动缓存网络图片
- 加载动画指示器
- 错误状态处理

### 🔗 链接交互
- 支持点击事件
- 支持长按事件
- 获取触摸位置坐标

### 🌐 域名替换
- 简单的BaseUrl配置
- 自动替换所有图片域名
- 支持相对路径和绝对路径

### 🎨 样式定制
- 支持CSS样式属性
- 自定义颜色、字体、间距
- 响应式布局支持