import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/management_widgets.dart';
import '../../../reports/presentation/cubit/reports_cubit.dart';
import '../../../students/presentation/cubit/students_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'مساحة أكاديمية منارة',
      subtitle: 'نظرة عامة على أداء الأكاديمية اليوم',
      action: FilledButton.icon(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('افتح صفحة الطلاب لإضافة طالب جديد')),
        ),
        icon: const Icon(Icons.add, size: 16),
        label: const Text('إضافة طالب'),
      ),
      child: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, report) => BlocBuilder<StudentsCubit, StudentsState>(
          builder: (context, students) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AcademyHero(),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, c) {
                  final columns = c.maxWidth < 700 ? 2 : 4;
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: c.maxWidth < 500 ? 1.35 : 1.8,
                    children: [
                      MetricCard(
                        title: 'إجمالي الطلاب',
                        value:
                            '${report.summary['students'] ?? students.items.length}',
                        icon: Icons.groups_rounded,
                        color: Colors.blue,
                        caption: '+12% هذا الشهر',
                      ),
                      MetricCard(
                        title: 'المدرسون',
                        value: '${report.summary['teachers'] ?? 0}',
                        icon: Icons.co_present_rounded,
                        color: Colors.deepPurple,
                      ),
                      MetricCard(
                        title: 'المجموعات',
                        value: '${report.summary['groups'] ?? 0}',
                        icon: Icons.category_rounded,
                        color: Colors.orange,
                      ),
                      MetricCard(
                        title: 'إيرادات الشهر',
                        value:
                            '${(report.summary['revenue'] ?? 0).toStringAsFixed(0)} ج.م',
                        icon: Icons.payments_rounded,
                        color: Colors.green,
                        caption: '+8% هذا الشهر',
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, c) => Flex(
                  direction: c.maxWidth > 850 ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: c.maxWidth > 850 ? 3 : 0,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'الحضور خلال الأسبوع',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 230,
                                child: BarChart(
                                  BarChartData(
                                    borderData: FlBorderData(show: false),
                                    gridData: const FlGridData(show: false),
                                    titlesData: FlTitlesData(
                                      leftTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (v, _) => Text(
                                            [
                                              'س',
                                              'ح',
                                              'ن',
                                              'ث',
                                              'ر',
                                              'خ',
                                              'ج',
                                            ][v.toInt().clamp(0, 6).toInt()],
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    barGroups: List.generate(
                                      7,
                                      (i) => BarChartGroupData(
                                        x: i,
                                        barRods: [
                                          BarChartRodData(
                                            toY: [
                                              12,
                                              18,
                                              15,
                                              21,
                                              17,
                                              19,
                                              14,
                                            ][i].toDouble(),
                                            color: const Color(0xFF315CFF),
                                            width: 16,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (c.maxWidth > 850)
                      const SizedBox(width: 18)
                    else
                      const SizedBox(height: 18),
                    Expanded(
                      flex: c.maxWidth > 850 ? 2 : 0,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'حالة الاشتراكات',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 220,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 4,
                                    centerSpaceRadius: 48,
                                    sections: [
                                      PieChartSectionData(
                                        value: 68,
                                        color: Colors.green,
                                        title: '68%',
                                        radius: 55,
                                        titleStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        value: 20,
                                        color: Colors.orange,
                                        title: '20%',
                                        radius: 55,
                                        titleStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        value: 12,
                                        color: Colors.redAccent,
                                        title: '12%',
                                        radius: 55,
                                        titleStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Wrap(
                                spacing: 12,
                                children: [
                                  Text(
                                    '● مدفوع',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                    '● جزئي',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  Text(
                                    '● متأخر',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AcademyHero extends StatelessWidget {
  const _AcademyHero();
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 700),
    curve: Curves.easeOutCubic,
    builder: (context, value, _) => Container(
      height: 94,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF236D6B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 66,
            decoration: BoxDecoration(
              color: const Color(0x332B9290),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: Color(0xFFE39A73),
              size: 48,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'الأكاديمية تسير بإيقاع جيد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'استمر في متابعة الحضور والمدفوعات للحفاظ على هذا الأداء',
                  style: TextStyle(color: Color(0xFFC8E0DE), fontSize: 9),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(value * 87).round()}٪',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'معدل الأداء',
                style: TextStyle(color: Color(0xFFC8E0DE), fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
