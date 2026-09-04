import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../contact/data/contact_repository.dart';

/// Clean portfolio footer with branding, social links, copyright, and smooth back-to-top button.
class FooterWidget extends StatelessWidget {
  const FooterWidget({
    super.key,
    this.onBackToTop,
    this.repository = const ContactRepository(),
  });

  final VoidCallback? onBackToTop;
  final ContactRepository repository;

  Future<void> _launchUrlString(String urlString,
      {bool isEmail = false}) async {
    final uri =
        isEmail ? Uri.parse('mailto:$urlString') : Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: isEmail
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final compact =
            bp == AppBreakpoint.mobile || bp == AppBreakpoint.tablet;
        final hPad = horizontalPaddingOf(constraints);

        final brandInfo = Column(
          crossAxisAlignment:
              compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.app_name.tr(),
              style: AppFonts.button(bp).copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.s4),
            Text(
              LocaleKeys.footer_copyright.tr(),
              style: AppFonts.bodySmall(bp).copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        );

        final socialLinks = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              icon: Icons.email_outlined,
              tooltip: LocaleKeys.contact_email.tr(),
              onPressed: () =>
                  _launchUrlString(repository.email, isEmail: true),
            ),
            const SizedBox(width: AppSizes.s8),
            AppIconButton(
              icon: Icons.code,
              tooltip: LocaleKeys.contact_github.tr(),
              onPressed: () => _launchUrlString(repository.githubUrl),
            ),
            const SizedBox(width: AppSizes.s8),
            AppIconButton(
              icon: Icons.work_outline,
              tooltip: LocaleKeys.contact_linkedin.tr(),
              onPressed: () => _launchUrlString(repository.linkedinUrl),
            ),
          ],
        );

        final backToTopBtn = onBackToTop == null
            ? const SizedBox.shrink()
            : AppIconButton(
                icon: Icons.arrow_upward,
                tooltip: LocaleKeys.footer_backToTop.tr(),
                onPressed: onBackToTop,
              );

        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: scheme.outline)),
          ),
          child: Align(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppSizes.maxWideWidth),
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(hPad, AppSizes.s32, hPad, AppSizes.s32),
                child: compact
                    ? Column(
                        children: [
                          brandInfo,
                          const SizedBox(height: AppSizes.s16),
                          socialLinks,
                          const SizedBox(height: AppSizes.s16),
                          backToTopBtn,
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: brandInfo),
                          socialLinks,
                          const SizedBox(width: AppSizes.s24),
                          backToTopBtn,
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
