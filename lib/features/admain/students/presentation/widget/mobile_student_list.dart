import 'package:academy_management_system/features/admain/students/presentation/widget/students_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/models/entities.dart';
import '../../../../../shared/widgets/management_widgets.dart';

/// ===============================================================
/// MOBILE LIST
/// ===============================================================

class MobileStudentsList extends StatelessWidget {
  const MobileStudentsList({required this.items});

  final List<Student> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Card(
        child: Padding(padding: EdgeInsets.all(32), child: EmptyState()),
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
