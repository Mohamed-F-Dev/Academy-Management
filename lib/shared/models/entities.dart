import 'package:equatable/equatable.dart';

enum RecordStatus { active, inactive, pending, paid, partial, absent, present }

class Student extends Equatable {
  const Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.guardian,
    required this.guardianPhone,
    required this.birthDate,
    required this.address,
    required this.status,
    this.notes = '',
    this.group = 'المستوى المتقدم',
    this.balance = 0,
  });
  final String id, name, phone, guardian, guardianPhone, birthDate, address, notes, group;
  final RecordStatus status;
  final double balance;
  Student copyWith({
    String? name, String? phone, String? guardian, String? guardianPhone,
    String? birthDate, String? address, String? notes, String? group,
    RecordStatus? status, double? balance,
  }) => Student(
    id: id, name: name ?? this.name, phone: phone ?? this.phone,
    guardian: guardian ?? this.guardian, guardianPhone: guardianPhone ?? this.guardianPhone,
    birthDate: birthDate ?? this.birthDate, address: address ?? this.address,
    status: status ?? this.status, notes: notes ?? this.notes, group: group ?? this.group,
    balance: balance ?? this.balance,
  );
  @override
  List<Object?> get props => [id, name, phone, guardian, guardianPhone, birthDate, address, status, notes, group, balance];
}

class Teacher extends Equatable {
  const Teacher({
    required this.id, required this.name, required this.email, required this.phone,
    required this.specialty, required this.status, this.groups = 0,
  });
  final String id, name, email, phone, specialty;
  final RecordStatus status;
  final int groups;
  Teacher copyWith({String? name, String? email, String? phone, String? specialty, RecordStatus? status}) => Teacher(
    id: id, name: name ?? this.name, email: email ?? this.email, phone: phone ?? this.phone,
    specialty: specialty ?? this.specialty, status: status ?? this.status, groups: groups,
  );
  @override
  List<Object?> get props => [id, name, email, phone, specialty, status, groups];
}

class Group extends Equatable {
  const Group({
    required this.id, required this.name, required this.subject, required this.teacher,
    required this.room, required this.schedule, required this.capacity, required this.fee,
    this.students = 0,
  });
  final String id, name, subject, teacher, room, schedule;
  final int capacity, students;
  final double fee;
  Group copyWith({String? name, String? subject, String? teacher, String? room, String? schedule, int? capacity, double? fee}) => Group(
    id: id, name: name ?? this.name, subject: subject ?? this.subject, teacher: teacher ?? this.teacher,
    room: room ?? this.room, schedule: schedule ?? this.schedule, capacity: capacity ?? this.capacity,
    fee: fee ?? this.fee, students: students,
  );
  @override
  List<Object?> get props => [id, name, subject, teacher, room, schedule, capacity, fee, students];
}

class Lesson extends Equatable {
  const Lesson({required this.id, required this.title, required this.group, required this.teacher, required this.date, required this.time, required this.status});
  final String id, title, group, teacher, date, time;
  final RecordStatus status;
  @override
  List<Object?> get props => [id, title, group, teacher, date, time, status];
}

class AttendanceRecord extends Equatable {
  const AttendanceRecord({required this.id, required this.student, required this.group, required this.date, required this.status});
  final String id, student, group, date;
  final RecordStatus status;
  @override
  List<Object?> get props => [id, student, group, date, status];
}

class Payment extends Equatable {
  const Payment({required this.id, required this.studentId, required this.student, required this.month, required this.requiredAmount, required this.paidAmount, required this.method, required this.date, this.notes = ''});
  final String id, studentId, student, month, method, date, notes;
  final double requiredAmount, paidAmount;
  Payment copyWith({double? paidAmount, String? method, String? date, String? notes}) => Payment(
    id: id, studentId: studentId, student: student, month: month, requiredAmount: requiredAmount,
    paidAmount: paidAmount ?? this.paidAmount, method: method ?? this.method, date: date ?? this.date, notes: notes ?? this.notes,
  );
  @override
  List<Object?> get props => [id, studentId, student, month, requiredAmount, paidAmount, method, date, notes];
}
