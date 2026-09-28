import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../views/teacher_dashboard_view.dart';
import '../views/teacher_groups_view.dart';
import '../views/teacher_lessons_view.dart';
import '../views/teacher_profile_view.dart';
import '../views/teacher_schedule_view.dart';
import '../views/teacher_students_view.dart';
import 'cubit/teacher_navigation_cubit.dart';
import 'teacher_navigation_item.dart';

class TeacherShell extends StatelessWidget {
  const TeacherShell({super.key});

  static const _views = <Widget>[
    TeacherDashboardView(),
    TeacherGroupsView(),
    TeacherScheduleView(),
    TeacherLessonsView(),
    TeacherStudentsView(),
    TeacherProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<TeacherNavigationCubit, TeacherSection>(
        builder: (context, section) => LayoutBuilder(
          builder: (context, constraints) {
            final mobile = constraints.maxWidth < 700;
            final tablet =
                constraints.maxWidth >= 700 && constraints.maxWidth < 1050;
            return Scaffold(
              appBar: mobile
                  ? AppBar(
                      title: const Text('أكاديمية منارة'),
                      actions: const [_TeacherAvatar()],
                    )
                  : null,
              body: mobile
                  ? _MobileTeacherLayout(section: section, views: _views)
                  : Row(
                      children: [
                        if (tablet)
                          _TabletNavigation(section: section)
                        else
                          _DesktopNavigation(section: section),
                        Expanded(
                          child: Column(
                            children: [
                              const _TeacherTopBar(),
                              Expanded(
                                child: IndexedStack(
                                  index: section.index,
                                  children: _views,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _MobileTeacherLayout extends StatelessWidget {
  const _MobileTeacherLayout({required this.section, required this.views});
  final TeacherSection section;
  final List<Widget> views;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: IndexedStack(index: section.index, children: views),
      ),
      NavigationBar(
        selectedIndex: section.index > 3 ? 4 : section.index,
        onDestinationSelected: (index) {
          if (index == 4) {
            _showMore(context);
          } else {
            context.read<TeacherNavigationCubit>().select(
              TeacherSection.values[index],
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            label: 'مجموعاتي',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'الجدول',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'الحصص',
          ),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'المزيد'),
        ],
      ),
    ],
  );

  void _showMore(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('الطلاب'),
              onTap: () {
                Navigator.pop(context);
                context.read<TeacherNavigationCubit>().select(
                  TeacherSection.students,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('حسابي'),
              onTap: () {
                Navigator.pop(context);
                context.read<TeacherNavigationCubit>().select(
                  TeacherSection.profile,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthCubit>().logout();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TabletNavigation extends StatelessWidget {
  const _TabletNavigation({required this.section});
  final TeacherSection section;

  @override
  Widget build(BuildContext context) => NavigationRail(
    backgroundColor: AppTheme.sidebarSurface,
    selectedIndex: section.index,
    onDestinationSelected: (index) => context
        .read<TeacherNavigationCubit>()
        .select(TeacherSection.values[index]),
    labelType: NavigationRailLabelType.all,
    selectedIconTheme: const IconThemeData(color: Color(0xFFE4B08C)),
    unselectedIconTheme: const IconThemeData(color: Color(0xFFB9CED0)),
    selectedLabelTextStyle: const TextStyle(color: Colors.white, fontSize: 10),
    unselectedLabelTextStyle: const TextStyle(
      color: Color(0xFFD1DFE0),
      fontSize: 10,
    ),
    destinations: TeacherSection.values
        .map(
          (item) => NavigationRailDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.icon),
            label: Text(item.label),
          ),
        )
        .toList(),
  );
}

class _DesktopNavigation extends StatelessWidget {
  const _DesktopNavigation({required this.section});
  final TeacherSection section;

  @override
  Widget build(BuildContext context) => Container(
    width: 138,
    color: AppTheme.sidebarSurface,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFE3A17D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'م',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 7),
            const Text(
              'منارة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'مساحة المدرس',
          style: TextStyle(color: Color(0xFFAFC5C9), fontSize: 8),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: ListView(
            children: TeacherSection.values
                .map(
                  (item) =>
                      _DesktopNavItem(item: item, selected: item == section),
                )
                .toList(),
          ),
        ),
        const Divider(color: Color(0x335A8088)),
        _DesktopNavItem(
          item: TeacherSection.profile,
          selected: section == TeacherSection.profile,
          extraLabel: 'حسابي',
        ),
      ],
    ),
  );
}

class _DesktopNavItem extends StatelessWidget {
  const _DesktopNavItem({
    required this.item,
    required this.selected,
    this.extraLabel,
  });
  final TeacherSection item;
  final bool selected;
  final String? extraLabel;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: ListTile(
      selected: selected,
      selectedTileColor: const Color(0x332C8580),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      leading: Icon(
        item.icon,
        size: 17,
        color: selected ? const Color(0xFFE4B08C) : const Color(0xFFB9CED0),
      ),
      title: Text(
        extraLabel ?? item.label,
        style: TextStyle(
          fontSize: 11,
          color: selected ? Colors.white : const Color(0xFFD1DFE0),
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => context.read<TeacherNavigationCubit>().select(item),
    ),
  );
}

class _TeacherTopBar extends StatelessWidget {
  const _TeacherTopBar();

  @override
  Widget build(BuildContext context) => Container(
    height: 47,
    padding: const EdgeInsets.symmetric(horizontal: 28),
    decoration: const BoxDecoration(
      color: Color(0xFFFFFDFC),
      border: Border(bottom: BorderSide(color: Color(0xFFEAE4DB))),
    ),
    child: Row(
      children: [
        const Text(
          'أكاديمية منارة',
          style: TextStyle(color: AppTheme.muted, fontSize: 10),
        ),
        const Text(
          '  /  ',
          style: TextStyle(color: Color(0xFFC8C2B9), fontSize: 10),
        ),
        const Text(
          'مساحة المدرس',
          style: TextStyle(color: AppTheme.ink, fontSize: 10),
        ),
        const Spacer(),
        const Icon(
          Icons.notifications_none_rounded,
          size: 18,
          color: AppTheme.muted,
        ),
        const SizedBox(width: 16),
        const _TeacherAvatar(),
        const SizedBox(width: 7),
        const Text(
          'أستاذ أحمد',
          style: TextStyle(fontSize: 10, color: AppTheme.ink),
        ),
      ],
    ),
  );
}

class _TeacherAvatar extends StatelessWidget {
  const _TeacherAvatar();

  @override
  Widget build(BuildContext context) => Container(
    width: 23,
    height: 23,
    decoration: BoxDecoration(
      color: const Color(0xFFF4D9CA),
      borderRadius: BorderRadius.circular(7),
    ),
    child: const Center(
      child: Text(
        'أح',
        style: TextStyle(
          color: AppTheme.primary,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
