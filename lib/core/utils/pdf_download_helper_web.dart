// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web implementation for downloading PDF assets.
///
/// For cross-origin URLs (e.g. Supabase Storage), the HTML `download` attribute
/// on anchor elements is ignored by browsers. To force an actual download we
/// fetch the file as a Blob via XMLHttpRequest, create a same-origin Blob URL,
/// and trigger the download from that URL.
void downloadPdfFile(String assetPath, String downloadName) {
  _downloadRemotePdf(assetPath, downloadName);
}

/// Downloads a remote (cross-origin) PDF by fetching it as a blob first.
void _downloadRemotePdf(String url, String downloadName) {
  final request = html.HttpRequest()
    ..open('GET', url)
    ..responseType = 'blob';

  request.onLoad.listen((_) {
    final blob = request.response as html.Blob;
    final blobUrl = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: blobUrl)
      ..setAttribute('download', downloadName)
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(blobUrl);
  });

  request.onError.listen((_) {
    // Fallback: open URL directly if fetch fails
    html.window.open(url, '_blank');
  });

  request.send();
}

/// Web implementation for opening PDF assets in a new browser tab.
void openPdfInNewTabFile(String assetPath) {
  html.window.open(assetPath, '_blank');
}
