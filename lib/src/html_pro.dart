import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'cached_image_extension.dart';

class HtmlPro extends Html {
  /// 长按回调，返回链接和坐标
  final void Function(String?, Map<String, String>, dom.Element?, Offset)? onLinkLongPress;

  HtmlPro({
    Key? key,
    required String data,
    GlobalKey? anchorKey,
    OnTap? onLinkTap,
    this.onLinkLongPress,
    List<HtmlExtension> extensions = const [],
    OnCssParseError? onCssParseError,
    bool shrinkWrap = false,
    List<String>? onlyRenderTheseTags,
    List<String>? doNotRenderTheseTags,
    Map<String, Style> style = const {},
  }) : super(
          key: key,
          data: data,
          anchorKey: anchorKey,
          onLinkTap: onLinkTap,
          onCssParseError: onCssParseError,
          shrinkWrap: shrinkWrap,
          onlyRenderTheseTags: onlyRenderTheseTags?.toSet(),
          doNotRenderTheseTags: doNotRenderTheseTags?.toSet(),
          style: style,
          extensions: [
            ...extensions,
            CachedImageExtension(),
            TagExtension(
              tagsToExtend: {"a"},
              builder: (extensionContext) {
                final context = extensionContext.buildContext;
                if (context == null) return SizedBox.shrink(); // 处理可能为空的 context

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
                      onLinkLongPress(url, attributes, extensionContext.element, details.globalPosition);
                    }
                  },
                  child: Text(
                    extensionContext.element?.text ?? "",
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                );
              },
            ),
          ],
        );
}
