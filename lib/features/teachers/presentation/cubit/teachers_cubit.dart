import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/data/repositories.dart';
import '../../../../shared/models/entities.dart';

class TeachersState extends Equatable {
  const TeachersState({this.loading = false, this.items = const [], this.query = ''});
  final bool loading; final List<Teacher> items; final String query;
  TeachersState copyWith({bool? loading, List<Teacher>? items, String? query}) => TeachersState(loading: loading ?? this.loading, items: items ?? this.items, query: query ?? this.query);
  @override List<Object?> get props => [loading, items, query];
}
class TeachersCubit extends Cubit<TeachersState> {
  TeachersCubit(this.repository) : super(const TeachersState()) { load(); }
  final MockTeacherRepository repository;
  Future<void> load() async { emit(state.copyWith(loading: true)); emit(state.copyWith(loading: false, items: await repository.getTeachers())); }
  void search(String value) => emit(state.copyWith(query: value));
  List<Teacher> get visible => state.items.where((t) => '${t.name} ${t.specialty}'.contains(state.query)).toList();
  Future<void> save(Teacher item) async { await repository.save(item); await load(); }
}
