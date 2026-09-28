import 'package:academy_management_system/features/admain/students/presentation/cubit/students_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/layout/app_responsive.dart';
import '../../../../../shared/models/entities.dart';
import '../../../../../shared/widgets/management_widgets.dart';

/// ===============================================================
/// DESKTOP TABLE
/// ===============================================================
class StudentsTabl extends StatefulWidget {
  const StudentsTabl({super.key, required this.items});

  final List<Student> items;

  @override
  State<StudentsTabl> createState() => StudentsTablState();
}

class StudentsTablState extends State<StudentsTabl> {
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: EmptyState(message: 'لا توجد نتائج'),
        ),
      );
    }

    final source = _StudentsDataSource(context: context, items: widget.items);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE9E5DD)),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: context.screenSize.width - 300,
          child: PaginatedDataTable(
            showCheckboxColumn: false,
            showFirstLastButtons: true,

            headingRowHeight: 48,
            dataRowMinHeight: 68,
            dataRowMaxHeight: 72,

            horizontalMargin: 18,
            columnSpacing: 28,

            rowsPerPage: _rowsPerPage,

            availableRowsPerPage: const [5, 10, 20, 50],

            onRowsPerPageChanged: (value) {
              if (value == null) return;

              setState(() {
                _rowsPerPage = value;
              });
            },

            headingRowColor: WidgetStateProperty.all(const Color(0xFFFDFCFA)),

            columns: const [
              DataColumn(label: SizedBox(width: 210, child: Text('الطالب'))),
              DataColumn(label: SizedBox(width: 110, child: Text('كودالطالب'))),
              DataColumn(label: SizedBox(width: 180, child: Text('المجموعات'))),
              DataColumn(label: SizedBox(width: 140, child: Text('ولي الأمر'))),
              DataColumn(label: SizedBox(width: 80, child: Text('الحالة'))),
              DataColumn(
                label: SizedBox(width: 100, child: Text('تاريخ التسجيل')),
              ),
              DataColumn(label: SizedBox(width: 110)),
            ],

            source: source,
          ),
        ),
      ),
    );
  }
}

class _StudentsDataSource extends DataTableSource {
  _StudentsDataSource({required this.context, required this.items});

  final BuildContext context;
  final List<Student> items;

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) {
      return null;
    }

    final student = items[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          _StudentCell(student: student),
          onTap: () {
            context.go('/admin/students/${student.id}');
          },
        ),

        DataCell(_FileNumber(value: _fileNumber(student))),

        DataCell(_GroupsCell(groups: _groups(student))),

        DataCell(
          _GuardianCell(
            name: _guardianName(student),
            phone: _guardianPhone(student),
          ),
        ),

        DataCell(StudentStatusChip(status: student.status.name)),

        DataCell(
          Text(
            _registrationDate(student),
            style: const TextStyle(color: Color(0xFF64717A), fontSize: 11),
          ),
        ),

        DataCell(_RowActions(student: student)),
      ],
    );
  }

  String _fileNumber(Student student) {
    return 'ST-${student.id.toString().padLeft(6, '0')}';
  }

  List<String> _groups(Student student) {
    return student.group
        .split(',')
        .where((element) => element.trim().isNotEmpty)
        .map((element) => element.trim())
        .toList();
  }

  String _guardianName(Student student) {
    // Replace with:
    return student.guardian;

    // return '-';
  }

  String _guardianPhone(Student student) {
    // Replace with:
    return student.guardianPhone;

    // return '';
  }

  String _registrationDate(Student student) {
    // Replace with your real createdAt value.

    // Example:
    //
    return DateFormat('yyyy/M/d').format(student.createdAt);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}

/// ===============================================================
/// STUDENT CELL
/// ===============================================================

class _StudentCell extends StatelessWidget {
  const _StudentCell({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final name = student.name.trim();

    final firstLetter = name.isEmpty ? 'ط' : name.substring(0, 1);

    return SizedBox(
      width: 210,
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: const Color(0xFFD9F0ED),
            child: Text(
              firstLetter,
              style: const TextStyle(
                color: Color(0xFF28796F),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF24323B),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Directionality(
                  textDirection: .ltr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      student.phone,
                      style: const TextStyle(
                        color: Color(0xFF8C969D),
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// FILE NUMBER
/// ===============================================================

class _FileNumber extends StatelessWidget {
  const _FileNumber({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Directionality(
        textDirection: .ltr,
        child: Text(
          value,
          textAlign: .end,
          style: const TextStyle(fontSize: 10, color: Color(0xFF53616B)),
        ),
      ),
    );
  }
}

/// ===============================================================
/// GROUPS
/// ===============================================================

class _GroupsCell extends StatelessWidget {
  const _GroupsCell({required this.groups});

  final List<String> groups;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const Text('-');
    }

    return SizedBox(
      width: 180,
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: [
          ...groups
              .take(2)
              .map(
                (group) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EFEB),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    group,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF667078),
                    ),
                  ),
                ),
              ),
          if (groups.length > 2)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F2F0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '+${groups.length - 2}',
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF247C72),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// GUARDIAN
/// ===============================================================

class _GuardianCell extends StatelessWidget {
  const _GuardianCell({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF35434C),
            ),
          ),
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 3),
            Directionality(
              textDirection: .ltr,
              child: Text(
                phone,
                style: const TextStyle(fontSize: 9, color: Color(0xFF8B969E)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ===============================================================
/// STATUS
/// ===============================================================

class StudentStatusChip extends StatelessWidget {
  const StudentStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final active = status == 'نشط';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE2F4E9) : const Color(0xFFF3EEE3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: active ? const Color(0xFF428761) : const Color(0xFF8C7650),
        ),
      ),
    );
  }
}

/// ===============================================================
/// ROW ACTIONS
/// ===============================================================

class _RowActions extends StatelessWidget {
  const _RowActions({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ActionIcon(
            icon: Icons.chevron_left,
            tooltip: 'التفاصيل',
            onPressed: () {
              context.go('/admin/students/${student.id}');
            },
          ),
          _ActionIcon(
            icon: Icons.edit_outlined,
            tooltip: 'تعديل',
            onPressed: () {
              // showStudentDialog(
              //   context,
              //   item: student,
              // );
            },
          ),
          _ActionIcon(
            icon: Icons.delete_outline,
            tooltip: 'حذف',
            onPressed: () {
              _deleteStudent(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteStudent(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: .rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: const Text('حذف الطالب'),
            content: Text('هل تريد حذف ${student.name}؟'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('إلغاء'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: const Text('حذف'),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await context.read<StudentsCubit>().delete(student.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم حذف الطالب')));
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      splashRadius: 17,
      constraints: const BoxConstraints(minWidth: 31, minHeight: 31),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: const Color(0xFF718895)),
    );
  }
}
