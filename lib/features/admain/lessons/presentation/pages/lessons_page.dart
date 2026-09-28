import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/management_widgets.dart';
import '../cubit/lessons_cubit.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'الدروس',
    subtitle: 'متابعة الدروس القادمة وسجل الحصص',
    action: OutlinedButton.icon(
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يمكن إنشاء درس جديد من صفحة المجموعة')),
      ),
      icon: const Icon(Icons.add),
      label: const Text('درس جديد'),
    ),
    child: BlocBuilder<LessonsCubit, LessonsState>(
      builder: (context, state) => Card(
        child: state.loading
            ? const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('عنوان الدرس')),
                    DataColumn(label: Text('المجموعة')),
                    DataColumn(label: Text('المدرس')),
                    DataColumn(label: Text('التاريخ')),
                    DataColumn(label: Text('الوقت')),
                    DataColumn(label: Text('الحالة')),
                  ],
                  rows: state.items
                      .map(
                        (l) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                l.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(Text(l.group)),
                            DataCell(Text(l.teacher)),
                            DataCell(Text(l.date)),
                            DataCell(Text(l.time)),
                            DataCell(StatusChip(l.status)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
      ),
    ),
  );
}
