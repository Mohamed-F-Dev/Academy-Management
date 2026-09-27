import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/data/repositories.dart';
import '../../../../../shared/models/entities.dart';

class StudentsState extends Equatable {
  const StudentsState({
    this.loading = false,
    this.items = const [],
    this.query = '',
    this.filter = 'الكل',
    this.error,
  });
  final bool loading;
  final List<Student> items;
  final String query, filter;
  final String? error;
  StudentsState copyWith({
    bool? loading,
    List<Student>? items,
    String? query,
    String? filter,
    String? error,
  }) => StudentsState(
    loading: loading ?? this.loading,
    items: items ?? this.items,
    query: query ?? this.query,
    filter: filter ?? this.filter,
    error: error,
  );
  @override
  List<Object?> get props => [loading, items, query, filter, error];
}

class StudentsCubit extends Cubit<StudentsState> {
  StudentsCubit(this.repository) : super(const StudentsState()) {
    load();
  }
  final MockStudentRepository repository;
  Future<void> load() async {
    emit(state.copyWith(loading: true));
    emit(state.copyWith(loading: false, items: await repository.getStudents()));
  }

  void search(String value) => emit(state.copyWith(query: value));
  void filter(String value) => emit(state.copyWith(filter: value));
  List<Student> get visible => state.items
      .where(
        (s) =>
            (state.query.isEmpty ||
                '${s.name} ${s.phone}'.contains(state.query)) &&
            (state.filter == 'الكل' ||
                (state.filter == 'نشط' && s.status == RecordStatus.active) ||
                (state.filter == 'غير نشط' &&
                    s.status == RecordStatus.inactive)),
      )
      .toList();
  Future<void> save(Student item) async {
    emit(state.copyWith(loading: true));
    await repository.save(item);
    await load();
  }

  Future<void> delete(String id) async {
    emit(state.copyWith(loading: true));
    await repository.delete(id);
    await load();
  }
}
