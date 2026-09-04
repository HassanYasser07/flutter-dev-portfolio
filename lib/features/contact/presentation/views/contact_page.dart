import 'package:flutter/material.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../home/presentation/widgets/contact_section.dart';
import '../../../home/presentation/widgets/footer_widget.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView(
        children: const [
          ContactSection(showBackButton: true),
          FooterWidget(),
        ],
      ),
    );
  }
}
