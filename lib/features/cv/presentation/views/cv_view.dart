import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../home/presentation/bloc/about_cubit.dart';
import '../../../home/presentation/widgets/footer_widget.dart';
import '../bloc/cv_cubit.dart';

class CvView extends StatelessWidget {
  const CvView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView(
        children: [
          AppSection(
            id: 'cv',
            eyebrow: AppTexts.navCv,
            title: AppTexts.cvTitle,
            subtitle: AppTexts.cvBody,
            trailing: AppButton(
              label: AppTexts.commonBack,
              variant: AppButtonVariant.ghost,
              icon: Icons.arrow_back,
              onPressed: () => context.goNamed(AppRoutes.home),
            ),
            child: const _CvActionsCard(),
          ),
          const FooterWidget(),
        ],
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
        final about = context.watch<AboutCubit>().state.about;

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
                    label: AppTexts.cvView,
                    icon: Icons.open_in_new,
                    expanded: compact,
                    onPressed: () => cubit.openCvInNewTab(about?.cvUrl),
                  ),
                ),
                SizedBox(
                  width: compact ? double.infinity : null,
                  child: AppButton(
                    label: AppTexts.cvDownload,
                    icon: Icons.download,
                    variant: AppButtonVariant.secondary,
                    expanded: compact,
                    onPressed: () => cubit.downloadCv(about?.cvUrl),
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
