import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.unauthenticated());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.errorOccurred('Veuillez remplir tous les champs');
      return;
    }

    state = state.loading();

    try {
      await Future.delayed(const Duration(seconds: 2));
      state = const AuthState.authenticated('user@example.com');
    } catch (e) {
      state = state.errorOccurred('Échec de la connexion');
    }
  }

  void logout() {
    state = const AuthState.unauthenticated();
  }
}

class AuthState extends Equatable {
  final String? email;
  final bool isLoading;
  final String? error;

  const AuthState._({this.email, this.isLoading = false, this.error});

  const AuthState.authenticated(String email) : this._(email: email);

  const AuthState.unauthenticated() : this._();

  AuthState loading() => AuthState._(isLoading: true);
  AuthState errorOccurred(String message) => AuthState._(error: message);

  @override
  List<Object?> get props => [email, isLoading, error];
}
