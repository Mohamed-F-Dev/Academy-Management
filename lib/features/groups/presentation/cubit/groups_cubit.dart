import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/data/repositories.dart';
import '../../../../shared/models/entities.dart';

class GroupsState extends Equatable {
  const GroupsState({this.loading = false, this.items = const [], this.query = ''});
  final bool loading; final List<Group> items; final String query;
  GroupsState copyWith({bool? loading, List<Group>? items, String? query}) => GroupsState(loading: loading ?? this.loading, items: items ?? this.items, query: query ?? this.query);
  @override List<Object?> get props => [loading, items, query];
}
class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit(this.repository) : super(const GroupsState()) { load(); }
  final MockGroupRepository repository;
  Future<void> load() async { emit(state.copyWith(loading: true)); emit(state.copyWith(loading: false, items: await repository.getGroups())); }
  void search(String value) => emit(state.copyWith(query: value));
  List<Group> get visible => state.items.where((g) => '${g.name} ${g.subject} ${g.teacher}'.contains(state.query)).toList();
  Future<void> save(Group item) async { await repository.save(item); await load(); }
}
