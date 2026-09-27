import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/models/entities.dart';
import '../../../../shared/widgets/management_widgets.dart';
import '../cubit/students_cubit.dart';
import '../../../../shared/widgets/management_dialogs.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});
  @override Widget build(BuildContext context) => PageFrame(
    title: 'الطلاب', subtitle: 'إدارة بيانات الطلاب والتسجيلات',
    action: FilledButton.icon(onPressed: () => showStudentDialog(context), icon: const Icon(Icons.add), label: const Text('إضافة طالب')),
    child: BlocBuilder<StudentsCubit, StudentsState>(builder: (context, state) {
      final cubit = context.read<StudentsCubit>();
      return Column(children: [
        SearchFilterBar(onChanged: cubit.search, onFilter: cubit.filter, filters: const ['الكل', 'نشط', 'غير نشط']),
        const SizedBox(height: 16), const ExportActions(), const SizedBox(height: 12),
        if (state.loading) const LinearProgressIndicator(),
        LayoutBuilder(builder: (context, c) => c.maxWidth < 680 ? _MobileList(items: cubit.visible) : _Table(items: cubit.visible)),
      ]);
    }),
  );
}
class _Table extends StatelessWidget {
  const _Table({required this.items}); final List<Student> items;
  @override Widget build(BuildContext context) => Card(child: items.isEmpty ? const EmptyState(message: 'لا توجد نتائج') : SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
    columns: const [DataColumn(label: Text('الطالب')), DataColumn(label: Text('المجموعة')), DataColumn(label: Text('الهاتف')), DataColumn(label: Text('الحالة')), DataColumn(label: Text('إجراء'))],
    rows: items.map((s) => DataRow(cells: [
      DataCell(Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)), onTap: () => context.go('/admin/students/${s.id}')),
      DataCell(Text(s.group)), DataCell(Text(s.phone)), DataCell(StatusChip(s.status)),
      DataCell(Row(children: [IconButton(onPressed: () => showStudentDialog(context, item: s), icon: const Icon(Icons.edit_outlined, size: 19)), IconButton(onPressed: () => _delete(context, s), icon: const Icon(Icons.delete_outline, size: 19, color: Colors.red))])),
    ])).toList(),
  )));
  void _delete(BuildContext context, Student s) async { final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('حذف الطالب'), content: Text('هل تريد حذف ${s.name}؟'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف'))])); if (ok == true && context.mounted) { await context.read<StudentsCubit>().delete(s.id); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الطالب'))); } }
}
class _MobileList extends StatelessWidget {
  const _MobileList({required this.items}); final List<Student> items;
  @override Widget build(BuildContext context) => items.isEmpty ? const Card(child: EmptyState(message: 'لا توجد نتائج')) : Column(children: items.map((s) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
    onTap: () => context.go('/admin/students/${s.id}'), leading: CircleAvatar(child: Text(s.name.substring(0, 1))), title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${s.group}\n${s.phone}'), isThreeLine: true, trailing: PopupMenuButton<String>(onSelected: (v) { if (v == 'edit') showStudentDialog(context, item: s); }, itemBuilder: (_) => const [PopupMenuItem(value: 'edit', child: Text('تعديل'))]),
  ))).toList());
}
