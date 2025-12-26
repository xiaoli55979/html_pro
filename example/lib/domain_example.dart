import 'package:flutter/material.dart';
import 'package:html_pro/html_pro.dart';

class DomainExample extends StatefulWidget {
  const DomainExample({super.key});

  @override
  State<DomainExample> createState() => _DomainExampleState();
}

class _DomainExampleState extends State<DomainExample> {
  String _message = '';
  String _currentBaseUrl = 'https://cdn.example.com';

  // 示例HTML内容，包含不同类型的图片URL
  final String htmlContent = '''
    <div>
      <h1>BaseUrl 替换示例</h1>
      <p>以下图片展示了baseUrl替换功能：</p>
      
      <h3>绝对路径图片（会替换域名）：</h3>
      <img src="https://old-domain.com/images/image1.jpg" alt="图片1" width="200" />
      <p>原始URL: https://old-domain.com/images/image1.jpg</p>
      
      <h3>相对路径图片（会拼接baseUrl）：</h3>
      <img src="/assets/image2.jpg" alt="图片2" width="200" />
      <p>原始URL: /assets/image2.jpg</p>
      
      <h3>Flutter官方图片（域名会被替换）：</h3>
      <img src="https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg" alt="Flutter图片" width="200" />
      <p>原始URL: https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg</p>
      
      <h3>相对路径图片2：</h3>
      <img src="images/logo.png" alt="Logo" width="150" />
      <p>原始URL: images/logo.png</p>
    </div>
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BaseUrl 替换示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // BaseUrl 配置区域
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '当前 BaseUrl: $_currentBaseUrl',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '所有图片的域名都会被替换为这个BaseUrl',
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // 消息显示区域
          if (_message.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                _message,
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // 控制按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _changeBaseUrl('https://cdn.example.com'),
                    child: const Text('CDN 1'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _changeBaseUrl('https://assets.mysite.com'),
                    child: const Text('CDN 2'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _changeBaseUrl('https://img.newdomain.net'),
                    child: const Text('CDN 3'),
                  ),
                ),
              ],
            ),
          ),

          // HTML内容显示区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FlutterHtmlPro(
                data: htmlContent,
                // 设置图片基础URL
                imageBaseUrl: _currentBaseUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeBaseUrl(String newBaseUrl) {
    setState(() {
      _currentBaseUrl = newBaseUrl;
      _message = '''BaseUrl 已更改为: $newBaseUrl

URL转换示例:
• https://old-domain.com/image.jpg → $newBaseUrl/image.jpg
• /assets/logo.png → $newBaseUrl/assets/logo.png
• images/icon.png → $newBaseUrl/images/icon.png''';
    });
  }
}
