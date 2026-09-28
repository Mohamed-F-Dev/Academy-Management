import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  static const adminDashboardBranch = 0;
  static const adminStudentsBranch = 1;
  static const adminTeachersBranch = 2;
  static const adminGroupsBranch = 3;
  static const adminLessonsBranch = 4;
  static const adminAttendanceBranch = 5;
  static const adminPaymentsBranch = 6;
  static const adminReportsBranch = 7;
  static const adminSettingsBranch = 8;
  static const teacherDashboardBranch = 9;
  static const teacherGroupsBranch = 10;
  static const teacherLessonsBranch = 11;
  static const teacherAttendanceBranch = 12;
  static const teacherReportsBranch = 13;

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final isTeacher = authState.role == UserRole.teacher;

    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 720;
    final compact = width >= 720 && width < 850;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),

        appBar: mobile
            ? AppBar(
                backgroundColor: const Color(0xFF193149),
                foregroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  'أكاديمية منارة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              )
            : null,

        drawer: mobile
            ? Drawer(
                backgroundColor: const Color(0xFF193149),
                child: _Navigation(
                  navigationShell: navigationShell,
                  isTeacher: isTeacher,
                  compact: false,
                ),
              )
            : null,

        body: Row(
          children: [
            if (!mobile)
              SizedBox(
                width: compact ? 76 : 240,
                child: _Navigation(
                  navigationShell: navigationShell,
                  isTeacher: isTeacher,
                  compact: compact,
                ),
              ),

            Expanded(
              child: Column(
                children: [
                  if (!mobile) _TopBar(isTeacher: isTeacher),

                  // لا Animation
                  // لا KeyedSubtree
                  // لا Fade
                  // لا Slide
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation({
    required this.navigationShell,
    required this.isTeacher,
    required this.compact,
  });

  final StatefulNavigationShell navigationShell;
  final bool isTeacher;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF193149),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: 16,
          ),
          child: Column(
            children: [
              _Brand(compact: compact),

              const SizedBox(height: 28),

              if (!compact) ...[
                const _SectionTitle(title: 'مساحة العمل'),
                const SizedBox(height: 8),
              ],

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _NavItem(
                        title: 'لوحة التحكم',
                        branchIndex: isTeacher
                            ? AppShell.teacherDashboardBranch
                            : AppShell.adminDashboardBranch,
                        icon: Icons.grid_view_outlined,
                        compact: compact,
                        navigationShell: navigationShell,
                      ),

                      if (!isTeacher)
                        _NavItem(
                          title: 'الطلاب',
                          branchIndex: AppShell.adminStudentsBranch,
                          icon: Icons.people_outline,
                          compact: compact,
                          navigationShell: navigationShell,
                        ),

                      if (!isTeacher)
                        _NavItem(
                          title: 'المدرسون',
                          branchIndex: AppShell.adminTeachersBranch,
                          icon: Icons.person_outline,
                          compact: compact,
                          navigationShell: navigationShell,
                        ),

                      _NavItem(
                        title: 'المجموعات',
                        branchIndex: isTeacher
                            ? AppShell.teacherGroupsBranch
                            : AppShell.adminGroupsBranch,
                        icon: Icons.group_outlined,
                        compact: compact,
                        navigationShell: navigationShell,
                      ),

                      _NavItem(
                        title: 'الدروس',
                        branchIndex: isTeacher
                            ? AppShell.teacherLessonsBranch
                            : AppShell.adminLessonsBranch,
                        icon: Icons.menu_book_outlined,
                        compact: compact,
                        navigationShell: navigationShell,
                      ),

                      _NavItem(
                        title: 'الحضور',
                        branchIndex: isTeacher
                            ? AppShell.teacherAttendanceBranch
                            : AppShell.adminAttendanceBranch,
                        icon: Icons.fact_check_outlined,
                        compact: compact,
                        navigationShell: navigationShell,
                      ),

                      if (!isTeacher)
                        _NavItem(
                          title: 'المدفوعات',
                          branchIndex: AppShell.adminPaymentsBranch,
                          icon: Icons.payments_outlined,
                          compact: compact,
                          navigationShell: navigationShell,
                        ),

                      _NavItem(
                        title: 'التقارير',
                        branchIndex: isTeacher
                            ? AppShell.teacherReportsBranch
                            : AppShell.adminReportsBranch,
                        icon: Icons.bar_chart_outlined,
                        compact: compact,
                        navigationShell: navigationShell,
                      ),

                      if (!isTeacher) ...[
                        const SizedBox(height: 22),

                        if (!compact) ...[
                          const _SectionTitle(title: 'إدارة'),
                          const SizedBox(height: 8),
                        ],

                        _NavItem(
                          title: 'الإعدادات',
                          branchIndex: AppShell.adminSettingsBranch,
                          icon: Icons.settings_outlined,
                          compact: compact,
                          navigationShell: navigationShell,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              _NavItem(
                title: 'تسجيل الخروج',
                icon: Icons.logout,
                compact: compact,
                navigationShell: navigationShell,
                logout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.title,
    required this.icon,
    required this.compact,
    required this.navigationShell,
    this.branchIndex,
    this.logout = false,
  });

  final String title;
  final IconData icon;
  final bool compact;
  final StatefulNavigationShell navigationShell;
  final int? branchIndex;
  final bool logout;

  @override
  Widget build(BuildContext context) {
    final active = !logout && navigationShell.currentIndex == branchIndex;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: active ? const Color(0xFF2B4F6D) : Colors.transparent,

        borderRadius: BorderRadius.circular(9),

        child: InkWell(
          borderRadius: BorderRadius.circular(9),

          // إلغاء splash animation
          splashFactory: NoSplash.splashFactory,

          // إلغاء highlight
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,

          onTap: () {
            if (logout) {
              context.read<AuthCubit>().logout();
              context.go('/login');
              return;
            }

            if (branchIndex case final index?) {
              _goToBranch(navigationShell, index);
            }

            final scaffold = Scaffold.maybeOf(context);

            if (scaffold?.isDrawerOpen ?? false) {
              Navigator.of(context).pop();
            }
          },

          child: SizedBox(
            height: 42,
            child: Stack(
              children: [
                if (active)
                  Positioned(
                    right: 0,
                    top: 5,
                    bottom: 5,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2C15C),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 10),
                  child: Row(
                    mainAxisAlignment: compact
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        size: 19,
                        color: active ? Colors.white : const Color(0xFF9FB4C5),
                      ),

                      if (!compact) ...[
                        const SizedBox(width: 11),

                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: active
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: active
                                  ? Colors.white
                                  : const Color(0xFFD7E2EB),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _goToBranch(StatefulNavigationShell navigationShell, int index) {
  navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );
}

class _Brand extends StatelessWidget {
  const _Brand({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: compact
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 40,
          height: 40,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFF2C15C),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.school_outlined,
              size: 20,
              color: Color(0xFF193149),
            ),
          ),
        ),

        if (!compact) ...[
          const SizedBox(width: 11),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'منارة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'إدارة الأكاديمية',
                style: TextStyle(color: Color(0xFF778FA4), fontSize: 9),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6F899F),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isTeacher});

  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    final name = isTeacher ? 'أستاذ أحمد' : 'مسؤول العمل';

    final role = isTeacher ? 'مدرس' : 'مدير النظام';

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8ECF1))),
      ),
      child: Row(
        children: [
          const Text(
            'أكاديمية منارة',
            style: TextStyle(fontSize: 12, color: Color(0xFF8A97A4)),
          ),

          const SizedBox(width: 8),

          const Icon(Icons.chevron_left, size: 15, color: Color(0xFFBCC6D0)),

          const SizedBox(width: 8),

          const Text(
            'مساحة العمل',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),

          const Spacer(),

          IconButton(
            splashRadius: 18,
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              size: 21,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(width: 10),

          const SizedBox(
            height: 22,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: Color(0xFFE5E7EB),
            ),
          ),

          const SizedBox(width: 12),

          const CircleAvatar(
            radius: 17,
            backgroundColor: Color(0xFFF1F5F9),
            child: Text(
              'م',
              style: TextStyle(
                color: Color(0xFF193149),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),

              Text(
                role,
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
