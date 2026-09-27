import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/data/repositories.dart';
import '../../../../shared/models/entities.dart';

class AttendanceState extends Equatable {
  const AttendanceState({this.loading = false, this.items = const []});
  final bool loading; final List<AttendanceRecord> items;
  AttendanceState copyWith({bool? loading, List<AttendanceRecord>? items}) => AttendanceState(loading: loading ?? this.loading, items: items ?? this.items);
  @override List<Object?> get props => [loading, items];
}
class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this.repository) : super(const AttendanceState()) { load(); }
  final MockAttendanceRepository repository;
  Future<void> load() async { emit(state.copyWith(loading: true)); emit(state.copyWith(loading: false, items: await repository.getAttendance())); }
  Future<void> setStatus(AttendanceRecord item, RecordStatus status) async { await repository.save(AttendanceRecord(id: item.id, student: item.student, group: item.group, date: item.date, status: status)); await load(); }
}
