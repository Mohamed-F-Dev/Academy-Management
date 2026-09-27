import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/models/entities.dart';
import '../../../../shared/widgets/management_widgets.dart';
import '../cubit/teacher_cubit.dart';

class TeacherGroupDetailsPage extends StatelessWidget {
  const TeacherGroupDetailsPage({required this.groupId, super.key});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeacherCubit>().state;
    final group = state.groups.firstWhere(
      (item) => item.id == groupId,
      orElse: () => state.groups.first,
    );
    final students = state.students
        .where((student) => student.group == group.name)
        .toList();
    final lessons = state.lessons
        .where((lesson) => lesson.group == group.name)
        .toList();
    return _TeacherDetailScaffold(
      title: group.name,
      subtitle: 'تفاصيل المجموعة والطلاب والجدول وآخر الحصص',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoCard(
            title: 'معلومات المجموعة',
            children: [
              _InfoLine(label: 'المادة', value: group.subject),
              _InfoLine(label: 'عدد الطلاب', value: '${students.length} طالب'),
              _InfoLine(label: 'الموعد القادم', value: group.schedule),
              _InfoLine(label: 'المكان', value: group.room),
            ],
          ),
          const SizedBox(height: 14),
          _ListCard(
            title: 'الطلاب',
            children: students.isEmpty
                ? [const EmptyState(message: 'لا يوجد طلاب في هذه المجموعة')]
                : students
                      .map(
                        (student) => ListTile(
                          leading: CircleAvatar(
                            child: Text(student.name.substring(0, 1)),
                          ),
                          title: Text(student.name),
                          subtitle: Text(student.phone),
                          trailing: const Icon(Icons.chevron_left),
                          onTap: () =>
                              context.push('/teacher/student/${student.id}'),
                        ),
                      )
                      .toList(),
          ),
          const SizedBox(height: 14),
          _ListCard(
            title: 'الجدول',
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: Text(group.schedule),
                subtitle: Text(group.room),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ListCard(
            title: 'آخر الحصص',
            children: lessons.isEmpty
                ? [const EmptyState(message: 'لا توجد حصص مسجلة بعد')]
                : lessons
                      .map(
                        (lesson) => ListTile(
                          leading: const Icon(Icons.menu_book_outlined),
                          title: Text(lesson.title),
                          subtitle: Text('${lesson.date} • ${lesson.time}'),
                        ),
                      )
                      .toList(),
          ),
        ],
      ),
    );
  }
}

class TeacherStudentDetailsPage extends StatelessWidget {
  const TeacherStudentDetailsPage({required this.studentId, super.key});
  final String studentId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeacherCubit>().state;
    final student = state.students.firstWhere(
      (item) => item.id == studentId,
      orElse: () => state.students.first,
    );
    final records = state.attendance.where(
      (record) => record.student == student.name,
    );
    final present = records
        .where((record) => record.status == RecordStatus.present)
        .length;
    final rate = records.isEmpty ? 0 : (present * 100 ~/ records.length);
    return _TeacherDetailScaffold(
      title: 'تفاصيل الطالب',
      subtitle: 'بيانات الطالب داخل مجموعاتك فقط',
      child: _InfoCard(
        title: student.name,
        children: [
          _InfoLine(label: 'المجموعة', value: student.group),
          _InfoLine(label: 'رقم الهاتف', value: student.phone),
          _InfoLine(label: 'نسبة الحضور', value: '$rate%'),
          _InfoLine(
            label: 'ملاحظات',
            value: student.notes.isEmpty ? 'لا توجد ملاحظات' : student.notes,
          ),
        ],
      ),
    );
  }
}

class TeacherLessonDetailsPage extends StatelessWidget {
  const TeacherLessonDetailsPage({required this.lessonId, super.key});
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeacherCubit>().state;
    final lesson = state.lessons.firstWhere(
      (item) => item.id == lessonId,
      orElse: () => state.lessons.first,
    );
    final group = state.groups.firstWhere(
      (item) => item.name == lesson.group,
      orElse: () => state.groups.first,
    );
    return _TeacherDetailScaffold(
      title: lesson.title,
      subtitle: 'تفاصيل الحصة وتسجيل حضور الطلاب',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoCard(
            title: 'بيانات الحصة',
            children: [
              _InfoLine(label: 'المجموعة', value: lesson.group),
              _InfoLine(label: 'التاريخ', value: lesson.date),
              _InfoLine(label: 'الوقت والمكان', value: lesson.time),
              _InfoLine(label: 'الحالة', value: 'حصة قادمة'),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push('/teacher/attendance/${lesson.id}'),
            icon: const Icon(Icons.fact_check_outlined),
            label: Text('تسجيل الحضور • ${group.name}'),
          ),
        ],
      ),
    );
  }
}

class TeacherCreateLessonPage extends StatefulWidget {
  const TeacherCreateLessonPage({super.key});
  @override
  State<TeacherCreateLessonPage> createState() =>
      _TeacherCreateLessonPageState();
}

class _TeacherCreateLessonPageState extends State<TeacherCreateLessonPage> {
  final formKey = GlobalKey<FormState>();
  final date = TextEditingController(text: '27 سبتمبر 2026');
  final startTime = TextEditingController(text: '04:00 م');
  final endTime = TextEditingController(text: '05:30 م');
  final room = TextEditingController(text: 'قاعة 3');
  final notes = TextEditingController();
  String? group;

  @override
  void dispose() {
    date.dispose();
    startTime.dispose();
    endTime.dispose();
    room.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<TeacherCubit>().state.groups;
    group ??= groups.isEmpty ? null : groups.first.name;
    return _TeacherDetailScaffold(
      title: 'إنشاء حصة',
      subtitle: 'أضف حصة جديدة إلى جدول مجموعتك',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: group,
              decoration: const InputDecoration(labelText: 'المجموعة'),
              items: groups
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.name,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => group = value),
              validator: (value) => value == null ? 'اختر المجموعة' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: date,
              decoration: const InputDecoration(
                labelText: 'التاريخ',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: _required,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: startTime,
                    decoration: const InputDecoration(labelText: 'وقت البداية'),
                    validator: _required,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: endTime,
                    decoration: const InputDecoration(labelText: 'وقت النهاية'),
                    validator: _required,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: room,
              decoration: const InputDecoration(labelText: 'المكان'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: notes,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'ملاحظات'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final selected = groups.firstWhere(
                  (item) => item.name == group,
                );
                await context.read<TeacherCubit>().createLesson(
                  group: selected.name,
                  subject: selected.subject,
                  date: date.text,
                  startTime: startTime.text,
                  endTime: endTime.text,
                  room: room.text,
                  notes: notes.text,
                );
                if (context.mounted) context.pop();
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('حفظ الحصة'),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'هذا الحقل مطلوب' : null;
}

class TeacherAttendancePage extends StatelessWidget {
  const TeacherAttendancePage({required this.lessonId, super.key});
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeacherCubit>().state;
    final lesson = state.lessons.firstWhere(
      (item) => item.id == lessonId,
      orElse: () => state.lessons.first,
    );
    final students = state.students
        .where((student) => student.group == lesson.group)
        .toList();
    final statuses = students.map((student) {
      return context
              .read<TeacherCubit>()
              .attendanceFor(student, lesson)
              ?.status ??
          RecordStatus.present;
    }).toList();
    final present = statuses
        .where((status) => status == RecordStatus.present)
        .length;
    final absent = statuses
        .where((status) => status == RecordStatus.absent)
        .length;
    final late = statuses.where((status) => status == RecordStatus.paid).length;
    return _TeacherDetailScaffold(
      title: 'تسجيل الحضور',
      subtitle: '${lesson.group} • ${lesson.date} • ${lesson.time}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'إجمالي الطلاب',
                  value: '${students.length}',
                  icon: Icons.groups_outlined,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricCard(
                  title: 'الحاضرون',
                  value: '$present',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricCard(
                  title: 'الغائبون',
                  value: '$absent',
                  icon: Icons.cancel_outlined,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricCard(
                  title: 'المتأخرون',
                  value: '$late',
                  icon: Icons.watch_later_outlined,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            child: Column(
              children: students.map((student) {
                final current =
                    context
                        .read<TeacherCubit>()
                        .attendanceFor(student, lesson)
                        ?.status ??
                    RecordStatus.present;
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text(student.phone),
                  trailing: DropdownButton<RecordStatus>(
                    value: current,
                    items: const [
                      DropdownMenuItem(
                        value: RecordStatus.present,
                        child: Text('حاضر'),
                      ),
                      DropdownMenuItem(
                        value: RecordStatus.absent,
                        child: Text('غائب'),
                      ),
                      DropdownMenuItem(
                        value: RecordStatus.inactive,
                        child: Text('متأخر'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context.read<TeacherCubit>().setAttendance(
                          student,
                          lesson,
                          value,
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await context.read<TeacherCubit>().saveAttendance();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حفظ الحضور بنجاح')),
                );
              }
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('حفظ الحضور'),
          ),
        ],
      ),
    );
  }
}

class TeacherProfileEditPage extends StatefulWidget {
  const TeacherProfileEditPage({super.key});
  @override
  State<TeacherProfileEditPage> createState() => _TeacherProfileEditPageState();
}

class _TeacherProfileEditPageState extends State<TeacherProfileEditPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController email;
  late final TextEditingController phone;
  late final TextEditingController specialty;

  @override
  void initState() {
    super.initState();
    final state = context.read<TeacherCubit>().state;
    name = TextEditingController(text: state.name);
    email = TextEditingController(text: state.email);
    phone = TextEditingController(text: state.phone);
    specialty = TextEditingController(text: state.specialty);
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    specialty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _TeacherDetailScaffold(
    title: 'تعديل الملف الشخصي',
    subtitle: 'حدّث بيانات حسابك المحلية',
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: name,
            decoration: const InputDecoration(labelText: 'اسم المدرس'),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: phone,
            decoration: const InputDecoration(labelText: 'رقم الهاتف'),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
            validator: (value) => value != null && value.contains('@')
                ? null
                : 'أدخل بريدًا إلكترونيًا صحيحًا',
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: specialty,
            decoration: const InputDecoration(labelText: 'المواد'),
            validator: _required,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await context.read<TeacherCubit>().updateProfile(
                name: name.text,
                email: email.text,
                phone: phone.text,
                specialty: specialty.text,
              );
              if (context.mounted) context.pop();
            },
            child: const Text('حفظ التغييرات'),
          ),
        ],
      ),
    ),
  );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'هذا الحقل مطلوب' : null;
}

class _TeacherDetailScaffold extends StatelessWidget {
  const _TeacherDetailScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('مساحة المدرس'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_forward),
        ),
      ),
      body: PageFrame(
        title: title,
        subtitle: subtitle,
        action: OutlinedButton(
          onPressed: () => context.pop(),
          child: const Text('رجوع'),
        ),
        child: child,
      ),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(height: 24),
          Wrap(spacing: 40, runSpacing: 18, children: children),
        ],
      ),
    ),
  );
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 210,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...children,
      ],
    ),
  );
}
