import '../models/entities.dart';
import 'mock_store.dart';

abstract class MockRepository {
  Future<void> delay() async => Future<void>.delayed(const Duration(milliseconds: 180));
}

class MockAcademyRepository extends MockRepository {
  MockAcademyRepository(this.store); final MockStore store;
  Future<Map<String, String>> getAcademy() async { await delay(); return {'name': store.academyName, 'logo': store.academyLogo, 'phone': store.academyPhone, 'email': store.academyEmail, 'address': store.academyAddress, 'manager': store.academyManager, 'description': store.academyDescription}; }
  Future<void> saveAcademy(Map<String, String> data) async { await delay(); store.academyName = data['name'] ?? store.academyName; store.academyLogo = data['logo'] ?? store.academyLogo; store.academyPhone = data['phone'] ?? store.academyPhone; store.academyEmail = data['email'] ?? store.academyEmail; store.academyAddress = data['address'] ?? store.academyAddress; store.academyManager = data['manager'] ?? store.academyManager; store.academyDescription = data['description'] ?? store.academyDescription; }
}
class MockStudentRepository extends MockRepository {
  MockStudentRepository(this.store); final MockStore store;
  Future<List<Student>> getStudents() async { await delay(); return List.of(store.students); }
  Future<Student?> getStudentById(String id) async { await delay(); return store.students.where((s) => s.id == id).firstOrNull; }
  Future<void> save(Student student) async { await delay(); final i = store.students.indexWhere((s) => s.id == student.id); if (i == -1) store.students.add(student); else store.students[i] = student; }
  Future<void> delete(String id) async { await delay(); store.students.removeWhere((s) => s.id == id); }
}
class MockTeacherRepository extends MockRepository {
  MockTeacherRepository(this.store); final MockStore store;
  Future<List<Teacher>> getTeachers() async { await delay(); return List.of(store.teachers); }
  Future<void> save(Teacher item) async { await delay(); final i = store.teachers.indexWhere((x) => x.id == item.id); if (i == -1) store.teachers.add(item); else store.teachers[i] = item; }
}
class MockGroupRepository extends MockRepository {
  MockGroupRepository(this.store); final MockStore store;
  Future<List<Group>> getGroups() async { await delay(); return List.of(store.groups); }
  Future<void> save(Group item) async { await delay(); final i = store.groups.indexWhere((x) => x.id == item.id); if (i == -1) store.groups.add(item); else store.groups[i] = item; }
}
class MockLessonRepository extends MockRepository {
  MockLessonRepository(this.store); final MockStore store;
  Future<List<Lesson>> getLessons() async { await delay(); return List.of(store.lessons); }
}
class MockAttendanceRepository extends MockRepository {
  MockAttendanceRepository(this.store); final MockStore store;
  Future<List<AttendanceRecord>> getAttendance() async { await delay(); return List.of(store.attendance); }
  Future<void> save(AttendanceRecord item) async { await delay(); final i = store.attendance.indexWhere((x) => x.id == item.id); if (i == -1) store.attendance.add(item); else store.attendance[i] = item; }
}
class MockPaymentRepository extends MockRepository {
  MockPaymentRepository(this.store); final MockStore store;
  Future<List<Payment>> getPayments() async { await delay(); return List.of(store.payments); }
  Future<void> save(Payment item) async { await delay(); final i = store.payments.indexWhere((x) => x.id == item.id); if (i == -1) store.payments.add(item); else store.payments[i] = item; }
}
class MockReportRepository extends MockRepository {
  MockReportRepository(this.store); final MockStore store;
  Future<Map<String, num>> getSummary() async { await delay(); return {'students': store.students.length, 'teachers': store.teachers.length, 'groups': store.groups.length, 'revenue': store.payments.fold<double>(0, (sum, p) => sum + p.paidAmount)}; }
}
class MockSettingsRepository extends MockRepository {
  MockSettingsRepository(this.store); final MockStore store;
  Future<void> save() async => delay();
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
