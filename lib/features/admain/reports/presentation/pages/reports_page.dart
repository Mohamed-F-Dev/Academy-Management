import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/models/entities.dart';
import '../../../../../shared/widgets/management_widgets.dart';
import '../cubit/reports_cubit.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'التقارير',
    subtitle: 'تقارير الأداء والحضور والإيرادات',
    action: const ExportActions(),
    child: BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, c) => GridView.count(
              crossAxisCount: c.maxWidth < 600 ? 2 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.65,
              children: [
                MetricCard(
                  title: 'حضور اليوم',
                  value: '88%',
                  icon: Icons.fact_check,
                  color: Colors.green,
                ),
                MetricCard(
                  title: 'متوسط الحضور',
                  value: '91%',
                  icon: Icons.trending_up,
                  color: Colors.blue,
                ),
                MetricCard(
                  title: 'المبالغ المحصلة',
                  value: '${state.summary['revenue'] ?? 0} ج.م',
                  icon: Icons.payments,
                  color: Colors.orange,
                ),
                MetricCard(
                  title: 'طلاب متأخرون',
                  value: '6',
                  icon: Icons.warning_amber,
                  color: Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التقرير اليومي',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('المؤشر')),
                        DataColumn(label: Text('القيمة')),
                        DataColumn(label: Text('مقارنة بالأمس')),
                        DataColumn(label: Text('الحالة')),
                      ],
                      rows: const [
                        DataRow(
                          cells: [
                            DataCell(Text('إجمالي الحصص')),
                            DataCell(Text('12')),
                            DataCell(Text('+2')),
                            DataCell(StatusChip(RecordStatus.present)),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('حضور الطلاب')),
                            DataCell(Text('42')),
                            DataCell(Text('+5%')),
                            DataCell(StatusChip(RecordStatus.present)),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('إيرادات اليوم')),
                            DataCell(Text('4,850 ج.م')),
                            DataCell(Text('+8%')),
                            DataCell(StatusChip(RecordStatus.paid)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
