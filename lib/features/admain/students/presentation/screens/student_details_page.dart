import 'package:academy_management_system/core/layout/app_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/management_widgets.dart';
import '../cubit/students_cubit.dart';

class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({required this.studentId, super.key});

  final String studentId;

  static const Color _primary = Color(0xFF2E8B80);
  static const Color _text = Color(0xFF18324B);
  static const Color _muted = Color(0xFF718096);
  static const Color _border = Color(0xFFE8DED2);
  static const Color _background = Color(0xFFF9F6F1);

  @override
  Widget build(BuildContext context) {
    final student = context
        .watch<StudentsCubit>()
        .state
        .items
        .where((s) => s.id == studentId)
        .firstOrNull;

    if (student == null) {
      return const PageFrame(
        title: 'الطالب',
        subtitle: '',
        child: EmptyState(message: 'الطالب غير موجود'),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: PageFrame(
        child: Container(
          color: _background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Breadcrumb
              _Breadcrumb(studentName: student.name),

              const SizedBox(height: 18),

              /// Student Main Header
              _StudentHeader(
                name: student.name,
                studentId: student.id,
                onEdit: () {
                  // TODO: open edit student page
                },
                onPayment: () {
                  // TODO: open payment dialog
                },
              ),

              const SizedBox(height: 20),

              /// Statistics
              const _StatsSection(),

              const SizedBox(height: 20),

              /// Main body
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 950) {
                    return Column(
                      children: [
                        _ContactCard(
                          phone: student.phone,
                          guardian: student.guardian,
                          guardianPhone: student.guardianPhone,
                        ),
                        const SizedBox(height: 18),
                        _GroupsCard(group: student.group),
                        const SizedBox(height: 18),
                        const _PaymentsCard(),
                        const SizedBox(height: 18),
                        const _AttendanceCard(),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Right / main column
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _ContactCard(
                              phone: student.phone,
                              guardian: student.guardian,
                              guardianPhone: student.guardianPhone,
                            ),
                            const SizedBox(height: 18),
                            _GroupsCard(group: student.group),
                          ],
                        ),
                      ),

                      const SizedBox(width: 18),

                      /// Left column
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: const [
                            _PaymentsCard(),
                            SizedBox(height: 18),
                            _AttendanceCard(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Breadcrumb
/// ---------------------------------------------------------------------------

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.studentName});

  final String studentName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'الطلاب',
          style: TextStyle(
            color: StudentDetailsPage._primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 7),
        const Icon(
          Icons.chevron_left,
          size: 18,
          color: StudentDetailsPage._primary,
        ),
        const SizedBox(width: 7),
        Text(
          studentName,
          style: const TextStyle(
            color: StudentDetailsPage._muted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Student Header
/// ---------------------------------------------------------------------------

class _StudentHeader extends StatelessWidget {
  const _StudentHeader({
    required this.name,
    required this.studentId,
    required this.onEdit,
    required this.onPayment,
  });

  final String name;
  final String studentId;
  final VoidCallback onEdit;
  final VoidCallback onPayment;

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;

          final studentInfo = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DDD4),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials(name),
                  style: const TextStyle(
                    color: Color(0xFFB75E47),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملف الطالب · $studentId',
                    style: const TextStyle(
                      color: StudentDetailsPage._primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    name,
                    style: const TextStyle(
                      color: StudentDetailsPage._text,
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'مسجل في أكاديمية منارة',
                    style: TextStyle(
                      color: StudentDetailsPage._muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          );

          final actions = Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const _StatusBadge(),
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('تعديل الملف'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: StudentDetailsPage._text,
                  side: const BorderSide(color: StudentDetailsPage._border),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 17,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onPayment,
                icon: const Icon(Icons.attach_money, size: 18),
                label: const Text('تسجيل دفعة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: StudentDetailsPage._primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 17,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [studentInfo, const SizedBox(height: 20), actions],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [studentInfo, actions],
          );
        },
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');

    if (parts.isEmpty) return '';

    if (parts.length == 1) {
      return parts.first.characters.take(2).toString();
    }

    return '${parts.first.characters.first}'
        '${parts.last.characters.first}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'نشط',
        style: TextStyle(
          color: Color(0xFF3D9A68),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Statistics
/// ---------------------------------------------------------------------------

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, type, constraints) {
        int crossAxisCount;

        if (constraints.maxWidth >= 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: crossAxisCount == 1
              ? 3.8
              : crossAxisCount == 2
              ? 2.5
              : 1.5,
          children: const [
            _StatCard(
              title: 'معدل الحضور',
              value: '100٪',
              subtitle: 'آخر 30 يوماً',
              icon: Icons.assignment_turned_in_outlined,
              iconBackground: Color(0xFFE3F3EF),
              iconColor: Color(0xFF308F83),
            ),
            _StatCard(
              title: 'المجموعات',
              value: '٢',
              subtitle: 'مجموعات نشطة',
              icon: Icons.school_outlined,
              iconBackground: Color(0xFFF9E5DF),
              iconColor: Color(0xFFD96E59),
            ),
            _StatCard(
              title: 'إجمالي المدفوع',
              value: '٣٥٨ ج.م',
              subtitle: 'منذ بداية التسجيل',
              icon: Icons.account_balance_wallet_outlined,
              iconBackground: Color(0xFFF5ECD8),
              iconColor: Color(0xFFB98B36),
            ),
            _StatCard(
              title: 'المتبقي',
              value: '٩٤٢ ج.م',
              subtitle: 'مستحقات حالية',
              icon: Icons.monetization_on_outlined,
              iconBackground: Color(0xFFE4EBF2),
              iconColor: Color(0xFF4E6D89),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 21),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: StudentDetailsPage._muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: StudentDetailsPage._text,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: StudentDetailsPage._muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Contact
/// ---------------------------------------------------------------------------

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.phone,
    required this.guardian,
    required this.guardianPhone,
  });

  final String phone;
  final String guardian;
  final String guardianPhone;

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            title: 'بيانات التواصل',
            subtitle: 'المعلومات الأساسية لملف الطالب',
            icon: Icons.phone_outlined,
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 550) {
                return Column(
                  children: [
                    _ContactInfo(title: 'هاتف الطالب', value: phone),
                    const SizedBox(height: 20),
                    _ContactInfo(title: 'ولي الأمر', value: guardian),
                    const SizedBox(height: 20),
                    _ContactInfo(title: 'هاتف ولي الأمر', value: guardianPhone),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ContactInfo(title: 'هاتف الطالب', value: phone),
                  ),
                  Expanded(
                    child: _ContactInfo(title: 'ولي الأمر', value: guardian),
                  ),
                  Expanded(
                    child: _ContactInfo(
                      title: 'هاتف ولي الأمر',
                      value: guardianPhone,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const _ContactInfo(title: 'العنوان', value: 'مدينة نصر، القاهرة'),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: StudentDetailsPage._muted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: StudentDetailsPage._text,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Groups
/// ---------------------------------------------------------------------------

class _GroupsCard extends StatelessWidget {
  const _GroupsCard({required this.group});

  final String group;

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionHeader(
                  title: 'المجموعات المسجل بها',
                  subtitle: 'يمكن للطالب الانضمام لأكثر من مجموعة',
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('إدارة العضوية'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: StudentDetailsPage._text,
                  side: const BorderSide(color: StudentDetailsPage._border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _GroupRow(
            title: group.isEmpty ? 'إنجليزي - تأسيس' : group,
            schedule: 'السبت، الاثنين، الأربعاء · ٤ م',
            price: '١٥٠ ج.م / شهرياً',
          ),

          const Divider(height: 30, color: StudentDetailsPage._border),

          const _GroupRow(
            title: 'عربي - الصف السادس',
            schedule: 'السبت، الثلاثاء · ٣:٣٠ م',
            price: '١٦٠ ج.م / شهرياً',
          ),
        ],
      ),
    );
  }
}

class _GroupRow extends StatelessWidget {
  const _GroupRow({
    required this.title,
    required this.schedule,
    required this.price,
  });

  final String title;
  final String schedule;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(
            color: StudentDetailsPage._primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: StudentDetailsPage._text,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                schedule,
                style: const TextStyle(
                  color: StudentDetailsPage._muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            color: StudentDetailsPage._text,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Payments
/// ---------------------------------------------------------------------------

class _PaymentsCard extends StatelessWidget {
  const _PaymentsCard();

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionHeader(
                  title: 'آخر المدفوعات',
                  subtitle: 'سجل التحصيلات',
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left, size: 17),
                label: const Text('السجل الكامل'),
                style: TextButton.styleFrom(
                  foregroundColor: StudentDetailsPage._primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _PaymentRow(
            month: 'يناير 2025',
            date: '2025-02-01 · تحويل بنكي',
            amount: '٥٠٠ ج.م',
            status: 'معلق',
            statusColor: Color(0xFFB85B4A),
            statusBackground: Color(0xFFF9E2DD),
          ),
          const Divider(height: 28, color: StudentDetailsPage._border),
          const _PaymentRow(
            month: 'مارس 2025',
            date: '2025-02-25 · نقدي',
            amount: '٣٥٨ ج.م',
            status: 'مدفوع جزئياً',
            statusColor: Color(0xFFA87D25),
            statusBackground: Color(0xFFF7EED6),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.month,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
  });

  final String month;
  final String date;
  final String amount;
  final String status;
  final Color statusColor;
  final Color statusBackground;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                month,
                style: const TextStyle(
                  color: StudentDetailsPage._text,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date,
                style: const TextStyle(
                  color: StudentDetailsPage._muted,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(
                color: StudentDetailsPage._text,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: statusBackground,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Attendance
/// ---------------------------------------------------------------------------

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard();

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            title: 'الحضور الأخير',
            subtitle: 'من سجل الحصص',
            icon: Icons.assignment_turned_in_outlined,
          ),
          const SizedBox(height: 20),
          const _AttendanceRow(title: 'المراجعة الأسبوعية', date: '2025-02-01'),
          const Divider(color: StudentDetailsPage._border),
          const _AttendanceRow(title: 'اختبار قصير', date: '2025-02-03'),
          const Divider(color: StudentDetailsPage._border),
          const _AttendanceRow(title: 'حل تدريبات الوحدة', date: '2025-02-10'),
          const Divider(color: StudentDetailsPage._border),
          const _AttendanceRow(title: 'شرح الدرس الجديد', date: '2025-02-12'),
          const Divider(color: StudentDetailsPage._border),
          const _AttendanceRow(title: 'اختبار قصير', date: '2025-02-19'),
        ],
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  const _AttendanceRow({required this.title, required this.date});

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: StudentDetailsPage._text,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: StudentDetailsPage._muted,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2E9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'حاضر',
              style: TextStyle(
                color: Color(0xFF388E67),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Shared components
/// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.icon,
  });

  final String title;
  final String subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: StudentDetailsPage._text),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: StudentDetailsPage._text,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: StudentDetailsPage._muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppCard extends StatelessWidget {
  const _AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: StudentDetailsPage._border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
