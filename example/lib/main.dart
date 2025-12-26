import 'package:flutter/material.dart';
import 'package:html_pro/html_pro.dart';
import 'domain_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Html Pro 示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HtmlProExample(),
    );
  }
}

class HtmlProExample extends StatefulWidget {
  const HtmlProExample({super.key});

  @override
  State<HtmlProExample> createState() => _HtmlProExampleState();
}

class _HtmlProExampleState extends State<HtmlProExample> {
  String _message = '';

  // 示例HTML内容
  final String htmlContent = '''
    <div>
      <h1>Html Pro 示例</h1>
      <p>这是一个 <strong>Html Pro</strong> 的示例应用。</p>
      
      <h2>功能特性：</h2>
      <ul>
        <li>支持基本的HTML标签渲染</li>
        <li>支持图片缓存显示</li>
        <li>支持链接点击和长按事件</li>
        <li>支持图片域名替换</li>
        <li>自定义样式支持</li>
      </ul>
      
      <h3>链接示例：</h3>
      <p>点击这个链接：<a href="https://flutter.dev">Flutter官网</a></p>
      <p>长按这个链接试试：<a href="https://pub.dev">Pub.dev</a></p>
      
      <h3>图片示例：</h3>
      <img src="https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg" alt="示例图片" width="200" />
      
      <h3>样式示例：</h3>
      <p style="color: red; font-size: 18px;">这是红色的大字体文本</p>
      <p style="background-color: yellow; padding: 10px;">这是黄色背景的文本</p>
      
      <blockquote>
        这是一个引用块，展示了Html Pro的渲染能力。
      </blockquote>
      
      <code>这是代码文本示例</code>
    </div>
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Html Pro 示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: '域名替换示例',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DomainExample(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 消息显示区域
          if (_message.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                _message,
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // HTML内容显示区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FlutterHtmlPro(
                data: htmlContent,
                // 链接点击事件
                onLinkTap: (url, attributes, element) {
                  setState(() {
                    _message = '点击了链接: $url';
                  });

                  // 这里可以添加打开链接的逻辑
                  _showLinkDialog(context, '链接点击', url ?? '');
                },
                // 链接长按事件
                onLinkLongPress: (url, attributes, element, offset) {
                  setState(() {
                    _message =
                        '长按了链接: $url (位置: ${offset.dx.toInt()}, ${offset.dy.toInt()})';
                  });

                  _showLinkDialog(context, '链接长按', url ?? '');
                },
                // 图片BaseUrl替换示例（可选）
                imageBaseUrl: 'https://cdn.example.com',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _message = '';
          });
        },
        tooltip: '清除消息',
        child: const Icon(Icons.clear),
      ),
    );
  }

  void _showLinkDialog(BuildContext context, String title, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('链接地址:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  url,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }
}
