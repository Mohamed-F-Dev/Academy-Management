import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UserRole { admin, teacher }
enum AuthStatus { unauthenticated, loading, authenticated, failure }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unauthenticated, this.role, this.error});
  final AuthStatus status;
  final UserRole? role;
  final String? error;
  AuthState copyWith({AuthStatus? status, UserRole? role, String? error}) => AuthState(status: status ?? this.status, role: role ?? this.role, error: error);
  @override List<Object?> get props => [status, role, error];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());
  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if ((username == 'admin' && password == 'admin123') || (username == 'teacher' && password == 'teacher123')) {
      emit(AuthState(status: AuthStatus.authenticated, role: username == 'admin' ? UserRole.admin : UserRole.teacher));
    } else {
      emit(const AuthState(status: AuthStatus.failure, error: 'اسم المستخدم أو كلمة المرور غير صحيحة'));
    }
  }
  void logout() => emit(const AuthState());
}
