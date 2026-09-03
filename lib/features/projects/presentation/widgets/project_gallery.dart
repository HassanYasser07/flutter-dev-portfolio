import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/responsive.dart';

/// Interactive Image Gallery widget supporting pinch/mouse zoom, panning,
/// keyboard arrow navigation, page counter, and prev/next controls.
class ProjectGalleryWidget extends StatefulWidget {
  const ProjectGalleryWidget({
    super.key,
    required this.screenshots,
    this.initialIndex = 0,
    this.height = 500,
  });

  final List<String> screenshots;
  final int initialIndex;
  final double height;

  @override
  State<ProjectGalleryWidget> createState() => _ProjectGalleryWidgetState();
}

class _ProjectGalleryWidgetState extends State<ProjectGalleryWidget> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(
      0,
      widget.screenshots.isEmpty ? 0 : widget.screenshots.length - 1,
    );
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: AppMotion.quick,
        curve: AppMotion.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_currentIndex < widget.screenshots.length - 1) {
      _pageController.nextPage(
        duration: AppMotion.quick,
        curve: AppMotion.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bp = breakpointOf(
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width));

    if (widget.screenshots.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: scheme.outline),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSizes.s12),
              Text(
                'No screenshots available for this project',
                style: AppFonts.bodySmall(bp).copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final hasMultiple = widget.screenshots.length > 1;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _previousPage();
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _nextPage();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Column(
        children: [
          // Counter & Control Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s16,
              vertical: AppSizes.s8,
            ),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: scheme.outline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Screenshot ${_currentIndex + 1} of ${widget.screenshots.length}',
                  style: theme.textTheme.labelMedium,
                ),
                if (hasMultiple)
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Previous Screenshot (Left Arrow)',
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentIndex > 0 ? _previousPage : null,
                      ),
                      IconButton(
                        tooltip: 'Next Screenshot (Right Arrow)',
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _currentIndex < widget.screenshots.length - 1
                            ? _nextPage
                            : null,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s12),

          // PhotoView Gallery Container
          Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: scheme.outline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    final assetPath = widget.screenshots[index];
                    return PhotoViewGalleryPageOptions(
                      imageProvider: AssetImage(assetPath),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2.5,
                      heroAttributes: PhotoViewHeroAttributes(tag: assetPath),
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: scheme.surfaceContainerHighest,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  size: 44,
                                  color: scheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: AppSizes.s8),
                                Text(
                                  'Image asset not found',
                                  style: AppFonts.label(bp).copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: widget.screenshots.length,
                  loadingBuilder: (context, event) => Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? null
                            : event.cumulativeBytesLoaded /
                                (event.expectedTotalBytes ?? 1),
                      ),
                    ),
                  ),
                  backgroundDecoration: BoxDecoration(
                    color: scheme.surfaceContainerLowest,
                  ),
                  pageController: _pageController,
                  onPageChanged: _onPageChanged,
                ),

                // Floating Side Navigation Arrows (for desktop / mouse navigation)
                if (hasMultiple && bp != AppBreakpoint.mobile) ...[
                  Positioned(
                    left: AppSizes.s16,
                    child: IconButton.filledTonal(
                      tooltip: 'Previous',
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _currentIndex > 0 ? _previousPage : null,
                    ),
                  ),
                  Positioned(
                    right: AppSizes.s16,
                    child: IconButton.filledTonal(
                      tooltip: 'Next',
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _currentIndex < widget.screenshots.length - 1
                          ? _nextPage
                          : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
