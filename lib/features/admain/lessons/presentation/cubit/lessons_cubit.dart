import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/data/repositories.dart';
import '../../../../../shared/models/entities.dart';

class LessonsState extends Equatable {
  const LessonsState({this.loading = false, this.items = const []});
  final bool loading;
  final List<Lesson> items;
  LessonsState copyWith({bool? loading, List<Lesson>? items}) => LessonsState(
    loading: loading ?? this.loading,
    items: items ?? this.items,
  );
  @override
  List<Object?> get props => [loading, items];
}

class LessonsCubit extends Cubit<LessonsState> {
  LessonsCubit(this.repository) : super(const LessonsState()) {
    load();
  }
  final MockLessonRepository repository;
  Future<void> load() async {
    emit(state.copyWith(loading: true));
    emit(state.copyWith(loading: false, items: await repository.getLessons()));
  }
}
