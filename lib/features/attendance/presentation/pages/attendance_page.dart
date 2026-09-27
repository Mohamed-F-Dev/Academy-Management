import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/models/entities.dart';
import '../../../../shared/widgets/management_widgets.dart';
import '../cubit/attendance_cubit.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'الحضور والغياب',
    subtitle: 'تسجيل ومراجعة حضور الطلاب يومياً',
    action: OutlinedButton.icon(
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ سجل الحضور (تجريبي)')),
      ),
      icon: const Icon(Icons.save_outlined),
      label: const Text('حفظ السجل'),
    ),
    child: BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    title: const Text('تاريخ الحضور'),
                    subtitle: const Text('الأحد، 27 سبتمبر 2026'),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.groups, color: Colors.deepPurple),
                    title: const Text('المجموعة'),
                    subtitle: const Text('كل المجموعات'),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            child: state.loading
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('الطالب')),
                        DataColumn(label: Text('المجموعة')),
                        DataColumn(label: Text('التاريخ')),
                        DataColumn(label: Text('الحالة')),
                        DataColumn(label: Text('تغيير الحالة')),
                      ],
                      rows: state.items
                          .map(
                            (a) => DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    a.student,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(Text(a.group)),
                                DataCell(Text(a.date)),
                                DataCell(StatusChip(a.status)),
                                DataCell(
                                  IconButton(
                                    onPressed: () => context
                                        .read<AttendanceCubit>()
                                        .setStatus(
                                          a,
                                          a.status == RecordStatus.present
                                              ? RecordStatus.absent
                                              : RecordStatus.present,
                                        ),
                                    icon: Icon(
                                      a.status == RecordStatus.present
                                          ? Icons.person_off_outlined
                                          : Icons.check_circle_outline,
                                      color: a.status == RecordStatus.present
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}
