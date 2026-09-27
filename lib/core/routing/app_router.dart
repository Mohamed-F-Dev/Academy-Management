import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/attendance/presentation/pages/attendance_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/groups/presentation/pages/groups_page.dart';
import '../../features/lessons/presentation/pages/lessons_page.dart';
import '../../features/payments/presentation/pages/payments_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/students/presentation/pages/student_details_page.dart';
import '../../features/students/presentation/pages/students_page.dart';
import '../../features/teachers/presentation/pages/teachers_page.dart';
import '../widgets/app_shell.dart';
import 'router_refresh.dart';

GoRouter createRouter(AuthCubit auth) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(auth.stream),
    redirect: (context, state) {
      final loggedIn = auth.state.status == AuthStatus.authenticated;
      final isLogin = state.matchedLocation == '/login';
      if (!loggedIn && !isLogin) return '/login';
      if (loggedIn && isLogin) {
        return auth.state.role == UserRole.admin ? '/admin/dashboard' : '/teacher/dashboard';
      }
      if (loggedIn && auth.state.role == UserRole.teacher &&
          state.matchedLocation.startsWith('/admin')) {
        return '/teacher/dashboard';
      }
      return null;
    },
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/admin/dashboard', builder: (_, __) => const DashboardPage()),
          GoRoute(path: '/admin/students', builder: (_, __) => const StudentsPage()),
          GoRoute(path: '/admin/students/:id', builder: (_, state) {
            return StudentDetailsPage(studentId: state.pathParameters['id']!);
          }),
          GoRoute(path: '/admin/teachers', builder: (_, __) => const TeachersPage()),
          GoRoute(path: '/admin/groups', builder: (_, __) => const GroupsPage()),
          GoRoute(path: '/admin/lessons', builder: (_, __) => const LessonsPage()),
          GoRoute(path: '/admin/attendance', builder: (_, __) => const AttendancePage()),
          GoRoute(path: '/admin/payments', builder: (_, __) => const PaymentsPage()),
          GoRoute(path: '/admin/reports', builder: (_, __) => const ReportsPage()),
          GoRoute(path: '/admin/settings', builder: (_, __) => const SettingsPage()),
          GoRoute(path: '/teacher/dashboard', builder: (_, __) => const DashboardPage()),
          GoRoute(path: '/teacher/groups', builder: (_, __) => const GroupsPage()),
          GoRoute(path: '/teacher/lessons', builder: (_, __) => const LessonsPage()),
          GoRoute(path: '/teacher/attendance', builder: (_, __) => const AttendancePage()),
          GoRoute(path: '/teacher/reports', builder: (_, __) => const ReportsPage()),
          GoRoute(path: '/teacher/profile', builder: (_, __) => const SettingsPage()),
        ],
      ),
    ],
  );
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () => context.go('/login'),
          child: const Text('العودة لتسجيل الدخول'),
        ),
      ),
    );
  }
}
