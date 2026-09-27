import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/management_widgets.dart';
import '../cubit/students_cubit.dart';

class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({required this.studentId, super.key});
  final String studentId;
  @override Widget build(BuildContext context) {
    final student = context.watch<StudentsCubit>().state.items.where((s) => s.id == studentId).firstOrNull;
    if (student == null) return const PageFrame(title: 'الطالب', subtitle: '', child: EmptyState(message: 'الطالب غير موجود'));
    return PageFrame(title: student.name, subtitle: 'ملف الطالب والتفاصيل المالية والتعليمية', action: OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_forward), label: const Text('رجوع')), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Card(child: Padding(padding: const EdgeInsets.all(22), child: Wrap(runSpacing: 20, spacing: 30, children: [
        _Info(label: 'رقم الهاتف', value: student.phone, icon: Icons.phone_outlined), _Info(label: 'ولي الأمر', value: '${student.guardian}\n${student.guardianPhone}', icon: Icons.family_restroom), _Info(label: 'تاريخ الميلاد', value: student.birthDate, icon: Icons.cake_outlined), _Info(label: 'المجموعة', value: student.group, icon: Icons.category_outlined),
      ]))),
      const SizedBox(height: 18),
      Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('ملخص الحضور', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 18), LinearProgressIndicator(value: .86, minHeight: 9, borderRadius: BorderRadius.circular(8)), const SizedBox(height: 10), const Text('86% نسبة الحضور خلال الشهر الحالي')]))),
    ]));
  }
}
class _Info extends StatelessWidget { const _Info({required this.label, required this.value, required this.icon}); final String label, value; final IconData icon; @override Widget build(BuildContext context) => SizedBox(width: 190, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: Colors.blue), const SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))])])); }
extension<T> on Iterable<T> { T? get firstOrNull => isEmpty ? null : first; }
