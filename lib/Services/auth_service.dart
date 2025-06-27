import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.unauthenticated());

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(error: 'Veuillez remplir tous les champs');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (email == 'user@example.com' && password == 'password') {
        state = AuthState.authenticated(email);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false, 
          error: 'Email ou mot de passe incorrect'
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'Erreur de connexion: ${e.toString()}'
      );
      return false;
    }
  }

  Future<bool> signUp(String email, String name, String prenom, String password) async {
    if (email.isEmpty || name.isEmpty || prenom.isEmpty || password.isEmpty) {
      state = state.copyWith(error: 'Veuillez remplir tous les champs');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));
      state = AuthState.authenticated(email);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'Erreur lors de l\'inscription: ${e.toString()}'
      );
      return false;
    }
  }

  void logout() {
    state = const AuthState.unauthenticated();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class AuthState extends Equatable {
  final String? email;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState._({
    this.email,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  const AuthState.authenticated(String email) 
      : this._(email: email, isAuthenticated: true);

  const AuthState.unauthenticated() : this._();

  AuthState copyWith({
    String? email,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState._(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [email, isLoading, error, isAuthenticated];
}