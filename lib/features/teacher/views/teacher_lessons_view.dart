import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/cubit/teacher_cubit.dart';
import '../../../shared/models/entities.dart';
import '../../../shared/widgets/management_widgets.dart';

class TeacherLessonsView extends StatefulWidget {
  const TeacherLessonsView({super.key});
  @override
  State<TeacherLessonsView> createState() => _TeacherLessonsViewState();
}

class _TeacherLessonsViewState extends State<TeacherLessonsView> {
  bool upcoming = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        final lessons = state.lessons
            .where((lesson) => upcoming
                ? lesson.status == RecordStatus.pending
                : lesson.status != RecordStatus.pending)
            .toList();
        return PageFrame(
          title: 'الحصص',
          subtitle: 'حصصك الخاصة وتسجيل حضور طلابك',
          action: FilledButton.icon(
            onPressed: () => context.push('/teacher/lesson/create'),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('إنشاء حصة'),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('القادمة')),
                  ButtonSegment(value: false, label: Text('السابقة')),
                ],
                selected: {upcoming},
                onSelectionChanged: (value) =>
                    setState(() => upcoming = value.first),
              ),
              const SizedBox(height: 16),
              if (lessons.isEmpty)
                const Card(child: EmptyState(message: 'لا توجد حصص في هذا القسم'))
              else
                ...lessons.map((lesson) => _LessonCard(lesson: lesson)),
            ],
          ),
        );
      },
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 12,
            children: [
              const Icon(Icons.menu_book_outlined, color: Color(0xFF287A78)),
              SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('${lesson.group} • ${lesson.date}',
                        style: const TextStyle(
                            color: Color(0xFF8B8D8A), fontSize: 11)),
                    Text(lesson.time,
                        style: const TextStyle(
                            color: Color(0xFF287A78), fontSize: 11)),
                  ],
                ),
              ),
              StatusChip(lesson.status),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        context.push('/teacher/lesson/${lesson.id}'),
                    child: const Text('التفاصيل'),
                  ),
                  if (lesson.status == RecordStatus.pending)
                    FilledButton(
                      onPressed: () =>
                          context.push('/teacher/attendance/${lesson.id}'),
                      child: const Text('تسجيل الحضور'),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}