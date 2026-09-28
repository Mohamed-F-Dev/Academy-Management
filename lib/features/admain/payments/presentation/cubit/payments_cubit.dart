import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/data/repositories.dart';
import '../../../../../shared/models/entities.dart';

class PaymentsState extends Equatable {
  const PaymentsState({
    this.loading = false,
    this.items = const [],
    this.query = '',
  });
  final bool loading;
  final List<Payment> items;
  final String query;
  PaymentsState copyWith({
    bool? loading,
    List<Payment>? items,
    String? query,
  }) => PaymentsState(
    loading: loading ?? this.loading,
    items: items ?? this.items,
    query: query ?? this.query,
  );
  @override
  List<Object?> get props => [loading, items, query];
}

class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit(this.repository) : super(const PaymentsState()) {
    load();
  }
  final MockPaymentRepository repository;
  Future<void> load() async {
    emit(state.copyWith(loading: true));
    emit(state.copyWith(loading: false, items: await repository.getPayments()));
  }

  void search(String value) => emit(state.copyWith(query: value));
  List<Payment> get visible => state.items
      .where((p) => '${p.student} ${p.month}'.contains(state.query))
      .toList();
  Future<void> save(Payment item) async {
    await repository.save(item);
    await load();
  }
}
