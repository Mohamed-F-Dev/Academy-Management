import 'package:academy_management_system/features/teacher/navigation/teacher_shell.dart';
import 'package:academy_management_system/features/teacher/presentation/pages/teacher_workflow_pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screen/login_page.dart';
import '../../features/admain/attendance/presentation/pages/attendance_page.dart';
import '../../features/admain/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/admain/groups/presentation/pages/groups_page.dart';
import '../../features/admain/lessons/presentation/pages/lessons_page.dart';
import '../../features/admain/payments/presentation/pages/payments_page.dart';
import '../../features/admain/reports/presentation/pages/reports_page.dart';
import '../../features/admain/settings/presentation/pages/settings_page.dart';
import '../../features/admain/students/presentation/screens/student_details_page.dart';
import '../../features/admain/students/presentation/screens/students_page.dart';
import '../../features/admain/teachers/presentation/pages/teachers_page.dart';
import '../widgets/app_shell.dart';
import 'router_refresh.dart';

final _adminDashboardNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-dashboard',
);
final _adminStudentsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-students',
);
final _adminTeachersNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-teachers',
);
final _adminGroupsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-groups',
);
final _adminLessonsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-lessons',
);
final _adminAttendanceNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-attendance',
);
final _adminPaymentsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-payments',
);
final _adminReportsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-reports',
);
final _adminSettingsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'admin-settings',
);
final _teacherDashboardNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'teacher-dashboard',
);
final _teacherGroupsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'teacher-groups',
);
final _teacherLessonsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'teacher-lessons',
);
final _teacherAttendanceNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'teacher-attendance',
);
final _teacherReportsNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'teacher-reports',
);

GoRouter createRouter(AuthCubit auth) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(auth.stream),
    redirect: (context, state) {
      final loggedIn = auth.state.status == AuthStatus.authenticated;
      final isLogin = state.matchedLocation == '/login';
      if (!loggedIn && !isLogin) return '/login';
      if (loggedIn && isLogin) {
        return auth.state.role == UserRole.admin
            ? '/admin/dashboard'
            : '/teacher';
      }
      if (loggedIn &&
          auth.state.role == UserRole.teacher &&
          state.matchedLocation.startsWith('/admin')) {
        return '/teacher/dashboard';
      }
      return null;
    },
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _adminDashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/dashboard',
                builder: (_, _) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminStudentsNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/students',
                builder: (_, _) => const StudentsPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => StudentDetailsPage(
                      studentId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminTeachersNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/teachers',
                builder: (_, _) => const TeachersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminGroupsNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/groups',
                builder: (_, _) => const GroupsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminLessonsNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/lessons',
                builder: (_, _) => const LessonsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminAttendanceNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/attendance',
                builder: (_, _) => const AttendancePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminPaymentsNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/payments',
                builder: (_, _) => const PaymentsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminReportsNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/reports',
                builder: (_, _) => const ReportsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _adminSettingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/admin/settings',
                builder: (_, _) => const SettingsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _teacherDashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/teacher/dashboard',
                builder: (_, _) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _teacherGroupsNavigatorKey,
            routes: [
              GoRoute(
                path: '/teacher/groups',
                builder: (_, _) => const GroupsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _teacherLessonsNavigatorKey,
            routes: [
              GoRoute(
                path: '/teacher/lessons',
                builder: (_, _) => const LessonsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _teacherAttendanceNavigatorKey,
            routes: [
              GoRoute(
                path: '/teacher/attendance',
                builder: (_, _) => const AttendancePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _teacherReportsNavigatorKey,
            routes: [
              GoRoute(
                path: '/teacher/reports',
                builder: (_, _) => const ReportsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/teacher', builder: (_, _) => const TeacherShell()),
      // Teacher workflow pages (pushed from TeacherShell views)
      GoRoute(
        path: '/teacher/lesson/create',
        builder: (_, _) => const TeacherCreateLessonPage(),
      ),
      GoRoute(
        path: '/teacher/profile/edit',
        builder: (_, _) => const TeacherProfileEditPage(),
      ),
      GoRoute(
        path: '/teacher/group/:id',
        builder: (_, state) =>
            TeacherGroupDetailsPage(groupId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teacher/student/:id',
        builder: (_, state) =>
            TeacherStudentDetailsPage(studentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teacher/lesson/:id',
        builder: (_, state) =>
            TeacherLessonDetailsPage(lessonId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teacher/attendance/:id',
        builder: (_, state) =>
            TeacherAttendancePage(lessonId: state.pathParameters['id']!),
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
