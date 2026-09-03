import 'package:flutter/material.dart';

import '../../features/home/presentation/widgets/nav_bar.dart';
import '../constants/app_sizes.dart';
import '../utils/responsive.dart';

/// Shared chrome: sticky nav wrapping a page body.
/// Pages that scroll (home) put [FooterWidget] at the end of their scroll view.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.scrollController,
  });

  final Widget body;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final compact = bp == AppBreakpoint.mobile;

        return BreakpointScope(
          breakpoint: bp,
          constraints: constraints,
          child: Scaffold(
            drawer: compact ? const NavDrawer() : null,
            body: Column(
              children: [
                NavBar(
                  compact: compact,
                  onLogoPressed: () {
                    final controller = scrollController;
                    if (controller != null && controller.hasClients) {
                      controller.animateTo(
                        0,
                        duration: AppMotion.medium,
                        curve: AppMotion.easeInOut,
                      );
                    }
                  },
                ),
                Expanded(child: body),
              ],
            ),
          ),
        );
      },
    );
  }
}
