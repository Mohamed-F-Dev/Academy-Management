import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/data/repositories.dart';

class ReportsState extends Equatable {
  const ReportsState({this.loading = false, this.summary = const {}});
  final bool loading; final Map<String, num> summary;
  ReportsState copyWith({bool? loading, Map<String, num>? summary}) => ReportsState(loading: loading ?? this.loading, summary: summary ?? this.summary);
  @override List<Object?> get props => [loading, summary];
}
class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this.repository) : super(const ReportsState()) { load(); }
  final MockReportRepository repository;
  Future<void> load() async { emit(state.copyWith(loading: true)); emit(state.copyWith(loading: false, summary: await repository.getSummary())); }
}
