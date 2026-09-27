import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/cubit/teacher_cubit.dart';
import '../../../shared/widgets/management_widgets.dart';

class TeacherStudentsView extends StatelessWidget {
  const TeacherStudentsView({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<TeacherCubit, TeacherState>(
        builder: (context, state) {
          final students = context.read<TeacherCubit>().visibleStudents;
          return PageFrame(
            title: 'طلابي',
            subtitle: 'الطلاب الموجودون داخل مجموعاتك فقط',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchFilterBar(
                  onChanged: context.read<TeacherCubit>().search,
                  hint: 'ابحث بالاسم أو رقم الهاتف...',
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 650) {
                      return Column(
                        children: students
                            .map((student) => Card(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  child: ListTile(
                                    leading: CircleAvatar(child: Text(student.name.substring(0, 1))),
                                    title: Text(student.name),
                                    subtitle: Text('${student.group}\n${student.phone}'),
                                    isThreeLine: true,
                                    trailing: const Icon(Icons.chevron_left),
                                    onTap: () => context.push('/teacher/student/${student.id}'),
                                  ),
                                ))
                            .toList(),
                      );
                    }
                    return Card(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('الاسم')),
                            DataColumn(label: Text('المجموعة')),
                            DataColumn(label: Text('رقم الهاتف')),
                            DataColumn(label: Text('التفاصيل')),
                          ],
                          rows: students
                              .map((student) => DataRow(cells: [
                                    DataCell(Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(student.group)),
                                    DataCell(Text(student.phone)),
                                    DataCell(IconButton(
                                      icon: const Icon(Icons.chevron_left),
                                      onPressed: () => context.push('/teacher/student/${student.id}'),
                                    )),
                                  ]))
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
}