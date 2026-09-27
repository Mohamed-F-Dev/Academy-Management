import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/cubit/teacher_cubit.dart';
import '../../../shared/widgets/management_widgets.dart';

class TeacherScheduleView extends StatefulWidget {
  const TeacherScheduleView({super.key});
  @override
  State<TeacherScheduleView> createState() => _TeacherScheduleViewState();
}

class _TeacherScheduleViewState extends State<TeacherScheduleView> {
  bool week = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeacherCubit>().state;
    return PageFrame(
      title: 'الجدول',
      subtitle: 'خطة حصصك ومجموعاتك فقط',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('27 سبتمبر - 3 أكتوبر',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('اليوم')),
                  ButtonSegment(value: true, label: Text('الأسبوع')),
                ],
                selected: {week},
                onSelectionChanged: (value) =>
                    setState(() => week = value.first),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (state.lessons.isEmpty)
            const Card(child: EmptyState(message: 'لا توجد حصص مجدولة'))
          else
            ...state.lessons.map((lesson) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFDDEFEA),
                      child: Icon(Icons.event_note_outlined,
                          color: Color(0xFF287A78), size: 19),
                    ),
                    title: Text(lesson.group,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${lesson.title} • ${lesson.date}\n${lesson.time}'),
                    isThreeLine: true,
                  ),
                )),
        ],
      ),
    );
  }
}