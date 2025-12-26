import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CachedImageExtension extends HtmlExtension {
  /// 图片基础URL，用于替换图片URL的域名部分
  final String? baseUrl;

  const CachedImageExtension({
    this.baseUrl,
  });

  @override
  Set<String> get supportedTags => {"img"};

  @override
  InlineSpan build(ExtensionContext context) {
    final attributes = context.attributes;
    final src = attributes['src'] ?? '';

    // 处理URL替换
    String newUrl = _processUrl(src);

    return WidgetSpan(
      child: CachedNetworkImage(
        imageUrl: newUrl,
        placeholder: (context, url) => const Center(
          child: SpinKitFadingCircle(
            color: Colors.grey,
            size: 20.0,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  /// 处理URL替换逻辑
  String _processUrl(String originalUrl) {
    if (originalUrl.isEmpty || baseUrl == null || baseUrl!.isEmpty) {
      return originalUrl;
    }

    try {
      final uri = Uri.parse(originalUrl);

      // 如果是相对路径，直接拼接baseUrl
      if (!uri.hasScheme) {
        return _joinUrl(baseUrl!, originalUrl);
      }

      // 如果是绝对路径，替换域名部分
      final newUri = Uri.parse(baseUrl!);
      final replacedUri = uri.replace(
        scheme: newUri.scheme,
        host: newUri.host,
        port: newUri.port,
      );

      return replacedUri.toString();
    } catch (e) {
      // 如果URL解析失败，返回原始URL
      return originalUrl;
    }
  }

  /// 拼接URL
  String _joinUrl(String base, String path) {
    final baseUri = Uri.parse(base);
    final pathUri = Uri.parse(path);

    return baseUri.resolve(pathUri.path).toString();
  }
}
