import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_texts.dart';
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
        eyebrow: AppTexts.contactEyebrow,
        title: AppTexts.contactTitle,
        subtitle: AppTexts.contactBody,
        trailing: widget.showBackButton
            ? AppButton(
                label: AppTexts.commonBack,
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
          AppTexts.contactDirectContact,
          style: AppFonts.title(bp).copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSizes.s16),

        // Email card
        AppCard(
          onPressed: () =>
              _launchUrlString(widget.repository.email, isEmail: true),
          semanticLabel: AppTexts.contactEmail,
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
                      AppTexts.contactEmail,
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
          semanticLabel: AppTexts.contactPhone,
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
                      AppTexts.contactPhone,
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
          AppTexts.contactSocials,
          style: AppFonts.title(bp).copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSizes.s16),

        // GitHub Card
        AppCard(
          onPressed: () => _launchUrlString(widget.repository.githubUrl),
          semanticLabel: AppTexts.contactGithub,
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
                      AppTexts.contactGithub,
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
          semanticLabel: AppTexts.contactLinkedin,
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
                      AppTexts.contactLinkedin,
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
                  state.successMessage ?? AppTexts.contactSuccess,
                ),
                backgroundColor: scheme.primary,
              ),
            );
          } else if (state.status == ContactStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? AppTexts.contactError,
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
                  AppTexts.contactPageTitle,
                  style: AppFonts.title(bp).copyWith(color: scheme.onSurface),
                ),
                const SizedBox(height: AppSizes.s24),

                // Name field
                TextFormField(
                  controller: _nameController,
                  enabled: !isSending,
                  decoration: const InputDecoration(
                    labelText: AppTexts.contactName,
                    hintText: AppTexts.contactNameHint,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppTexts.contactValidationRequired;
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
                  decoration: const InputDecoration(
                    labelText: AppTexts.contactEmail,
                    hintText: AppTexts.contactEmailHint,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppTexts.contactValidationRequired;
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
                  decoration: const InputDecoration(
                    labelText: AppTexts.contactMessage,
                    hintText: AppTexts.contactMessageHint,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.chat_bubble_outline),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppTexts.contactValidationRequired;
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
                      ? AppTexts.contactSending
                      : AppTexts.contactSend,
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
