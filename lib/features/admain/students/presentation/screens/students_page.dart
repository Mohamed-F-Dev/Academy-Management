import 'package:academy_management_system/core/layout/app_responsive.dart';
import 'package:academy_management_system/core/theme/app_colors.dart';
import 'package:academy_management_system/features/admain/students/presentation/cubit/students_cubit.dart';
import 'package:academy_management_system/features/admain/students/presentation/widget/students_table.dart';
import 'package:academy_management_system/features/admain/students/presentation/widget/toolbar_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/models/entities.dart';
import '../../../../../shared/widgets/management_widgets.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: .rtl,
      child: BlocBuilder<StudentsCubit, StudentsState>(
        builder: (context, state) {
          final cubit = context.read<StudentsCubit>();
          final items = cubit.visible;

          return PageFrame(
            title: 'الطلاب',
            subtitle: 'متابعة الطلاب وإدارة بياناتهم',
            action: FilledButton.icon(
              // onPressed: () => showStudentDialog(context),
              onPressed: () {
                //!add Student
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('إضافة طالب'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StudentsToolbar(onSearch: cubit.search, onFilter: cubit.filter),

                const SizedBox(height: 16),

                if (state.loading) ...[
                  const LinearProgressIndicator(
                    minHeight: 2,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                ],

                Responsive(
                  builder: (context, type, constraints) {
                    if (constraints.maxWidth < 800) {
                      return _MobileStudentsList(items: items);
                    }

                    return StudentsTabl(items: items);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ===============================================================
/// MOBILE LIST
/// ===============================================================

class _MobileStudentsList extends StatelessWidget {
  const _MobileStudentsList({required this.items});

  final List<Student> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: EmptyState(message: 'لا توجد نتائج'),
        ),
      );
    }

    return Column(
      children: items.map((student) {
        final name = student.name.trim();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE8E4DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            onTap: () {
              context.go('/admin/students/${student.id}');
            },
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFD9F0ED),
              child: Text(
                name.isEmpty ? 'ط' : name.substring(0, 1),
                style: const TextStyle(
                  color: Color(0xFF28796F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                StudentStatusChip(status: student.status.name),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${student.group}\n${student.phone}',
                style: const TextStyle(
                  height: 1.6,
                  fontSize: 10,
                  color: Color(0xFF7D8991),
                ),
              ),
            ),
            isThreeLine: true,
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 19),
              onSelected: (value) {
                if (value == 'view') {
                  context.go('/admin/students/${student.id}');
                }

                if (value == 'edit') {
                  // showStudentDialog(
                  //   context,
                  //   item: student,
                  // );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'view', child: Text('عرض التفاصيل')),
                PopupMenuItem(value: 'edit', child: Text('تعديل')),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
