import 'package:academy_management_system/features/admain/teachers/presentation/widget/add_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/models/entities.dart';

import '../../../../../shared/widgets/management_widgets.dart';
import '../cubit/teachers_cubit.dart';

class TeachersPage extends StatelessWidget {
  const TeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: const Color(0xFFFFFCF8),
        child: PageFrame(
          title: 'المدرسون',
          subtitle: '8 مدرسين · توزيع الحصص والمجموعات',
          action: SizedBox(
            height: 42,
            child: FilledButton.icon(
              onPressed: () => showTeacherDialog(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'إضافة مدرس',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF25877D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          child: BlocBuilder<TeachersCubit, TeachersState>(
            builder: (context, state) {
              final cubit = context.read<TeachersCubit>();
              final teachers = cubit.visible;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TeachersToolbar(onSearch: cubit.search, onFilter: () {}),
                  const SizedBox(height: 16),
                  if (teachers.isEmpty)
                    const EmptyState(message: 'لا توجد نتائج')
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 650) {
                          return _TeachersMobileList(items: teachers);
                        }

                        return _TeachersGrid(items: teachers);
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TeachersToolbar extends StatelessWidget {
  const _TeachersToolbar({required this.onSearch, required this.onFilter});

  final ValueChanged<String> onSearch;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6DDD2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearch,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'ابحث عن مدرس أو مادة...',
                hintStyle: const TextStyle(
                  color: Color(0xFF7C8898),
                  fontSize: 11,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Color(0xFF60748B),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFCF8),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5DDD3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF25877D)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: onFilter,
            icon: const Icon(Icons.tune, size: 18),
            label: const Text(
              'الفلاتر',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF35445A),
              side: const BorderSide(color: Color(0xFFE1D8CD)),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeachersGrid extends StatelessWidget {
  const _TeachersGrid({required this.items});

  final List<Teacher> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;

        if (constraints.maxWidth >= 1050) {
          columns = 3;
        } else if (constraints.maxWidth >= 700) {
          columns = 2;
        } else {
          columns = 1;
        }

        const spacing = 14.0;

        final cardWidth =
            (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(items.length, (index) {
            return SizedBox(
              width: cardWidth,
              child: _TeacherCard(teacher: items[index], index: index),
            );
          }),
        );
      },
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({required this.teacher, required this.index});

  final Teacher teacher;
  final int index;

  static const avatarColors = [
    Color(0xFFDDEFEA),
    Color(0xFFF8DED5),
    Color(0xFFE1EFEA),
    Color(0xFFF8DDD6),
  ];

  static const avatarTextColors = [
    Color(0xFF277B74),
    Color(0xFFB35D49),
    Color(0xFF277B74),
    Color(0xFFB35D49),
  ];

  @override
  Widget build(BuildContext context) {
    final avatarColor = avatarColors[index % avatarColors.length];

    final avatarTextColor = avatarTextColors[index % avatarTextColors.length];

    final initials = _getInitials(teacher.name);

    return Container(
      height: 224,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5DDD3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: avatarTextColor,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  splashRadius: 18,
                  tooltip: '',
                  position: PopupMenuPosition.under,
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 19,
                    color: Color(0xFF64788F),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      showTeacherDialog(context, item: teacher);
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('تعديل'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 17),
            Text(
              teacher.name,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF26394F),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              teacher.specialty,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF718095),
                fontSize: 10,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE9E1D7)),
            const SizedBox(height: 13),
            Row(
              children: [
                _InfoItem(
                  icon: Icons.school_outlined,
                  text: '${teacher.groups} مجموعات',
                ),
                const SizedBox(width: 16),
                const _InfoItem(
                  icon: Icons.calendar_month_outlined,
                  text: '6 حصص/أسبوع',
                ),
              ],
            ),
            const SizedBox(height: 13),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE9E1D7)),
            const Spacer(),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    showTeacherDialog(context, item: teacher);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض الملف',
                          style: TextStyle(
                            color: Color(0xFF168179),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.chevron_left,
                          size: 16,
                          color: Color(0xFF168179),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                _TeacherStatus(status: teacher.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((e) => e.isNotEmpty).toList();

    if (parts.isEmpty) {
      return '';
    }

    if (parts.length == 1) {
      final value = parts.first;

      if (value.length >= 2) {
        return value.substring(0, 2);
      }

      return value;
    }

    return '${parts[0][0]}${parts[1][0]}';
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF718298)),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 9, color: Color(0xFF718298)),
        ),
      ],
    );
  }
}

class _TeacherStatus extends StatelessWidget {
  const _TeacherStatus({required this.status});

  final RecordStatus status;

  @override
  Widget build(BuildContext context) {
    final isActive = status == RecordStatus.active;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE2F4E9) : const Color(0xFFF2E7E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'نشط' : 'غير نشط',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF39835B) : const Color(0xFFAC5F59),
        ),
      ),
    );
  }
}

class _TeachersMobileList extends StatelessWidget {
  const _TeachersMobileList({required this.items});

  final List<Teacher> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _TeacherCard(teacher: items[index], index: index),
        );
      }),
    );
  }
}
