import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../bloc/scroll_cubit.dart';
import '../bloc/scroll_state.dart';
import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/footer_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ScrollController _controller;
  late final Map<HomeSection, GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _keys = {
      for (final section in HomeSection.values) section: GlobalKey(),
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisible(HomeSection section, VisibilityInfo info) {
    if (info.visibleFraction > 0.35) {
      context.read<ScrollCubit>().setActive(section);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeAnchorScope(
      controller: _controller,
      keys: _keys,
      child: AppScaffold(
        scrollController: _controller,
        body: CustomScrollView(
          controller: _controller,
          slivers: [
            _sectionSliver(HomeSection.hero, const HeroSection()),
            _sectionSliver(HomeSection.about, const AboutSection()),
            _sectionSliver(HomeSection.skills, const SkillsSection()),
            _sectionSliver(HomeSection.projects, const ProjectsSection()),
            _sectionSliver(HomeSection.experience, const ExperienceSection()),
            _sectionSliver(HomeSection.contact, const ContactSection()),
            SliverToBoxAdapter(
              child: FooterWidget(
                onBackToTop: () => _controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionSliver(HomeSection section, Widget child) {
    return SliverToBoxAdapter(
      child: KeyedSubtree(
        key: _keys[section],
        child: VisibilityDetector(
          key: Key('section-${section.name}'),
          onVisibilityChanged: (info) => _onVisible(section, info),
          child: child,
        ),
      ),
    );
  }
}
