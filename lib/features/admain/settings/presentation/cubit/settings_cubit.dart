import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/data/repositories.dart';

class SettingsState extends Equatable {
  const SettingsState({this.loading = false, this.saved = false});
  final bool loading, saved;
  SettingsState copyWith({bool? loading, bool? saved}) => SettingsState(
    loading: loading ?? this.loading,
    saved: saved ?? this.saved,
  );
  @override
  List<Object?> get props => [loading, saved];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this.repository) : super(const SettingsState());
  final MockSettingsRepository repository;
  Future<void> save() async {
    emit(state.copyWith(loading: true, saved: false));
    await repository.save();
    emit(state.copyWith(loading: false, saved: true));
  }
}
