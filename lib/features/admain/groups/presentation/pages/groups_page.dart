import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/models/entities.dart';
import '../../../../../shared/widgets/management_dialogs.dart';
import '../../../../../shared/widgets/management_widgets.dart';
import '../cubit/groups_cubit.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'المجموعات',
    subtitle: 'تنظيم المجموعات والجداول الدراسية',
    action: FilledButton.icon(
      onPressed: () => showGroupDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('إضافة مجموعة'),
    ),
    child: BlocBuilder<GroupsCubit, GroupsState>(
      builder: (context, state) {
        final cubit = context.read<GroupsCubit>();
        return Column(
          children: [
            SearchFilterBar(
              onChanged: cubit.search,
              hint: 'ابحث عن مجموعة أو مادة...',
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, c) => c.maxWidth < 700
                  ? _Cards(items: cubit.visible)
                  : _Table(items: cubit.visible),
            ),
          ],
        );
      },
    ),
  );
}

class _Table extends StatelessWidget {
  const _Table({required this.items});
  final List<Group> items;
  @override
  Widget build(BuildContext context) => Card(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('المجموعة')),
          DataColumn(label: Text('المدرس')),
          DataColumn(label: Text('الجدول')),
          DataColumn(label: Text('الطلاب')),
          DataColumn(label: Text('الرسوم')),
          DataColumn(label: Text('إجراء')),
        ],
        rows: items
            .map(
              (g) => DataRow(
                cells: [
                  DataCell(
                    Text(
                      g.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(Text(g.teacher)),
                  DataCell(Text(g.schedule)),
                  DataCell(Text('${g.students}/${g.capacity}')),
                  DataCell(Text('${g.fee.toStringAsFixed(0)} ج.م')),
                  DataCell(
                    IconButton(
                      onPressed: () => showGroupDialog(context, item: g),
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
  final List<Group> items;
  @override
  Widget build(BuildContext context) => Column(
    children: items
        .map(
          (g) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(
                g.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${g.subject} • ${g.teacher}\n${g.schedule}'),
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () => showGroupDialog(context, item: g),
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
          ),
        )
        .toList(),
  );
}
