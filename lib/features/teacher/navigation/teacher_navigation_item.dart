import 'package:flutter/material.dart';

enum TeacherSection {
  dashboard,
  groups,
  schedule,
  lessons,
  students,
  profile,
}

extension TeacherSectionDetails on TeacherSection {
  String get label => switch (this) {
        TeacherSection.dashboard => 'الرئيسية',
        TeacherSection.groups => 'مجموعاتي',
        TeacherSection.schedule => 'الجدول',
        TeacherSection.lessons => 'الحصص',
        TeacherSection.students => 'الطلاب',
        TeacherSection.profile => 'حسابي',
      };

  IconData get icon => switch (this) {
        TeacherSection.dashboard => Icons.dashboard_outlined,
        TeacherSection.groups => Icons.category_outlined,
        TeacherSection.schedule => Icons.calendar_month_outlined,
        TeacherSection.lessons => Icons.menu_book_outlined,
        TeacherSection.students => Icons.groups_outlined,
        TeacherSection.profile => Icons.person_outline,
      };
}
