# html_pro

An enhanced Flutter HTML widget with cached network images, link long press support, and image URL base path replacement.

## Features

- 🖼️ **Cached Network Images**: Automatically cache network images with loading indicators
- 🔗 **Link Long Press**: Support for long press callbacks on links with position information
- 🌐 **Image URL Replacement**: Replace image URLs with custom base URLs for CDN or proxy support
- ⚡ **Performance Optimized**: Built on top of flutter_html with enhanced functionality

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  html_pro: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:html_pro/html_pro.dart';

FlutterHtmlPro(
  data: '''
    <h1>Hello World</h1>
    <p>This is a paragraph with an <a href="https://flutter.dev">link</a></p>
    <img src="https://example.com/image.jpg" alt="Example Image">
  ''',
)
```

### With Link Long Press Support

```dart
FlutterHtmlPro(
  data: htmlContent,
  onLinkTap: (url, attributes, element) {
    print('Link tapped: $url');
  },
  onLinkLongPress: (url, attributes, element, position) {
    print('Link long pressed: $url at position: $position');
    // Show context menu or perform custom action
  },
)
```

### With Image URL Base Path Replacement

```dart
FlutterHtmlPro(
  data: '''
    <img src="/images/photo.jpg" alt="Photo">
    <img src="https://old-domain.com/image.png" alt="Image">
  ''',
  imageBaseUrl: 'https://cdn.example.com',
  // This will transform:
  // "/images/photo.jpg" -> "https://cdn.example.com/images/photo.jpg"
  // "https://old-domain.com/image.png" -> "https://cdn.example.com/image.png"
)
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:html_pro/html_pro.dart';

class HtmlProExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HTML Pro Example')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: FlutterHtmlPro(
          data: '''
            <h1>Enhanced HTML Widget</h1>
            <p>This widget supports:</p>
            <ul>
              <li>Cached network images</li>
              <li>Link long press callbacks</li>
              <li>Image URL replacement</li>
            </ul>
            <p>Try long pressing this <a href="https://flutter.dev">Flutter link</a></p>
            <img src="/assets/flutter-logo.png" alt="Flutter Logo">
          ''',
          imageBaseUrl: 'https://storage.googleapis.com/cms-storage-bucket',
          onLinkTap: (url, attributes, element) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped: $url')),
            );
          },
          onLinkLongPress: (url, attributes, element, position) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Link Long Pressed'),
                content: Text('URL: $url\nPosition: $position'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## API Reference

### FlutterHtmlPro

All parameters from the original `Html` widget are supported, plus:

| Parameter | Type | Description |
|-----------|------|-------------|
| `onLinkLongPress` | `Function(String?, Map<String, String>, dom.Element?, Offset)?` | Callback for link long press events |
| `imageBaseUrl` | `String?` | Base URL for image URL replacement |

### Image URL Replacement Logic

- **Relative URLs**: `/path/image.jpg` → `{baseUrl}/path/image.jpg`
- **Absolute URLs**: `https://old.com/image.jpg` → `https://new-base.com/image.jpg` (domain replacement)
- **Invalid URLs**: Returns original URL without modification

## Dependencies

This package depends on:
- [flutter_html](https://pub.dev/packages/flutter_html) - Core HTML rendering
- [cached_network_image](https://pub.dev/packages/cached_network_image) - Image caching
- [flutter_spinkit](https://pub.dev/packages/flutter_spinkit) - Loading indicators
- [html](https://pub.dev/packages/html) - HTML parsing

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

