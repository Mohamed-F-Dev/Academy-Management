import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/cubit/teacher_cubit.dart';
import '../../../shared/widgets/management_widgets.dart';

class TeacherGroupsView extends StatelessWidget {
  const TeacherGroupsView({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<TeacherCubit, TeacherState>(
        builder: (context, state) => PageFrame(
          title: 'مجموعاتي',
          subtitle: 'المجموعات المسندة إليك فقط',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchFilterBar(
                onChanged: context.read<TeacherCubit>().search,
                hint: 'ابحث عن مجموعة أو مادة...',
              ),
              const SizedBox(height: 16),
              ...context.read<TeacherCubit>().visibleGroups.map(
                    (group) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFDDEFEA),
                          child: Icon(Icons.category_outlined, color: Color(0xFF287A78)),
                        ),
                        title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${group.subject} • ${group.students} طالب • ${group.schedule}'),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () => context.push('/teacher/group/${group.id}'),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      );
}