import 'package:academy_management_system/core/layout/app_responsive.dart';
import 'package:academy_management_system/core/theme/app_colors.dart';
import 'package:academy_management_system/features/admain/students/presentation/cubit/students_cubit.dart';
import 'package:academy_management_system/features/admain/students/presentation/widget/mobile_student_list.dart';
import 'package:academy_management_system/features/admain/students/presentation/widget/students_table.dart';
import 'package:academy_management_system/features/admain/students/presentation/widget/toolbar_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                      return MobileStudentsList(items: items);
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
