import 'package:academy_management_system/features/teacher/navigation/cubit/teacher_navigation_cubit.dart';
import 'package:academy_management_system/features/teacher/presentation/cubit/teacher_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'features/admain/academy/presentation/cubit/academy_cubit.dart';
import 'features/admain/attendance/presentation/cubit/attendance_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/admain/groups/presentation/cubit/groups_cubit.dart';
import 'features/admain/lessons/presentation/cubit/lessons_cubit.dart';
import 'features/admain/payments/presentation/cubit/payments_cubit.dart';
import 'features/admain/reports/presentation/cubit/reports_cubit.dart';
import 'features/admain/settings/presentation/cubit/settings_cubit.dart';
import 'features/admain/students/presentation/cubit/students_cubit.dart';
import 'features/admain/teachers/presentation/cubit/teachers_cubit.dart';
import 'shared/data/mock_store.dart';
import 'shared/data/repositories.dart';

void main() {
  final store = MockStore();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => AcademyCubit(MockAcademyRepository(store))),
        BlocProvider(
          create: (_) => StudentsCubit(MockStudentRepository(store)),
        ),
        BlocProvider(
          create: (_) => TeachersCubit(MockTeacherRepository(store)),
        ),
        BlocProvider(create: (_) => GroupsCubit(MockGroupRepository(store))),
        BlocProvider(create: (_) => LessonsCubit(MockLessonRepository(store))),
        BlocProvider(
          create: (_) => AttendanceCubit(MockAttendanceRepository(store)),
        ),
        BlocProvider(
          create: (_) => PaymentsCubit(MockPaymentRepository(store)),
        ),
        BlocProvider(create: (_) => ReportsCubit(MockReportRepository(store))),
        BlocProvider(
          create: (_) => SettingsCubit(MockSettingsRepository(store)),
        ),
        BlocProvider(create: (_) => TeacherNavigationCubit()),
        BlocProvider(create: (_) => TeacherCubit(store)),
      ],
      child: const AcademyApp(),
    ),
  );
}
