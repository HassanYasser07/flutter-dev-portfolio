import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../contact/data/contact_repository.dart';
import '../../../contact/presentation/bloc/contact_cubit.dart';
import '../../../contact/presentation/bloc/contact_state.dart';

/// Clean, responsive Contact section connected to [ContactCubit] & [ContactRepository].
class ContactSection extends StatefulWidget {
  const ContactSection({
    super.key,
    this.showBackButton = false,
    this.repository = const ContactRepository(),
  });

  final bool showBackButton;
  final ContactRepository repository;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
    return BlocProvider(
      create: (context) => ContactCubit(repository: widget.repository),
      child: AppSection(
        id: 'contact',
        eyebrow: LocaleKeys.contact_eyebrow.tr(),
        title: LocaleKeys.contact_title.tr(),
        subtitle: LocaleKeys.contact_body.tr(),
        trailing: widget.showBackButton
            ? AppButton(
                label: LocaleKeys.common_back.tr(),
                variant: AppButtonVariant.ghost,
                icon: Icons.arrow_back,
                onPressed: () => context.goNamed(AppRoutes.home),
              )
            : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bp = breakpointOf(constraints);
            final isDesktop =
                bp == AppBreakpoint.desktop || bp == AppBreakpoint.laptop;
            final animate = shouldAnimate(context);

            Widget child = isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildContactInfo(context, bp),
                      ),
                      const SizedBox(width: AppSizes.s32),
                      Expanded(
                        flex: 3,
                        child: _buildContactForm(context, bp),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildContactInfo(context, bp),
                      const SizedBox(height: AppSizes.s32),
                      _buildContactForm(context, bp),
                    ],
                  );

            if (animate) {
              child = child
                  .animate()
                  .fadeIn(
                    duration: AppMotion.section,
                    curve: AppMotion.easeOutCubic,
                  )
                  .slideY(
                    begin: 0.05,
                    end: 0,
                    duration: AppMotion.section,
                    curve: AppMotion.easeOutCubic,
                  );
            }

            return child;
          },
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, AppBreakpoint bp) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.contact_directContact.tr(),
          style: AppFonts.title(bp).copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSizes.s16),

        // Email card
        AppCard(
          onPressed: () =>
              _launchUrlString(widget.repository.email, isEmail: true),
          semanticLabel: LocaleKeys.contact_email.tr(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.s12),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.email_outlined, color: scheme.primary),
              ),
              const SizedBox(width: AppSizes.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contact_email.tr(),
                      style: AppFonts.label(bp)
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      widget.repository.email,
                      style: AppFonts.body(bp).copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.north_east, size: 18, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s12),

        // Phone / WhatsApp card
        AppCard(
          onPressed: () => _launchUrlString(widget.repository.whatsappUrl),
          semanticLabel: LocaleKeys.contact_phone.tr(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.s12),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.phone_outlined, color: scheme.primary),
              ),
              const SizedBox(width: AppSizes.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contact_phone.tr(),
                      style: AppFonts.label(bp)
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      widget.repository.phone,
                      style: AppFonts.body(bp).copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, size: 18, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s24),

        Text(
          LocaleKeys.contact_socials.tr(),
          style: AppFonts.title(bp).copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSizes.s16),

        // GitHub Card
        AppCard(
          onPressed: () => _launchUrlString(widget.repository.githubUrl),
          semanticLabel: LocaleKeys.contact_github.tr(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.s12),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.code, color: scheme.primary),
              ),
              const SizedBox(width: AppSizes.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contact_github.tr(),
                      style: AppFonts.label(bp)
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      widget.repository.githubUrl,
                      style: AppFonts.body(bp).copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, size: 18, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s12),

        // LinkedIn Card
        AppCard(
          onPressed: () => _launchUrlString(widget.repository.linkedinUrl),
          semanticLabel: LocaleKeys.contact_linkedin.tr(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.s12),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.work_outline, color: scheme.primary),
              ),
              const SizedBox(width: AppSizes.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contact_linkedin.tr(),
                      style: AppFonts.label(bp)
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      widget.repository.linkedinUrl,
                      style: AppFonts.body(bp).copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, size: 18, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context, AppBreakpoint bp) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      child: BlocConsumer<ContactCubit, ContactState>(
        listener: (context, state) {
          if (state.status == ContactStatus.success) {
            _nameController.clear();
            _emailController.clear();
            _messageController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.successMessage ?? LocaleKeys.contact_success.tr(),
                ),
                backgroundColor: scheme.primary,
              ),
            );
          } else if (state.status == ContactStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? LocaleKeys.contact_error.tr(),
                ),
                backgroundColor: scheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSending = state.status == ContactStatus.sending;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.contact_pageTitle.tr(),
                  style: AppFonts.title(bp).copyWith(color: scheme.onSurface),
                ),
                const SizedBox(height: AppSizes.s24),

                // Name field
                TextFormField(
                  controller: _nameController,
                  enabled: !isSending,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.contact_name.tr(),
                    hintText: LocaleKeys.contact_nameHint.tr(),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return LocaleKeys.contact_validationRequired.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.s16),

                // Email field
                TextFormField(
                  controller: _emailController,
                  enabled: !isSending,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.contact_email.tr(),
                    hintText: LocaleKeys.contact_emailHint.tr(),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return LocaleKeys.contact_validationRequired.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.s16),

                // Message field
                TextFormField(
                  controller: _messageController,
                  enabled: !isSending,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.contact_message.tr(),
                    hintText: LocaleKeys.contact_messageHint.tr(),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.chat_bubble_outline),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return LocaleKeys.contact_validationRequired.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.s24),

                // Inline Feedback Messages
                if (state.status == ContactStatus.success &&
                    state.successMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSizes.s12),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: scheme.primary),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: scheme.primary),
                        const SizedBox(width: AppSizes.s8),
                        Expanded(
                          child: Text(
                            state.successMessage!,
                            style: AppFonts.bodySmall(bp)
                                .copyWith(color: scheme.onSurface),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                ],

                if (state.status == ContactStatus.error &&
                    state.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSizes.s12),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: scheme.error),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: scheme.error),
                        const SizedBox(width: AppSizes.s8),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: AppFonts.bodySmall(bp)
                                .copyWith(color: scheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                ],

                // Submit Button
                AppButton(
                  label: isSending
                      ? LocaleKeys.contact_sending.tr()
                      : LocaleKeys.contact_send.tr(),
                  variant: AppButtonVariant.primary,
                  icon: isSending ? null : Icons.send,
                  expanded: bp == AppBreakpoint.mobile,
                  onPressed: isSending
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<ContactCubit>().sendMessage(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  message: _messageController.text,
                                );
                          }
                        },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
