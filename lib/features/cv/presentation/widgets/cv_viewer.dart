import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../data/cv_constants.dart';

class CvViewerWidget extends StatefulWidget {
  const CvViewerWidget({
    super.key,
    this.pdfAssetPath = CvConstants.cvAssetPath,
    this.height = 650,
  });

  final String pdfAssetPath;
  final double height;

  @override
  State<CvViewerWidget> createState() => _CvViewerWidgetState();
}

class _CvViewerWidgetState extends State<CvViewerWidget> {
  late final PdfControllerPinch _pdfController;
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    try {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openAsset(widget.pdfAssetPath),
      );
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            _errorMessage!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s8,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: theme.colorScheme.outline,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $_currentPage of $_totalPages',
                style: theme.textTheme.labelMedium,
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Previous Page',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1
                        ? () => _pdfController.previousPage(
                              duration: AppMotion.quick,
                              curve: AppMotion.easeInOut,
                            )
                        : null,
                  ),
                  IconButton(
                    tooltip: 'Next Page',
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPage < _totalPages
                        ? () => _pdfController.nextPage(
                              duration: AppMotion.quick,
                              curve: AppMotion.easeInOut,
                            )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s12),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          clipBehavior: Clip.antiAlias,
          child: PdfViewPinch(
            controller: _pdfController,
            onDocumentLoaded: (document) {
              setState(() {
                _currentPage = 1;
                _totalPages = document.pagesCount;
              });
            },
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
        ),
      ],
    );
  }
}
