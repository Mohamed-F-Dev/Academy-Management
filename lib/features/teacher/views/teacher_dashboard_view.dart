import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../navigation/cubit/teacher_navigation_cubit.dart';
import '../navigation/teacher_navigation_item.dart';
import '../presentation/cubit/teacher_cubit.dart';
import '../../../shared/models/entities.dart';
import '../../../shared/widgets/management_widgets.dart';

class TeacherDashboardView extends StatelessWidget {
  const TeacherDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        final present = state.attendance
            .where((record) => record.status == RecordStatus.present)
            .length;
        final attendanceRate = state.attendance.isEmpty
            ? 0
            : (present * 100 ~/ state.attendance.length);
        final upcoming =
            state.lessons.where((lesson) => lesson.status == RecordStatus.pending).take(3);
        return PageFrame(
          title: 'مرحباً، ${state.name} 👋',
          subtitle: 'إليك ملخص يومك في الأكاديمية',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 620 ? 2 : 4;
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: constraints.maxWidth < 620 ? 1.7 : 1.35,
                    children: [
                      MetricCard(title: 'حصص اليوم', value: '${state.lessons.length}', icon: Icons.menu_book_outlined, color: Colors.blue),
                      MetricCard(title: 'مجموعاتي', value: '${state.groups.length}', icon: Icons.category_outlined, color: Colors.deepPurple),
                      MetricCard(title: 'عدد الطلاب', value: '${state.students.length}', icon: Icons.groups_outlined, color: Colors.teal),
                      MetricCard(title: 'حضور اليوم', value: '$attendanceRate%', icon: Icons.fact_check_outlined, color: Colors.orange),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _QuickAction(
                    label: 'إنشاء حصة',
                    icon: Icons.add_circle_outline,
                    onTap: () => context.push('/teacher/lesson/create'),
                  ),
                  const SizedBox(width: 8),
                  _QuickAction(
                    label: 'مجموعاتي',
                    icon: Icons.category_outlined,
                    onTap: () => context.read<TeacherNavigationCubit>().select(TeacherSection.groups),
                  ),
                  const SizedBox(width: 8),
                  _QuickAction(
                    label: 'الجدول',
                    icon: Icons.calendar_month_outlined,
                    onTap: () => context.read<TeacherNavigationCubit>().select(TeacherSection.schedule),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('حصصك القادمة',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(height: 24),
                      ...upcoming.map((lesson) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE3F0EC),
                              child: Icon(Icons.menu_book_outlined, color: Color(0xFF287A78)),
                            ),
                            title: Text(lesson.title),
                            subtitle: Text('${lesson.group} • ${lesson.date} • ${lesson.time}'),
                            trailing: TextButton(
                              onPressed: () => context.push('/teacher/lesson/${lesson.id}'),
                              child: const Text('التفاصيل'),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Expanded(
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 17),
          label: Text(label),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
        ),
      );
}