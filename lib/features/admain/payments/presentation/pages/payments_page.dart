import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/models/entities.dart';
import '../../../../../shared/widgets/management_dialogs.dart';
import '../../../../../shared/widgets/management_widgets.dart';
import '../cubit/payments_cubit.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'المدفوعات',
    subtitle: 'تسجيل ومتابعة الرسوم الشهرية',
    action: FilledButton.icon(
      onPressed: () => showPaymentDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('تسجيل دفعة'),
    ),
    child: BlocBuilder<PaymentsCubit, PaymentsState>(
      builder: (context, state) {
        final cubit = context.read<PaymentsCubit>();
        return Column(
          children: [
            SearchFilterBar(
              onChanged: cubit.search,
              hint: 'ابحث باسم الطالب أو الشهر...',
            ),
            const SizedBox(height: 14),
            ExportActions(),
            const SizedBox(height: 12),
            Card(
              child: state.loading
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    )
                  : LayoutBuilder(
                      builder: (context, c) => c.maxWidth < 680
                          ? _Cards(items: cubit.visible)
                          : _Table(items: cubit.visible),
                    ),
            ),
          ],
        );
      },
    ),
  );
}

String _paymentStatus(Payment p) => p.paidAmount >= p.requiredAmount
    ? 'مدفوع'
    : p.paidAmount > 0
    ? 'جزئي'
    : 'متأخر';

class _Table extends StatelessWidget {
  const _Table({required this.items});
  final List<Payment> items;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columns: const [
        DataColumn(label: Text('الطالب')),
        DataColumn(label: Text('الشهر')),
        DataColumn(label: Text('المطلوب')),
        DataColumn(label: Text('المدفوع')),
        DataColumn(label: Text('الطريقة')),
        DataColumn(label: Text('الحالة')),
        DataColumn(label: Text('إجراء')),
      ],
      rows: items
          .map(
            (p) => DataRow(
              cells: [
                DataCell(
                  Text(
                    p.student,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataCell(Text(p.month)),
                DataCell(Text('${p.requiredAmount.toStringAsFixed(0)} ج.م')),
                DataCell(Text('${p.paidAmount.toStringAsFixed(0)} ج.م')),
                DataCell(Text(p.method)),
                DataCell(
                  StatusChip(
                    _paymentStatus(p) == 'مدفوع'
                        ? RecordStatus.paid
                        : RecordStatus.partial,
                  ),
                ),
                DataCell(
                  IconButton(
                    onPressed: () => showPaymentDialog(context, item: p),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    ),
  );
}

class _Cards extends StatelessWidget {
  const _Cards({required this.items});
  final List<Payment> items;
  @override
  Widget build(BuildContext context) => Column(
    children: items
        .map(
          (p) => ListTile(
            title: Text(p.student),
            subtitle: Text(
              '${p.month} • ${p.paidAmount.toStringAsFixed(0)} من ${p.requiredAmount.toStringAsFixed(0)} ج.م',
            ),
            trailing: IconButton(
              onPressed: () => showPaymentDialog(context, item: p),
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
        )
        .toList(),
  );
}
