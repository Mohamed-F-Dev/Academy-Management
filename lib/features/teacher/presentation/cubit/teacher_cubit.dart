import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/data/mock_store.dart';
import '../../../../shared/models/entities.dart';

class TeacherState extends Equatable {
  const TeacherState({
    this.loading = false,
    this.groups = const [],
    this.students = const [],
    this.lessons = const [],
    this.attendance = const [],
    this.query = '',
    this.name = 'أحمد محمود',
    this.email = 'ahmed@academy.com',
    this.phone = '01012345678',
    this.specialty = 'Flutter - البرمجة',
  });

  final bool loading;
  final List<Group> groups;
  final List<Student> students;
  final List<Lesson> lessons;
  final List<AttendanceRecord> attendance;
  final String query;
  final String name;
  final String email;
  final String phone;
  final String specialty;

  TeacherState copyWith({
    bool? loading,
    List<Group>? groups,
    List<Student>? students,
    List<Lesson>? lessons,
    List<AttendanceRecord>? attendance,
    String? query,
    String? name,
    String? email,
    String? phone,
    String? specialty,
  }) =>
      TeacherState(
        loading: loading ?? this.loading,
        groups: groups ?? this.groups,
        students: students ?? this.students,
        lessons: lessons ?? this.lessons,
        attendance: attendance ?? this.attendance,
        query: query ?? this.query,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        specialty: specialty ?? this.specialty,
      );

  @override
  List<Object?> get props => [
        loading,
        groups,
        students,
        lessons,
        attendance,
        query,
        name,
        email,
        phone,
        specialty,
      ];
}

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit(this.store) : super(const TeacherState()) {
    loadTeacherData();
  }

  static const teacherName = 'أحمد محمود';
  final MockStore store;

  Future<void> loadTeacherData() async {
    emit(state.copyWith(loading: true));
    await Future<void>.delayed(const Duration(milliseconds: 120));

    final groups =
        store.groups.where((group) => group.teacher == teacherName).toList();
    final groupNames = groups.map((group) => group.name).toSet();
    final students =
        store.students.where((student) => groupNames.contains(student.group)).toList();
    final lessons =
        store.lessons.where((lesson) => lesson.teacher == teacherName).toList();
    final attendance = store.attendance
        .where((record) => groupNames.contains(record.group))
        .toList();

    emit(state.copyWith(
      loading: false,
      groups: groups,
      students: students,
      lessons: lessons,
      attendance: attendance,
    ));
  }

  List<Group> get visibleGroups {
    final q = state.query.trim();
    if (q.isEmpty) return state.groups;
    return state.groups
        .where((group) => '${group.name} ${group.subject}'.contains(q))
        .toList();
  }

  List<Student> get visibleStudents {
    final q = state.query.trim();
    if (q.isEmpty) return state.students;
    return state.students
        .where((student) => '${student.name} ${student.phone} ${student.group}'
            .contains(q))
        .toList();
  }

  void search(String value) => emit(state.copyWith(query: value));

  AttendanceRecord? attendanceFor(Student student, Lesson lesson) {
    for (final record in state.attendance) {
      if (record.student == student.name &&
          record.group == student.group &&
          record.date == lesson.date) {
        return record;
      }
    }
    return null;
  }

  Future<void> setAttendance(
    Student student,
    Lesson lesson,
    RecordStatus status,
  ) async {
    final index = store.attendance.indexWhere(
      (record) =>
          record.student == student.name &&
          record.group == student.group &&
          record.date == lesson.date,
    );
    final record = AttendanceRecord(
      id: index == -1
          ? 'teacher-attendance-${DateTime.now().microsecondsSinceEpoch}'
          : store.attendance[index].id,
      student: student.name,
      group: student.group,
      date: lesson.date,
      status: status,
    );
    if (index == -1) {
      store.attendance.add(record);
    } else {
      store.attendance[index] = record;
    }
    await loadTeacherData();
  }

  Future<void> saveAttendance() => loadTeacherData();

  Future<void> createLesson({
    required String group,
    required String subject,
    required String date,
    required String startTime,
    required String endTime,
    required String room,
    String notes = '',
  }) async {
    store.lessons.add(Lesson(
      id: 'teacher-lesson-${DateTime.now().microsecondsSinceEpoch}',
      title: subject,
      group: group,
      teacher: teacherName,
      date: date,
      time: '$startTime - $endTime • $room${notes.isEmpty ? '' : ' • $notes'}',
      status: RecordStatus.pending,
    ));
    await loadTeacherData();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String specialty,
  }) async {
    final teacherIndex =
        store.teachers.indexWhere((teacher) => teacher.name == teacherName);
    if (teacherIndex != -1) {
      store.teachers[teacherIndex] = store.teachers[teacherIndex].copyWith(
        name: name,
        email: email,
        phone: phone,
        specialty: specialty,
      );
    }
    emit(state.copyWith(
      name: name,
      email: email,
      phone: phone,
      specialty: specialty,
    ));
  }
}