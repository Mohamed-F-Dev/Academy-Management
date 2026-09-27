import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/entities.dart';
import '../../../../shared/widgets/management_dialogs.dart';
import '../../../../shared/widgets/management_widgets.dart';
import '../cubit/teachers_cubit.dart';

class TeachersPage extends StatelessWidget {
  const TeachersPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'المدرسون',
    subtitle: 'إدارة فريق التدريس والتخصصات',
    action: FilledButton.icon(
      onPressed: () => showTeacherDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('إضافة مدرس'),
    ),
    child: BlocBuilder<TeachersCubit, TeachersState>(
      builder: (context, state) {
        final cubit = context.read<TeachersCubit>();
        return Column(
          children: [
            SearchFilterBar(
              onChanged: cubit.search,
              hint: 'ابحث عن مدرس أو تخصص...',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, c) => c.maxWidth < 680
                  ? _Cards(items: cubit.visible)
                  : _TeacherGrid(items: cubit.visible),
            ),
          ],
        );
      },
    ),
  );
}

class _Table extends StatelessWidget {
  const _Table({required this.items});
  final List<Teacher> items;
  @override
  Widget build(BuildContext context) => Card(
    child: items.isEmpty
        ? const EmptyState(message: 'لا توجد نتائج')
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('المدرس')),
                DataColumn(label: Text('التخصص')),
                DataColumn(label: Text('البريد')),
                DataColumn(label: Text('المجموعات')),
                DataColumn(label: Text('الحالة')),
                DataColumn(label: Text('إجراء')),
              ],
              rows: items
                  .map(
                    (t) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            t.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(Text(t.specialty)),
                        DataCell(Text(t.email)),
                        DataCell(Text('${t.groups} مجموعات')),
                        DataCell(StatusChip(t.status)),
                        DataCell(
                          IconButton(
                            onPressed: () =>
                                showTeacherDialog(context, item: t),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
  );
}

class _Cards extends StatelessWidget {
  const _Cards({required this.items});
  final List<Teacher> items;
  @override
  Widget build(BuildContext context) => Column(
    children: items
        .map(
          (t) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(child: Text(t.name.substring(0, 1))),
              title: Text(t.name),
              subtitle: Text('${t.specialty} • ${t.groups} مجموعات'),
              trailing: IconButton(
                onPressed: () => showTeacherDialog(context, item: t),
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
          ),
        )
        .toList(),
  );
}

class _TeacherGrid extends StatelessWidget {
  const _TeacherGrid({required this.items});
  final List<Teacher> items;
  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 285,
      mainAxisExtent: 154,
      crossAxisSpacing: 13,
      mainAxisSpacing: 13,
    ),
    itemBuilder: (context, index) {
      final teacher = items[index];
      final colors = [
        const Color(0xFFDDEFEA),
        const Color(0xFFF7DDD3),
        const Color(0xFFE6E0F1),
      ];
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colors[index % colors.length],
                    child: Text(
                      teacher.name.substring(0, 1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 18,
                      color: AppTheme.muted,
                    ),
                    onSelected: (_) =>
                        showTeacherDialog(context, item: teacher),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('تعديل')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                teacher.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                teacher.specialty,
                style: const TextStyle(color: AppTheme.muted, fontSize: 10),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.groups_outlined,
                    size: 13,
                    color: AppTheme.muted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${teacher.groups} مجموعات',
                    style: const TextStyle(fontSize: 9, color: AppTheme.muted),
                  ),
                  const Spacer(),
                  const StatusChip(RecordStatus.active),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
