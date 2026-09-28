import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final isTeacher = context.read<AuthCubit>().state.role == UserRole.teacher;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 720;
          return Scaffold(
            appBar: mobile
                ? AppBar(
                    title: const Text('أكاديمية منارة'),
                    actions: const [_ProfileMenu()],
                  )
                : null,
            drawer: mobile
                ? Drawer(
                    child: _Navigation(isTeacher: isTeacher, compact: false),
                  )
                : null,
            body: Row(
              children: [
                if (!mobile)
                  SizedBox(
                    width: constraints.maxWidth < 850 ? 76 : 252,
                    child: _Navigation(
                      isTeacher: isTeacher,
                      compact: constraints.maxWidth < 850,
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      if (!mobile) const _TopBar(),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          reverseDuration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (page, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.02, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: page,
                                ),
                              ),
                          child: KeyedSubtree(
                            key: ValueKey(
                              GoRouterState.of(context).matchedLocation,
                            ),
                            child: child,
                          ),
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
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation({required this.isTeacher, required this.compact});
  final bool isTeacher, compact;
  @override
  Widget build(BuildContext context) {
    final base = isTeacher ? '/teacher' : '/admin';
    final items = [
      ('لوحة التحكم', '$base/dashboard', Icons.dashboard_rounded),
      if (!isTeacher) ('الطلاب', '/admin/students', Icons.groups_rounded),
      if (!isTeacher) ('المدرسون', '/admin/teachers', Icons.co_present_rounded),
      ('المجموعات', '$base/groups', Icons.category_rounded),
      ('الدروس', '$base/lessons', Icons.menu_book_rounded),
      ('الحضور', '$base/attendance', Icons.fact_check_rounded),
      ('المدفوعات', '/admin/payments', Icons.payments_rounded),
      ('التقارير', '$base/reports', Icons.analytics_rounded),
      if (!isTeacher) ('الإعدادات', '/admin/settings', Icons.settings_rounded),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.sidebarSurface,
        border: Border(left: BorderSide(color: Color(0xFFE4E7EC), width: 1)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 16,
        vertical: 18,
      ),
      child: Column(
        children: [
          _Brand(compact: compact),
          const SizedBox(height: 20),
          if (!compact) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'القائمة',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.subtle,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: ListView(
              children: items
                  .map(
                    (item) => _NavItem(
                      title: item.$1,
                      path: item.$2,
                      icon: item.$3,
                      compact: compact,
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(color: Color(0xFFE4E7EC)),
          const SizedBox(height: 8),
          _NavItem(
            title: 'تسجيل الخروج',
            path: '/login',
            icon: Icons.logout_rounded,
            compact: compact,
            logout: true,
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.compact});
  final bool compact;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: compact ? 34 : 38,
        height: compact ? 34 : 38,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const Center(
          child: Icon(Icons.school_rounded, color: Colors.white, size: 20),
        ),
      ),
      if (!compact) ...[
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أكاديمية منارة',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 1),
            const Text(
              'نظام إدارة الأكاديمية',
              style: TextStyle(fontSize: 11, color: AppTheme.muted),
            ),
          ],
        ),
      ],
    ],
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.title,
    required this.path,
    required this.icon,
    required this.compact,
    this.logout = false,
  });
  final String title, path;
  final IconData icon;
  final bool compact, logout;
  @override
  Widget build(BuildContext context) {
    final active = GoRouterState.of(context).matchedLocation == path;
    final Color iconColor = logout
        ? AppTheme.danger
        : active
        ? AppTheme.primary
        : AppTheme.muted;
    final Color textColor = logout
        ? AppTheme.danger
        : active
        ? AppTheme.primaryStrong
        : AppTheme.body;
    return Padding(
      padding: EdgeInsets.only(bottom: logout ? 0 : 5),
      child: Tooltip(
        message: title,
        child: ListTile(
          selected: active,
          hoverColor: AppTheme.hover,
          selectedTileColor: AppTheme.primarySoft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: compact ? 9 : 12,
            vertical: 11,
          ),
          leading: Icon(icon, size: 18, color: iconColor),
          title: compact
              ? null
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: textColor,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
          onTap: () {
            if (logout) context.read<AuthCubit>().logout();
            context.go(path);
            if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 12),
    child: CircleAvatar(
      backgroundColor: AppTheme.primarySoft,
      child: const Icon(Icons.person, color: AppTheme.primaryStrong),
    ),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar();
  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state.role;
    final name = role == UserRole.teacher ? 'أستاذ أحمد' : 'مسؤول العمل';
    final roleLabel = role == UserRole.teacher ? 'مدرس' : 'مدير النظام';
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE4E7EC), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'أكاديمية منارة',
                style: TextStyle(fontSize: 12, color: AppTheme.subtle),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 11,
                color: Color(0xFFC9CFDA),
              ),
              const SizedBox(width: 8),
              const Text(
                'مساحة العمل',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.body,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لا توجد إشعارات جديدة')),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'الإشعارات',
          ),
          const SizedBox(width: 10),
          Container(
            width: 1,
            height: 20,
            decoration: BoxDecoration(
              color: Color(0xFFE4E7EC),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 17,
            backgroundColor: AppTheme.primarySoft,
            child: const Text(
              'م',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryStrong,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                roleLabel,
                style: const TextStyle(fontSize: 11, color: AppTheme.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
