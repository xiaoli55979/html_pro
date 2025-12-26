import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'cached_image_extension.dart';

class HtmlPro extends Html {
  /// 长按回调，返回链接和坐标
  final void Function(String?, Map<String, String>, dom.Element?, Offset)?
      onLinkLongPress;

  HtmlPro({
    super.key,
    required super.data,
    super.anchorKey,
    super.onLinkTap,
    this.onLinkLongPress,
    List<HtmlExtension> extensions = const [],
    super.onCssParseError,
    super.shrinkWrap = false,
    super.onlyRenderTheseTags,
    super.doNotRenderTheseTags,
    super.style = const {},
    // 新增参数：图片基础URL
    String? imageBaseUrl,
  }) : super(
          extensions: [
            ...extensions,
            CachedImageExtension(
              baseUrl: imageBaseUrl,
            ),
            TagExtension(
              tagsToExtend: {"a"},
              builder: (extensionContext) {
                final context = extensionContext.buildContext;
                if (context == null) {
                  return const SizedBox.shrink(); // 处理可能为空的 context
                }

                final attributes = extensionContext.attributes;
                final url = attributes['href'];

                return GestureDetector(
                  onTap: () {
                    if (onLinkTap != null) {
                      onLinkTap(url, attributes, extensionContext.element);
                    }
                  },
                  onLongPressStart: (details) {
                    if (onLinkLongPress != null) {
                      onLinkLongPress(url, attributes, extensionContext.element,
                          details.globalPosition);
                    }
                  },
                  child: Text(
                    extensionContext.element?.text ?? "",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                );
              },
            ),
          ],
        );
}
