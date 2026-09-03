import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.g.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../home/presentation/widgets/footer_widget.dart';
import '../bloc/cv_cubit.dart';

class CvView extends StatelessWidget {
  const CvView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CvCubit(),
      child: AppScaffold(
        body: ListView(
          children: [
            AppSection(
              id: 'cv',
              eyebrow: LocaleKeys.nav_cv.tr(),
              title: LocaleKeys.cv_title.tr(),
              subtitle: LocaleKeys.cv_body.tr(),
              trailing: AppButton(
                label: LocaleKeys.common_back.tr(),
                variant: AppButtonVariant.ghost,
                icon: Icons.arrow_back,
                onPressed: () => context.goNamed(AppRoutes.home),
              ),
              child: const _CvActionsCard(),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

class _CvActionsCard extends StatelessWidget {
  const _CvActionsCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bp = breakpointOf(constraints);
        final compact = bp == AppBreakpoint.mobile;
        final cubit = context.read<CvCubit>();

        return AppCard(
          child: Padding(
            padding: EdgeInsets.all(
              compact ? AppSizes.s16 : AppSizes.s24,
            ),
            child: Wrap(
              spacing: AppSizes.s16,
              runSpacing: AppSizes.s16,
              children: [
                SizedBox(
                  width: compact ? double.infinity : null,
                  child: AppButton(
                    label: LocaleKeys.cv_view.tr(),
                    icon: Icons.open_in_new,
                    expanded: compact,
                    onPressed: () => cubit.openCvInNewTab(),
                  ),
                ),
                SizedBox(
                  width: compact ? double.infinity : null,
                  child: AppButton(
                    label: LocaleKeys.cv_download.tr(),
                    icon: Icons.download,
                    variant: AppButtonVariant.secondary,
                    expanded: compact,
                    onPressed: () => cubit.downloadCv(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
