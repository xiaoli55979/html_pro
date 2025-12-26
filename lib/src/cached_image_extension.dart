import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/src/extension/html_extension.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CachedImageExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {"img"};

  @override
  InlineSpan build(ExtensionContext context) {
    final attributes = context.attributes;
    final src = attributes['src'] ?? '';

    /// 使用api域名替换
    String newUrl = src;//UrlHandleTools.updateDomain(src);
    return WidgetSpan(
      child: CachedNetworkImage(
        imageUrl: newUrl,
        placeholder: (context, url) => const Center(
          child: SpinKitFadingCircle(
            color: Colors.grey,
            size: 20.0,
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
