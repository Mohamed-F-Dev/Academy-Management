import 'package:flutter/material.dart';

import '../../../../../shared/widgets/management_widgets.dart';

class AcademyPage extends StatelessWidget {
  const AcademyPage({super.key});
  @override
  Widget build(BuildContext context) => const PageFrame(
    title: 'الأكاديمية',
    subtitle: 'بيانات الأكاديمية',
    child: EmptyState(
      message: 'استخدم صفحة الإعدادات لتعديل بيانات الأكاديمية',
    ),
  );
}
