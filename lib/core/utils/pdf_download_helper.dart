import 'pdf_download_helper_stub.dart'
    if (dart.library.html) 'pdf_download_helper_web.dart' as impl;

abstract class PdfDownloadHelper {
  const PdfDownloadHelper._();

  /// Triggers a download of the PDF at [assetPath] under the filename [downloadName].
  static void downloadPdf(String assetPath, String downloadName) {
    impl.downloadPdfFile(assetPath, downloadName);
  }

  /// Opens the PDF at [assetPath] in a new browser tab.
  static void openInNewTab(String assetPath) {
    impl.openPdfInNewTabFile(assetPath);
  }
}
