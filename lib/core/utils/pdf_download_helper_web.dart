// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web implementation for downloading PDF assets via anchor element.
void downloadPdfFile(String assetPath, String downloadName) {
  final anchor = html.AnchorElement(href: assetPath)
    ..setAttribute('download', downloadName)
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
}

/// Web implementation for opening PDF assets in a new browser tab.
void openPdfInNewTabFile(String assetPath) {
  html.window.open(assetPath, '_blank');
}
