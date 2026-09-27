import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/data/repositories.dart';

class AcademyState extends Equatable {
  const AcademyState({this.loading = false, this.data = const {}, this.saved = false, this.error});
  final bool loading, saved;
  final Map<String, String> data;
  final String? error;
  AcademyState copyWith({bool? loading, Map<String, String>? data, bool? saved, String? error}) => AcademyState(loading: loading ?? this.loading, data: data ?? this.data, saved: saved ?? this.saved, error: error);
  @override List<Object?> get props => [loading, data, saved, error];
}
class AcademyCubit extends Cubit<AcademyState> {
  AcademyCubit(this.repository) : super(const AcademyState()) { load(); }
  final MockAcademyRepository repository;
  Future<void> load() async { emit(state.copyWith(loading: true)); emit(state.copyWith(loading: false, data: await repository.getAcademy())); }
  Future<void> save(Map<String, String> data) async { emit(state.copyWith(loading: true, saved: false)); try { await repository.saveAcademy(data); emit(state.copyWith(loading: false, data: data, saved: true)); } catch (_) { emit(state.copyWith(loading: false, error: 'تعذر حفظ الإعدادات')); } }
}
