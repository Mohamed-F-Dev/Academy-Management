import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';
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
                    childAspectRatio: c.maxWidth < 500 ? 1.35 : 1.75,
                    children: [
                      MetricCard(
                        title: 'إجمالي الطلاب',
                        value:
                            '${report.summary['students'] ?? students.items.length}',
                        icon: Icons.groups_rounded,
                        color: const Color(0xFF0F766E),
                        caption: '+12% هذا الشهر',
                      ),
                      MetricCard(
                        title: 'المدرسون',
                        value: '${report.summary['teachers'] ?? 0}',
                        icon: Icons.co_present_rounded,
                        color: const Color(0xFF7A5AF8),
                      ),
                      MetricCard(
                        title: 'المجموعات',
                        value: '${report.summary['groups'] ?? 0}',
                        icon: Icons.category_rounded,
                        color: const Color(0xFFF79009),
                      ),
                      MetricCard(
                        title: 'إيرادات الشهر',
                        value:
                            '${(report.summary['revenue'] ?? 0).toStringAsFixed(0)} ج.م',
                        icon: Icons.payments_rounded,
                        color: const Color(0xFF12B76A),
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
                      child: SectionCard(
                        title: 'الحضور خلال الأسبوع',
                        subtitle: 'عدد الطلاب الحاضرين لكل يوم',
                        child: SizedBox(
                          height: 240,
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
                                            color: const Color(0xFF0F766E),
                                            width: 18,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                      child: SectionCard(
                        title: 'حالة الاشتراكات',
                        subtitle: 'توزيع سداد الرسوم الشهرية',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 190,
                              child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 4,
                                    centerSpaceRadius: 48,
                                    sections: [
                                      PieChartSectionData(
                                        value: 68,
                                        color: const Color(0xFF12B76A),
                                        title: '68%',
                                        radius: 55,
                                        titleStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        value: 20,
                                        color: const Color(0xFFF79009),
                                        title: '20%',
                                        radius: 55,
                                        titleStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        value: 12,
                                        color: const Color(0xFFF04438),
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
                                spacing: 14,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _LegendDot(
                                    const Color(0xFF12B76A),
                                    'مدفوع',
                                  ),
                                  _LegendDot(
                                    const Color(0xFFF79009),
                                    'جزئي',
                                  ),
                                  _LegendDot(
                                    const Color(0xFFF04438),
                                    'متأخر',
                                  ),
                                ],
                              ),
                            ],
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
      height: 116,
      padding: const EdgeInsets.fromLTRB(26, 0, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF117B72), Color(0xFF0C4F47)],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0x26FFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: const Center(
              child: Icon(
                Icons.bar_chart_rounded,
                color: const Color(0xFFB9E3DA),
                size: 27,
              ),
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'الأكاديمية تسير بإيقاع جيد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'استمر في متابعة الحضور والمدفوعات للحفاظ على هذا الأداء',
                  style: TextStyle(
                    color: const Color(0xFFCBE2DE),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(value * 87).round()}٪',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'معدل الأداء',
                style: TextStyle(
                  color: const Color(0xFFCBE2DE),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _LegendDot extends StatelessWidget {
  const _LegendDot(this.color, this.label);
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(999)),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppTheme.muted),
      ),
    ],
  );
}
